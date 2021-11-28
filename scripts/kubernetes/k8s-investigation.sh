#!/usr/bin/env bash
set -e
if [ ! $1 ]; then
    echo "Requires argument: <create/<delete>"
    exit 0
fi
cat <<EOF | kubectl $1 -f -
apiVersion: v1
kind: Namespace
metadata:
  name: investigation

---

apiVersion: apps/v1
kind: DaemonSet
metadata:
  namespace: investigation
  name: nginx
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      terminationGracePeriodSeconds: 30
      tolerations:
      - key: node-role.kubernetes.io/controlplane
        value: "true"
        effect: NoSchedule
      - key: node-role.kubernetes.io/etcd
        value: "true"
        effect: NoExecute
      - key: cattle.io/os
        value: "linux"
        effect: NoSchedule
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: all
          mountPath: /host
      volumes:
         - name: all
           hostPath:
               path: /
EOF
