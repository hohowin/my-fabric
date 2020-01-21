# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/CBodyMSP/ca/crypto
cp /var/artifacts/crypto-config/CBodyMSP/ca/server/ca-cert.pem /var/artifacts/crypto-config/CBodyMSP/ca/crypto

# Enroll Orderer Org's CA Admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/ca/admin

fabric-ca-client enroll -d -u https://rca-hktfp-admin:rca-hktfp-adminPW@0.0.0.0:6053
fabric-ca-client register -d --id.name orderer0.cbody.com --id.secret DPCxKv8m --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name orderer1.cbody.com --id.secret PCzEE5x2 --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name orderer2.cbody.com --id.secret T2ZNRe8x --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name orderer3.cbody.com --id.secret 7B5qMkhg --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name orderer4.cbody.com --id.secret p8Maufjr --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name admin-cbody.com --id.secret sR7w9xWY --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:6053

# Copy Trusted Root Cert of CBody orderer0
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/assets/ca
cp /var/artifacts/crypto-config/CBodyMSP/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/assets/ca/cbody.com-ca-cert.pem
# Copy Trusted Root Cert of CBody orderer1
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/ca
cp /var/artifacts/crypto-config/CBodyMSP/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/ca/cbody.com-ca-cert.pem
# Copy Trusted Root Cert of CBody orderer2
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/ca
cp /var/artifacts/crypto-config/CBodyMSP/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/ca/cbody.com-ca-cert.pem
# Copy Trusted Root Cert of CBody orderer3
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/ca
cp /var/artifacts/crypto-config/CBodyMSP/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/ca/cbody.com-ca-cert.pem
# Copy Trusted Root Cert of CBody orderer4
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/ca
cp /var/artifacts/crypto-config/CBodyMSP/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/ca/cbody.com-ca-cert.pem

# Enroll orderer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com
fabric-ca-client enroll -d -u https://orderer0.cbody.com:DPCxKv8m@0.0.0.0:6053
# Enroll orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com
fabric-ca-client enroll -d -u https://orderer1.cbody.com:PCzEE5x2@0.0.0.0:6053
# Enroll orderer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com
fabric-ca-client enroll -d -u https://orderer2.cbody.com:T2ZNRe8x@0.0.0.0:6053
# Enroll orderer3
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com
fabric-ca-client enroll -d -u https://orderer3.cbody.com:7B5qMkhg@0.0.0.0:6053
# Enroll orderer4
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com
fabric-ca-client enroll -d -u https://orderer4.cbody.com:p8Maufjr@0.0.0.0:6053

# Enroll Org0's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/CBodyMSP/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-cbody.com:sR7w9xWY@0.0.0.0:6053

# Copy admin cert to the CBody orderer0
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/msp/admincerts
cp /var/artifacts/crypto-config/CBodyMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/CBodyMSP/orderer0.cbody.com/msp/admincerts/cbody.com-admin-cert.pem

# Copy admin cert to the CBody orderer1
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/msp/admincerts
cp /var/artifacts/crypto-config/CBodyMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/CBodyMSP/orderer1.cbody.com/msp/admincerts/cbody.com-admin-cert.pem

# Copy admin cert to the CBody orderer2
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/msp/admincerts
cp /var/artifacts/crypto-config/CBodyMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/CBodyMSP/orderer2.cbody.com/msp/admincerts/cbody.com-admin-cert.pem

# Copy admin cert to the CBody orderer3
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/msp/admincerts
cp /var/artifacts/crypto-config/CBodyMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/CBodyMSP/orderer3.cbody.com/msp/admincerts/cbody.com-admin-cert.pem

# Copy admin cert to the CBody orderer4
mkdir -p /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/msp/admincerts
cp /var/artifacts/crypto-config/CBodyMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/CBodyMSP/orderer4.cbody.com/msp/admincerts/cbody.com-admin-cert.pem

