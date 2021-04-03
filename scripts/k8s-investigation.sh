#!/usr/bin/env bash
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Namespace
metadata:
  name: test

---

apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: test
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: rancher/nginx:1.14.2
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
