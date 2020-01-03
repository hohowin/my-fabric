cd chaincode/fabcar
yarn install
yarn build

cd ../op
yarn install
yarn build

# Install chaincode
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer0 fabcar fabcar 1.0 7051"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer0 op eventstore 1.0 7051"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer0 op privatedata 1.0 7051"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer1 fabcar fabcar 1.0 7151"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer1 op eventstore 1.0 7151"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer1 op privatedata 1.0 7151"
docker exec cli.gov.hk sh -c "/setup/install_chaincode.sh gov.hk peer0 fabcar fabcar 1.0 7251"
docker exec cli.gov.hk sh -c "/setup/install_chaincode.sh gov.hk peer0 op eventstore 1.0 7251"
docker exec cli.gov.hk sh -c "/setup/install_chaincode.sh gov.hk peer0 op privatedata 1.0 7251"
docker exec cli.gov.hk sh -c "/setup/install_chaincode.sh gov.hk peer1 fabcar fabcar 1.0 7351"
docker exec cli.gov.hk sh -c "/setup/install_chaincode.sh gov.hk peer1 op eventstore 1.0 7351"
docker exec cli.gov.hk sh -c "/setup/install_chaincode.sh gov.hk peer1 op privatedata 1.0 7351"

# Instantiate chaincode
docker exec cli.pcch.net sh -c "/setup/instantiate_chaincode_org1.sh"

# Invoke chaincode
docker exec cli.pcch.net sh -c "/setup/invoke_chaincode_org1.sh"