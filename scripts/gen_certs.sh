docker exec tls-ca.cbody.com sh -c "/setup/enroll_tls.sh"
docker exec rca.cbody.com sh -c "/setup/enroll_org0.sh"
docker exec rca.pcch.net sh -c "/setup/enroll_org1.sh"
docker exec rca.gov.wakanda sh -c "/setup/enroll_org2.sh"
