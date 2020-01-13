# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/cbody.com/ca/crypto
cp /var/artifacts/crypto-config/rca.cbody.com/server/ca-cert.pem /var/artifacts/crypto-config/cbody.com/ca/crypto

# Enroll Orderer Org's CA Admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/ca/admin

fabric-ca-client enroll -d -u https://rca-hktfp-admin:rca-hktfp-adminPW@0.0.0.0:6053
fabric-ca-client register -d --id.name orderer0.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name orderer1.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name orderer2.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name orderer3.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name orderer4.cbody.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:6053
fabric-ca-client register -d --id.name admin-cbody.com --id.secret CBodyAdminPW --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:6053

# Copy Trusted Root Cert of CBody orderer0
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer0/assets/ca
cp /var/artifacts/crypto-config/cbody.com/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/cbody.com/orderer0/assets/ca/cbody.com-ca-cert.pem
# Copy Trusted Root Cert of CBody orderer1
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer1/assets/ca
cp /var/artifacts/crypto-config/cbody.com/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/cbody.com/orderer1/assets/ca/cbody.com-ca-cert.pem
# Copy Trusted Root Cert of CBody orderer2
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer2/assets/ca
cp /var/artifacts/crypto-config/cbody.com/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/cbody.com/orderer2/assets/ca/cbody.com-ca-cert.pem
# Copy Trusted Root Cert of CBody orderer3
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer3/assets/ca
cp /var/artifacts/crypto-config/cbody.com/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/cbody.com/orderer3/assets/ca/cbody.com-ca-cert.pem
# Copy Trusted Root Cert of CBody orderer4
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer4/assets/ca
cp /var/artifacts/crypto-config/cbody.com/ca/admin/msp/cacerts/0-0-0-0-6053.pem /var/artifacts/crypto-config/cbody.com/orderer4/assets/ca/cbody.com-ca-cert.pem

# Enroll orderer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer0/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer0
fabric-ca-client enroll -d -u https://orderer0.cbody.com:ordererPW@0.0.0.0:6053
# Enroll orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer1/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer1
fabric-ca-client enroll -d -u https://orderer1.cbody.com:ordererPW@0.0.0.0:6053
# Enroll orderer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer2/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer2
fabric-ca-client enroll -d -u https://orderer2.cbody.com:ordererPW@0.0.0.0:6053
# Enroll orderer3
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer3/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer3
fabric-ca-client enroll -d -u https://orderer3.cbody.com:ordererPW@0.0.0.0:6053
# Enroll orderer4
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer4/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/orderer4
fabric-ca-client enroll -d -u https://orderer4.cbody.com:ordererPW@0.0.0.0:6053

# Enroll Org0's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/cbody.com/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/cbody.com/orderer0/assets/ca/cbody.com-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-cbody.com:CBodyAdminPW@0.0.0.0:6053

# Copy admin cert to the CBody orderer0
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer0/msp/admincerts
cp /var/artifacts/crypto-config/cbody.com/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/cbody.com/orderer0/msp/admincerts/cbody.com-admin-cert.pem

# Copy admin cert to the CBody orderer1
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer1/msp/admincerts
cp /var/artifacts/crypto-config/cbody.com/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/cbody.com/orderer1/msp/admincerts/cbody.com-admin-cert.pem

# Copy admin cert to the CBody orderer2
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer2/msp/admincerts
cp /var/artifacts/crypto-config/cbody.com/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/cbody.com/orderer2/msp/admincerts/cbody.com-admin-cert.pem

# Copy admin cert to the CBody orderer3
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer3/msp/admincerts
cp /var/artifacts/crypto-config/cbody.com/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/cbody.com/orderer3/msp/admincerts/cbody.com-admin-cert.pem

# Copy admin cert to the CBody orderer4
mkdir -p /var/artifacts/crypto-config/cbody.com/orderer4/msp/admincerts
cp /var/artifacts/crypto-config/cbody.com/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/cbody.com/orderer4/msp/admincerts/cbody.com-admin-cert.pem

