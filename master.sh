sudo apt update
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.45.0-rc.0/prometheus-2.45.0-rc.0.linux-amd64.tar.gz
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
sudo mkdir /var/lib/prometheus
sudo mkdir -p /etc/prometheus/rules
sudo mkdir -p /etc/prometheus/rules.s
sudo mkdir -p /etc/prometheus/files sd
sudo tar xvf prometheus-2.45.0-rc.0.linux-amd64.tar.gz
cd prometheus-2.45.0-rc.0.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo tee /etc/systemd/system/prometheus.service<<EOF
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.external-url=

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/*
sudo chmod -R 775 /etc/prometheus
sudo chmod -R 755 /etc/prometheus/*
sudo chown -R prometheus:prometheus /var/lib/prometheus/
sudo chown -R prometheus:prometheus /var/lib/prometheus/*
sudo systemctl daemon-reload
sudo systemctl start prometheus

