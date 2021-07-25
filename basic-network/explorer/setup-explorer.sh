echo 'Starting Hyperledger Explorer setup for basic network model..'
sudo docker-compose -f explorer-basic.yaml down
sudo docker volume prune
sudo docker network prune
sudo docker-compose -f explorer-basic.yaml up -d
echo 'All Done.. Goto port 8080. check for docker logs if any error..'
exit 1