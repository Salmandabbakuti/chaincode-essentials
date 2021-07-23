echo "Removing key from key store..."

rm -rf ./hfc-key-store

# Remove chaincode docker image
sudo docker rmi -f dev-peer0.org1.example.com-mycc-1.0-384f11f484b9302df90b453200cfb25174305fce8f53f4e94d45ee3b6cab0ce9
sleep 2

cd ../basic-network
./start.sh

sudo docker ps -a



echo 'Installing Student contract..'
sudo docker exec -it cli peer chaincode install -n mycc -v 1.0 -p "/opt/gopath/src/github.com/chaincode" -l "node"

echo 'Instantiating Student contract..'
sudo docker exec -it cli peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n mycc -l "node" -v 1.0 -c '{"Args":[]}'

echo 'Getting things ready for chaincode operations..should take only 10 seconds..'

sleep 10

echo 'Adding Student'

sudo docker exec -it cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"addStudent","Args":["SID12345","Alice","12","Male","7"]}'

sleep 2
echo 'Querying student'

sudo docker exec -it cli peer chaincode query -C mychannel -n mycc -c '{"function":"queryStudent","Args":["SID12345"]}'

echo 'Updating Student'

sudo docker exec -it cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"updateStudent","Args":["SID12345","Alice joe","13","Male","8"]}'

sleep 2
echo 'Querying updated student'

sudo docker exec -it cli peer chaincode query -C mychannel -n mycc -c '{"function":"queryStudent","Args":["SID12345"]}'


 echo 'deleting student'

sudo docker exec -it cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc -c '{"function":"deleteStudent","Args":["SID12345"]}'

sleep 5
# Starting docker logs of chaincode container

sudo docker logs -f dev-peer0.org1.example.com-mycc-1.0


