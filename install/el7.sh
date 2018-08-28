#!/bin/sh 

yum  -y install golang
GOPATH=/usr/local go get -u github.com/justwatchcom/elasticsearch_exporter

cat << EOF > /etc/systemd/system/elasticsearch_exporter.service
[Unit]
Description=Prometheus elasticsearch_exporter
After=local-fs.target network-online.target network.target
Wants=local-fs.target network-online.target network.target

[Service]
User=root
Nice=10
ExecStart = /usr/local/bin/elasticsearch_exporter -es.all -es.indices -es.timeout 20s
ExecStop= /usr/bin/killall elasticsearch_exporter

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl enable elasticsearch_exporter.service
systemctl start  elasticsearch_exporter.service
