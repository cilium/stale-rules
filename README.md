# Cilium Stale Rules

This program detects and optionally removes stale routing rules found on a
node. The fix to automatically cleanup the stale rules is in v1.7.4. This tool
is useful for clusters which are or were running Cilium prior to v1.7.4.

The rules that this tool looks for are rules that are created in ENI or Azure
IPAM mode. These rules are created with priority `20` and `110`. The tool
considers a rule stale by checking if an endpoint on the node has the IP
address inside the rule. If the IP address inside the rule doesn't correspond
to an endpoint, it is considered stale (as long as it has the correct
priorities mentioned earlier).

## Usage

First, compile the tool:

```
go build -o stale-rules
```

It can be run with three options:

```
$ stale-rules -help     # Shows usage info
$ stale-rules -remove   # This removes the found stale rules
$ stale-rules -verbose  # Enables verbose output
```

Running without `-remove` will just detect if there are any stale rules, but
not remove.

## Deployment

*Important*: Cilium must be running on all nodes. The stale rule detection will
only proceed if there is a Cilium Agent to connect to.

Note: You can modify the args to the program in the YAML below to run it with
`-remove`. By default, this daemonset will simply log the stale rules it
detects.

```
 kubectl -n kube-system create -f install/daemonset.yaml
```
