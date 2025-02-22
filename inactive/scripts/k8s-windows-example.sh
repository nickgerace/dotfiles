#!/usr/bin/env bash
set -e

# Source: https://kubernetes.io/docs/setup/production-environment/windows/user-guide-windows-containers/#getting-started-deploying-a-windows-container
if [ ! $1 ]; then
  echo "required argument: <create>/<delete>"
  exit 1
fi

cat <<EOF | kubectl $1 -f -
apiVersion: v1
kind: Namespace
metadata:
  name: windows
---
apiVersion: v1
kind: Service
metadata:
  name: win-webserver
  namespace: windows
  labels:
    app: win-webserver
spec:
  ports:
    - port: 80
      targetPort: 80
  selector:
    app: win-webserver
  type: NodePort
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: win-webserver
  name: win-webserver
  namespace: windows
spec:
  selector:
    matchLabels:
      app: win-webserver
  template:
    metadata:
      labels:
        app: win-webserver
      name: win-webserver
    spec:
      containers:
      - name: windowswebserver
        image: mcr.microsoft.com/windows/servercore:20H2
        volumeMounts:
        - name: all
          mountPath: "/host"
        command:
        - powershell.exe
        - -command
        - "<#code used from https://gist.github.com/19WAS85/5424431#> ; $$listener = New-Object System.Net.HttpListener ; $$listener.Prefixes.Add('http://*:80/') ; $$listener.Start() ; $$callerCounts = @{} ; Write-Host('Listening at http://*:80/') ; while ($$listener.IsListening) { ;$$context = $$listener.GetContext() ;$$requestUrl = $$context.Request.Url ;$$clientIP = $$context.Request.RemoteEndPoint.Address ;$$response = $$context.Response ;Write-Host '' ;Write-Host('> {0}' -f $$requestUrl) ;  ;$$count = 1 ;$$k=$$callerCounts.Get_Item($$clientIP) ;if ($$k -ne $$null) { $$count += $$k } ;$$callerCounts.Set_Item($$clientIP, $$count) ;$$ip=(Get-NetAdapter | Get-NetIpAddress); $$header='<html><body><H1>Windows Container Web Server</H1>' ;$$callerCountsString='' ;$$callerCounts.Keys | % { $$callerCountsString+='<p>IP {0} callerCount {1} ' -f $$ip[1].IPAddress,$$callerCounts.Item($$_) } ;$$footer='</body></html>' ;$$content='{0}{1}{2}' -f $$header,$$callerCountsString,$$footer ;Write-Output $$content ;$$buffer = [System.Text.Encoding]::UTF8.GetBytes($$content) ;$$response.ContentLength64 = $$buffer.Length ;$$response.OutputStream.Write($$buffer, 0, $$buffer.Length) ;$$response.Close() ;$$responseStatus = $$response.StatusCode ;Write-Host('< {0}' -f $$responseStatus)  } ; "
      nodeSelector:
        kubernetes.io/os: windows
      volumes:
        - name: all
          hostPath:
              path: "/"
EOF
