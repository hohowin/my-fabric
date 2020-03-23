# Cleanup the environment
docker rm -f $(docker ps -aq)
docker volume prune -f
docker network prune -f
docker system prune -f

# Cleanup artifacts
case $(uname -s) in
    Darwin)
        rm -rf network/config/../artifacts;;
   *)
        sudo rm -rf network/config/../artifacts;;
esac

# Cleanup chaincode images
docker rmi -f $(docker images | grep fabcar | awk '{print $3}')
docker rmi -f $(docker images | grep eventstore | awk '{print $3}')
docker rmi -f $(docker images | grep privatedata | awk '{print $3}')

# Cleanup chaincode builds
export _CHAINCODE_DIR=chaincode
rm -rf ${_CHAINCODE_DIR}/fabcar/dist
rm -rf ${_CHAINCODE_DIR}/fabcar/node_modules
rm -f ${_CHAINCODE_DIR}/fabcar/yarn.lock
rm -rf ${_CHAINCODE_DIR}/op/dist
rm -rf ${_CHAINCODE_DIR}/op/node_modules
rm -f ${_CHAINCODE_DIR}/op/yarn.lock