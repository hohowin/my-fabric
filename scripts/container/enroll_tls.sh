
# Enroll tls-ca.cbody.com's Admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/tls/server/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/tls/admin

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
mkdir -p /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/tls-ca/tls-ca-cert.pem

# Enroll PccH peer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/PccHMSP/peer0.pcch.net
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer0.pcch.net:peer0PW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer0.pcch.net,127.0.0.1

mv /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/tls-msp/keystore/* /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/tls-msp/keystore/key.pem

#############
# PccH peer1#
#############

# Copy certificate of the TLS CA for PccH peer1
mkdir -p /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/assets/tls-ca/tls-ca-cert.pem

# Enroll PccH peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/PccHMSP/peer1.pcch.net
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.pcch.net:peer1PW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer1.pcch.net,127.0.0.1

mv /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/tls-msp/keystore/* /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/tls-msp/keystore/key.pem

#############
# HKGov peer0#
#############

# Copy certificate of the TLS CA for HKGov peer0
mkdir -p /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets/tls-ca/tls-ca-cert.pem

# Enroll HKGov peer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer0.gov.hk:peer0PW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer0.gov.hk,127.0.0.1

mv /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/tls-msp/keystore/* /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/tls-msp/keystore/key.pem

#############
# HKGov peer1#
#############

# Copy certificate of the TLS CA for HKGov peer1
mkdir -p /var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/assets/tls-ca/tls-ca-cert.pem

# Enroll HKGov peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.gov.hk:peer1PW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer1.gov.hk,127.0.0.1

mv /var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/tls-msp/keystore/* /var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/tls-msp/keystore/key.pem


###########
# Orderer #
###########

# Copy certificate of tls-ca.cbody.com for CBody orderer0
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer0.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer0.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer1
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer1.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer2
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer2
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer2.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer2.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer3
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer3
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer3.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer3.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer4
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer4
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer4.cbody.com:ordererPW@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer4.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/tls-msp/keystore/key.pem

