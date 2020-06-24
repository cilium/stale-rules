module github.com/cilium/stale-rules

go 1.14

replace (
	github.com/miekg/dns => github.com/cilium/dns v1.1.4-0.20190417235132-8e25ec9a0ff3
	github.com/optiopay/kafka => github.com/cilium/kafka v0.0.0-20180809090225-01ce283b732b

	// v0.0.0-20200312205431-8d8aa3959853 -> k8s v1.17.4
	k8s.io/api => k8s.io/kubernetes/staging/src/k8s.io/api v0.0.0-20200312205431-8d8aa3959853
	k8s.io/apiextensions-apiserver => k8s.io/kubernetes/staging/src/k8s.io/apiextensions-apiserver v0.0.0-20200312205431-8d8aa3959853
	k8s.io/apimachinery => k8s.io/kubernetes/staging/src/k8s.io/apimachinery v0.0.0-20200312205431-8d8aa3959853
	k8s.io/apiserver => k8s.io/kubernetes/staging/src/k8s.io/apiserver v0.0.0-20200312205431-8d8aa3959853
	k8s.io/cli-runtime => k8s.io/kubernetes/staging/src/k8s.io/cli-runtime v0.0.0-20200312205431-8d8aa3959853
	k8s.io/client-go => github.com/cilium/client-go v0.0.0-20200323094943-b43e7e2f9a75
	k8s.io/cloud-provider => k8s.io/kubernetes/staging/src/k8s.io/cloud-provider v0.0.0-20200312205431-8d8aa3959853
	k8s.io/cluster-bootstrap => k8s.io/kubernetes/staging/src/k8s.io/cluster-bootstrap v0.0.0-20200312205431-8d8aa3959853
	k8s.io/code-generator => k8s.io/kubernetes/staging/src/k8s.io/code-generator v0.0.0-20200312205431-8d8aa3959853
	k8s.io/component-base => k8s.io/kubernetes/staging/src/k8s.io/component-base v0.0.0-20200312205431-8d8aa3959853
	k8s.io/cri-api => k8s.io/kubernetes/staging/src/k8s.io/cri-api v0.0.0-20200312205431-8d8aa3959853
	k8s.io/csi-translation-lib => k8s.io/kubernetes/staging/src/k8s.io/csi-translation-lib v0.0.0-20200312205431-8d8aa3959853
	k8s.io/gengo => k8s.io/gengo v0.0.0-20190822140433-26a664648505
	k8s.io/heapster => k8s.io/heapster v1.2.0-beta.1
	k8s.io/klog => k8s.io/klog v1.0.0
	k8s.io/kube-aggregator => k8s.io/kubernetes/staging/src/k8s.io/kube-aggregator v0.0.0-20200312205431-8d8aa3959853
	k8s.io/kube-controller-manager => k8s.io/kubernetes/staging/src/k8s.io/kube-controller-manager v0.0.0-20200312205431-8d8aa3959853
	k8s.io/kube-openapi => k8s.io/kube-openapi v0.0.0-20191107075043-30be4d16710a
	k8s.io/kube-proxy => k8s.io/kubernetes/staging/src/k8s.io/kube-proxy v0.0.0-20200312205431-8d8aa3959853
	k8s.io/kube-scheduler => k8s.io/kubernetes/staging/src/k8s.io/kube-scheduler v0.0.0-20200312205431-8d8aa3959853
	k8s.io/kubectl => k8s.io/kubernetes/staging/src/k8s.io/kubectl v0.0.0-20200312205431-8d8aa3959853
	k8s.io/kubelet => k8s.io/kubernetes/staging/src/k8s.io/kubelet v0.0.0-20200312205431-8d8aa3959853
	k8s.io/kubernetes => k8s.io/kubernetes v1.17.4
	k8s.io/legacy-cloud-providers => k8s.io/kubernetes/staging/src/k8s.io/legacy-cloud-providers v0.0.0-20200312205431-8d8aa3959853
	k8s.io/metrics => k8s.io/kubernetes/staging/src/k8s.io/metrics v0.0.0-20200312205431-8d8aa3959853
	k8s.io/sample-apiserver => k8s.io/kubernetes/staging/src/k8s.io/sample-apiserver v0.0.0-20200312205431-8d8aa3959853
)

require (
	github.com/cilium/cilium v1.8.0
	github.com/sirupsen/logrus v1.4.2
	github.com/vishvananda/netlink v1.1.1-0.20200603190939-5a869a71f0cb
)
