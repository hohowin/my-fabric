
# Enroll tls-ca.cbody.com's Admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/tls-ca.cbody.com/server/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/tls-ca.cbody.com/admin

fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminPW@0.0.0.0:6052
fabric-ca-client register -d --id.name peer0.pcch.net --id.secret peer0PW --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name peer1.pcch.net --id.secret peer1PW --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name peer0.gov.hk --id.secret peer0PW --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name peer1.gov.hk --id.secret peer1PW --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer0.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer1.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer2.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer3.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer4.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6052

#############
# PccH peer0#
#############

# Copy certificate of the TLS CA for PccH peer0
mkdir -p /var/artifacts/crypto-config/pcch.net/peer0/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/pcch.net/peer0/assets/tls-ca/tls-ca-cert.pem

# Enroll PccH peer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/pcch.net/peer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/pcch.net/peer0/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer0.pcch.net:peer0PW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer0.pcch.net,127.0.0.1

mv /var/artifacts/crypto-config/pcch.net/peer0/tls-msp/keystore/* /var/artifacts/crypto-config/pcch.net/peer0/tls-msp/keystore/key.pem

#############
# PccH peer1#
#############

# Copy certificate of the TLS CA for PccH peer1
mkdir -p /var/artifacts/crypto-config/pcch.net/peer1/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/pcch.net/peer1/assets/tls-ca/tls-ca-cert.pem

# Enroll PccH peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/pcch.net/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/pcch.net/peer1/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.pcch.net:peer1PW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer1.pcch.net,127.0.0.1

mv /var/artifacts/crypto-config/pcch.net/peer1/tls-msp/keystore/* /var/artifacts/crypto-config/pcch.net/peer1/tls-msp/keystore/key.pem

#############
# HKGov peer0#
#############

# Copy certificate of the TLS CA for HKGov peer0
mkdir -p /var/artifacts/crypto-config/gov.hk/peer0/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/gov.hk/peer0/assets/tls-ca/tls-ca-cert.pem

# Enroll HKGov peer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/gov.hk/peer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/gov.hk/peer0/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer0.gov.hk:peer0PW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer0.gov.hk,127.0.0.1

mv /var/artifacts/crypto-config/gov.hk/peer0/tls-msp/keystore/* /var/artifacts/crypto-config/gov.hk/peer0/tls-msp/keystore/key.pem

#############
# HKGov peer1#
#############

# Copy certificate of the TLS CA for HKGov peer1
mkdir -p /var/artifacts/crypto-config/gov.hk/peer1/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/gov.hk/peer1/assets/tls-ca/tls-ca-cert.pem

# Enroll HKGov peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/gov.hk/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/gov.hk/peer1/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.gov.hk:peer1PW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer1.gov.hk,127.0.0.1

mv /var/artifacts/crypto-config/gov.hk/peer1/tls-msp/keystore/* /var/artifacts/crypto-config/gov.hk/peer1/tls-msp/keystore/key.pem


###########
# Orderer #
###########

# Copy certificate of tls-ca.cbody.com for CBody orderer0
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer0/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/cbody.com/orderer0/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer0/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer0.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer0.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/cbody.com/orderer0/tls-msp/keystore/* /var/artifacts/crypto-config/cbody.com/orderer0/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer1
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer1/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/cbody.com/orderer1/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer1/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer1.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/cbody.com/orderer1/tls-msp/keystore/* /var/artifacts/crypto-config/cbody.com/orderer1/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer2
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer2/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/cbody.com/orderer2/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer2
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer2/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer2.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer2.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/cbody.com/orderer2/tls-msp/keystore/* /var/artifacts/crypto-config/cbody.com/orderer2/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer3
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer3/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/cbody.com/orderer3/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer3
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer3
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer3/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer3.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer3.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/cbody.com/orderer3/tls-msp/keystore/* /var/artifacts/crypto-config/cbody.com/orderer3/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer4
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer4/assets/tls-ca
cp /var/artifacts/crypto-config/tls-ca.cbody.com/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/cbody.com/orderer4/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer4
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer4
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer4/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer4.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer4.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/cbody.com/orderer4/tls-msp/keystore/* /var/artifacts/crypto-config/cbody.com/orderer4/tls-msp/keystore/key.pem
