#!/bin/bash - 
set -o nounset                              # Treat unset variables as an error
set -e

ISTIO_VERSION=1.13.1
# curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.12.6 sh -
# ISTIO_VERSION=1.12.6

export CTX_CLUSTER1=cluster1
export CTX_CLUSTER2=cluster2

minikube delete  --profile cluster2
minikube delete  --profile cluster1

#minikube start --vm-driver=kvm2 --memory 6144  --cpus 4 --profile cluster1 --kubernetes-version v1.22.8
#minikube start --vm-driver=kvm2 --memory 6144  --cpus 4 --profile cluster2 --kubernetes-version v1.22.8

minikube start --vm-driver=kvm2 --memory 6144  --cpus 4 --profile cluster1
minikube start --vm-driver=kvm2 --memory 6144  --cpus 4 --profile cluster2 

#minikube start --vm-driver=kvm2 --memory 8192  --cpus 4 --profile cluster1
#minikube start --vm-driver=kvm2 --memory 8192  --cpus 4 --profile cluster2
minikube addons enable metallb --profile=cluster1
minikube addons enable metallb --profile=cluster2
#echo "Install istio"
#minikube addons enable istio --profile=cluster1
#minikube addons enable istio --profile=cluster2
#kubectl --context="${CTX_CLUSTER1}" label namespace istio-system topology.istio.io/network=network1
#kubectl --context="${CTX_CLUSTER1}" label namespace istio-system topology.istio.io/network=network2

kubectl --context ${CTX_CLUSTER1} apply -f metallb1.yaml
kubectl --context ${CTX_CLUSTER2} apply -f metallb2.yaml

echo "Push certificates"
# https://istio.io/latest/docs/tasks/security/cert-management/plugin-ca-cert/
# cd ~/istio-${ISTIO_VERSION}
# mkdir -p certs
# pushd certs
# make -f ../tools/certs/Makefile.selfsigned.mk root-ca
# make -f ../tools/certs/Makefile.selfsigned.mk cluster1-cacerts
# make -f ../tools/certs/Makefile.selfsigned.mk cluster2-cacerts
# popd

for i in 1 2; do
 kubectl --context cluster${i} get ns | grep '^istio-system' || kubectl --context cluster${i} create namespace istio-system
 kubectl --context cluster${i} create secret generic cacerts -n istio-system \
      --from-file=certs/cluster${i}/ca-cert.pem \
      --from-file=certs/cluster${i}/ca-key.pem \
      --from-file=certs/cluster${i}/root-cert.pem \
      --from-file=certs/cluster${i}/cert-chain.pem
done

#istioctl install -y --context="${CTX_CLUSTER1}"  --set profile=demo
#istioctl install -y --context="${CTX_CLUSTER2}"  --set profile=demo

cat <<EOF > cluster1.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: cluster1
      network: network1
EOF

istiotl install -y --context="${CTX_CLUSTER1}" -f cluster1.yaml

cd ~/istio-${ISTIO_VERSION}

samples/multicluster/gen-eastwest-gateway.sh \
    --mesh mesh1 --cluster cluster1 --network network1 | \
    istioctl -y --context="${CTX_CLUSTER1}" install -y -f -

echo "Please check 'kubectl --context="${CTX_CLUSTER1}" get svc istio-eastwestgateway -n istio-system' and press enter"
read

kubectl apply --context="${CTX_CLUSTER1}" -n istio-system -f \
    samples/multicluster/expose-istiod.yaml

kubectl --context="${CTX_CLUSTER1}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml

istioctl x create-remote-secret \
    --context="${CTX_CLUSTER2}" \
    --name=cluster2 | \
    kubectl apply -f - --context="${CTX_CLUSTER1}"

export DISCOVERY_ADDRESS=$(kubectl \
    --context="${CTX_CLUSTER1}" \
    -n istio-system get svc istio-eastwestgateway \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

cd -

cat <<EOF > cluster2.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: cluster2
      network: network2
      remotePilotAddress: ${DISCOVERY_ADDRESS}
EOF

istioctl install -y --context="${CTX_CLUSTER2}" -f cluster2.yaml

cd ~/istio-${ISTIO_VERSION}

samples/multicluster/gen-eastwest-gateway.sh \
    --mesh mesh1 --cluster cluster2 --network network2 | \
    istioctl --context="${CTX_CLUSTER2}" install -y -f -


echo "Please check 'kubectl --context="${CTX_CLUSTER2}" get svc istio-eastwestgateway -n istio-system' and press enter"
read

kubectl --context="${CTX_CLUSTER2}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml



