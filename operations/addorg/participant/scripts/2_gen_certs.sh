cd ../config;
docker-compose -f ca.yaml up -d
sleep 5
docker exec rca.rebel.inc sh -c "/setup/enroll_addorg.sh"
sleep 2
docker-compose -f peernode1.yaml -f peernode2.yaml -f cli.yaml up -d