
# Enroll tls-ca.cbody.com's Admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/tls/server/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/tls/admin

fabric-ca-client register -d --id.name peer1.rebel.inc --id.secret 9d8vdCdk --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name peer2.pcch.net --id.secret Trxg68PA --id.type peer -u https://0.0.0.0:6052

#############
# Rebel peer1#
#############

# Copy certificate of the TLS CA for Rebel peer1
mkdir -p /var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/assets/tls-ca/tls-ca-cert.pem

# Enroll Rebel peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.rebel.inc:9d8vdCdk@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer1.rebel.inc,127.0.0.1

mv /var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/tls-msp/keystore/* /var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/tls-msp/keystore/key.pem

#############
# Rebel peer2#
#############

# Copy certificate of the TLS CA for Rebel peer2
mkdir -p /var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/assets/tls-ca/tls-ca-cert.pem

# Enroll Rebel peer2
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2.pcch.net:Trxg68PA@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer2.rebel.inc,127.0.0.1

mv /var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/tls-msp/keystore/* /var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/tls-msp/keystore/key.pem

