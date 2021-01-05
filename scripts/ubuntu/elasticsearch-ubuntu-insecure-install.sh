#!/usr/bin/env bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -    
sudo apt-get install -y apt-transport-https    
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list    
sudo apt-get update    
sudo apt-get install -y elasticsearch
sudo apt autoremove -y
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
echo "http.port: 9200" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.type: single-node" >> /etc/elasticsearch/elasticsearch.yml
sudo ufw allow 9200
sudo ufw enable
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
sleep 10
curl -X GET "localhost:9200/?pretty"
printf "[WARNING] This is an insecure ElasticSearch setup meant for development only.\n"
