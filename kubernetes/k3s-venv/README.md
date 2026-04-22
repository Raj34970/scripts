
helm create lxhome-venv
kubectl create configmap lxhome-venv --from-file=main.py --from-file=requirements.txt
helm install my-python-venv ./lxhome-venv