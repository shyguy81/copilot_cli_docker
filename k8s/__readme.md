
## Préparation du namespace

Exécuter dans un terminal:

```bash
kubectl create ns copilot-cli-ns
kubectl config set-context --current --namespace=copilot-cli-ns
#
kubectl apply -f _cm/secrets.yaml
#
kubectl apply -f _cli/copilot-cli-sts.yaml
kubectl apply -f _cli/copilot-cli-svc-nodeport.yaml
#
kubectl -n copilot-cli-ns get pods
#
kubectl -n copilot-cli-ns exec -it copilot-cli-pod-0 -- bash
#
kubectl get nodes -o wide
```
