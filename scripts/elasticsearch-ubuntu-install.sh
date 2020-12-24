#!/usr/bin/env bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -    
sudo apt-get install -y apt-transport-https    
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list    
sudo apt-get update    
sudo apt-get install -y elasticsearch
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
sleep 10
curl -X GET "localhost:9200/?pretty"

if [ $1 ] && [ "${1}" == "kibana"]; then
    sudo apt-get install -y kibana
    sudo /bin/systemctl daemon-reload
    sudo /bin/systemctl enable kibana.service
    sudo systemctl start kibana.service
    sleep 10
    printf "ElasticSearch and Kibana should be running!\n"
fi
