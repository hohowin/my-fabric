cd chaincode/fabcar
yarn install
yarn build

cd ../op
yarn install
yarn build

# Install chaincode
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer0 fabcar fabcar 1.0 7051 PccHMSP/admin PccHMSP/peer0.pcch.net"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer0 op eventstore 1.0 7051 PccHMSP/admin PccHMSP/peer0.pcch.net"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer0 op privatedata 1.0 7051 PccHMSP/admin PccHMSP/peer0.pcch.net"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer1 fabcar fabcar 1.0 7151 PccHMSP/admin PccHMSP/peer1.pcch.net"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer1 op eventstore 1.0 7151 PccHMSP/admin PccHMSP/peer1.pcch.net"
docker exec cli.pcch.net sh -c "/setup/install_chaincode.sh pcch.net peer1 op privatedata 1.0 7151 PccHMSP/admin PccHMSP/peer1.pcch.net"
docker exec cli.gov.wakanda sh -c "/setup/install_chaincode.sh gov.wakanda peer0 fabcar fabcar 1.0 7251 WakandaGovMSP/admin WakandaGovMSP/peer0.gov.wakanda"
docker exec cli.gov.wakanda sh -c "/setup/install_chaincode.sh gov.wakanda peer0 op eventstore 1.0 7251 WakandaGovMSP/admin WakandaGovMSP/peer0.gov.wakanda"
docker exec cli.gov.wakanda sh -c "/setup/install_chaincode.sh gov.wakanda peer0 op privatedata 1.0 7251 WakandaGovMSP/admin WakandaGovMSP/peer0.gov.wakanda"
docker exec cli.gov.wakanda sh -c "/setup/install_chaincode.sh gov.wakanda peer1 fabcar fabcar 1.0 7351 WakandaGovMSP/admin WakandaGovMSP/peer1.gov.wakanda"
docker exec cli.gov.wakanda sh -c "/setup/install_chaincode.sh gov.wakanda peer1 op eventstore 1.0 7351 WakandaGovMSP/admin WakandaGovMSP/peer1.gov.wakanda"
docker exec cli.gov.wakanda sh -c "/setup/install_chaincode.sh gov.wakanda peer1 op privatedata 1.0 7351 WakandaGovMSP/admin WakandaGovMSP/peer1.gov.wakanda"

# Instantiate chaincode
docker exec cli.pcch.net sh -c "/setup/instantiate_chaincode_org1.sh"

# Invoke chaincode
docker exec cli.pcch.net sh -c "/setup/invoke_chaincode_org1.sh"