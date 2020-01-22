
# Enroll tls-ca.cbody.com's Admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/tls/server/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/tls/admin

fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminPW@0.0.0.0:6052
fabric-ca-client register -d --id.name peer0.pcch.net --id.secret 9d8vdCdk --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name peer1.pcch.net --id.secret Trxg68PA --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name peer0.gov.wakanda --id.secret zkZDG96L --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name peer1.gov.wakanda --id.secret 4KnyJmwB --id.type peer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer0.cbody.com --id.secret PCzEE5x2 --id.type orderer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer1.cbody.com --id.secret E9Rd54w2 --id.type orderer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer2.cbody.com --id.secret x4Y95QFC --id.type orderer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer3.cbody.com --id.secret gf4ZKPSU --id.type orderer -u https://0.0.0.0:6052
fabric-ca-client register -d --id.name orderer4.cbody.com --id.secret NhZM2pLZ --id.type orderer -u https://0.0.0.0:6052

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
fabric-ca-client enroll -d -u https://peer0.pcch.net:9d8vdCdk@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer0.pcch.net,127.0.0.1

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
fabric-ca-client enroll -d -u https://peer1.pcch.net:Trxg68PA@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer1.pcch.net,127.0.0.1

mv /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/tls-msp/keystore/* /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/tls-msp/keystore/key.pem

#############
# WakandaGov peer0#
#############

# Copy certificate of the TLS CA for WakandaGov peer0
mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/tls-ca/tls-ca-cert.pem

# Enroll WakandaGov peer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer0.gov.wakanda:zkZDG96L@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer0.gov.wakanda,127.0.0.1

mv /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/tls-msp/keystore/* /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/tls-msp/keystore/key.pem

#############
# WakandaGov peer1#
#############

# Copy certificate of the TLS CA for WakandaGov peer1
mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/assets/tls-ca/tls-ca-cert.pem

# Enroll WakandaGov peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.gov.wakanda:4KnyJmwB@0.0.0.0:6052 --enrollment.profile tls --csr.hosts peer1.gov.wakanda,127.0.0.1

mv /var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/tls-msp/keystore/* /var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/tls-msp/keystore/key.pem


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
fabric-ca-client enroll -d -u https://orderer0.cbody.com:PCzEE5x2@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer0.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer1
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1.cbody.com:E9Rd54w2@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer1.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer2
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer2
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer2.cbody.com:x4Y95QFC@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer2.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer3
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer3
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer3.cbody.com:gf4ZKPSU@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer3.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca.cbody.com for CBody orderer4
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/tls-ca
cp /var/artifacts/crypto-config/CBodyMSP/tls/admin/msp/cacerts/0-0-0-0-6052.pem /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for CBody orderer4
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer4.cbody.com:NhZM2pLZ@0.0.0.0:6052 --enrollment.profile tls --csr.hosts orderer4.cbody.com,127.0.0.1

mv /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/tls-msp/keystore/* /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/tls-msp/keystore/key.pem

