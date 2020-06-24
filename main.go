package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/cilium/cilium/api/v1/models"
	"github.com/cilium/cilium/pkg/client"
	"github.com/cilium/cilium/pkg/datapath/linux/linux_defaults"
	"github.com/cilium/cilium/pkg/datapath/linux/route"
	"github.com/cilium/cilium/pkg/logging"

	"github.com/sirupsen/logrus"
	"github.com/vishvananda/netlink"
)

var (
	log = logging.DefaultLogger

	help, remove, verbose *bool
)

func main() {
	parseFlags()

	if *help {
		usage()
		return
	}

	if *verbose {
		log.SetLevel(logrus.DebugLevel)
	}

	c, err := client.NewClient("")
	if err != nil {
		log.WithError(err).Fatal("Cannot create Cilium client")
	}

	log.Debug("Connected to Cilium API")

	endpoints, err := c.EndpointList()
	if err != nil {
		log.WithError(err).Fatal("Cannot list Cilium endpoints")
	}

	log.Debugf("Found %d endpoints on node", len(endpoints))

	ips := make(map[string]struct{}, len(endpoints))
	for _, e := range endpoints {
		if ip := hasIP(e); ip != "" {
			ips[ip] = struct{}{}
		} else {
			log.Debugf("Skipping endpoint %d due to lack of IP addr", e.ID)
			continue
		}
	}

	var (
		all     = make([]netlink.Rule, 0, 64)
		deleted int
	)

	ingress, err := route.ListRules(netlink.FAMILY_V4, &route.Rule{
		Priority: linux_defaults.RulePriorityIngress,
	})
	if err != nil {
		log.WithField("error", err).Fatal("Failed to list ingress rules")
	}
	all = append(all, ingress...)

	egress, err := route.ListRules(netlink.FAMILY_V4, &route.Rule{
		Priority: linux_defaults.RulePriorityEgress,
	})
	if err != nil {
		log.WithField("error", err).Fatal("Failed to list egress rules")
	}
	all = append(all, egress...)

	for _, r := range all {
		sok, dok := true, true

		if r.Priority == linux_defaults.RulePriorityIngress && r.Dst != nil {
			_, dok = ips[r.Dst.IP.String()]
		}
		if r.Priority == linux_defaults.RulePriorityEgress && r.Src != nil {
			_, sok = ips[r.Src.IP.String()]
		}

		prettyRule := rule{r}.String()

		if !sok || !dok {
			deleted++

			if *remove {
				err := netlink.RuleDel(&r)
				if err != nil {
					log.WithFields(logrus.Fields{
						"error": err,
						"rule":  prettyRule,
					}).Error("Failed to delete rule")
				}

				log.WithField("rule", prettyRule).Info("Deleting rule")
			} else {
				log.WithField("rule", prettyRule).Info("Found stale rule")
			}
		}
	}

	if *remove {
		log.Infof("Deleted %d stale rules", deleted)
	} else {
		log.Infof("Found %d stale rules; none were deleted", deleted)
	}
}

// rule is a wrapper over the netlink.Rule type so we can expand the String
// representation of it for better readability. See
// https://github.com/vishvananda/netlink/issues/550
type rule struct {
	netlink.Rule
}

func (r rule) String() string {
	return fmt.Sprintf("ip rule %d: from %s to %s table %d",
		r.Priority, r.Src, r.Dst, r.Table)
}

func hasIP(e *models.Endpoint) string {
	if e.Status != nil &&
		e.Status.Networking != nil &&
		e.Status.Networking.Addressing != nil &&
		e.Status.Networking.Addressing[0].IPV4 != "" {
		return e.Status.Networking.Addressing[0].IPV4
	}

	return ""
}

func parseFlags() {
	help = flag.Bool("help", false, "Show usage")
	remove = flag.Bool("remove", false, "Remove stale rules that are found")
	verbose = flag.Bool("verbose", false, "Show verbose output")
	flag.Parse()
}

func usage() {
	fmt.Printf("%s [options]\n", os.Args[0])

	msg := `
This tool is used to clean up stale rules left over in ENI or Azure mode.
The only rules considered are rules with the priority set to 20 or 110, as
we know these are likely Cilium-created and left over.
`
	fmt.Println(msg)

	flag.Usage()
}
