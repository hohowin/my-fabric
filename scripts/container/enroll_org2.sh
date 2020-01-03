# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/gov.hk/ca/crypto
cp /var/artifacts/crypto-config/rca.gov.hk/server/ca-cert.pem /var/artifacts/crypto-config/gov.hk/ca/crypto

# Register and Enroll
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/gov.hk/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/gov.hk/ca/admin
fabric-ca-client enroll -d -u https://rca-hkgov-admin:rca-hkgov-adminPW@0.0.0.0:6055
fabric-ca-client register -d --id.name peer0.gov.hk --id.secret peer0PW --id.type peer -u https://0.0.0.0:6055
fabric-ca-client register -d --id.name peer1.gov.hk --id.secret peer1PW --id.type peer -u https://0.0.0.0:6055
fabric-ca-client register -d --id.name admin-gov.hk --id.secret HKGovAdminPW --id.type user -u https://0.0.0.0:6055
fabric-ca-client register -d --id.name user-gov.hk --id.secret HKGovUserPW --id.type user -u https://0.0.0.0:6055

# Copy Trusted Root Cert of HKGov to peer0
mkdir -p /var/artifacts/crypto-config/gov.hk/peer0/assets/ca
cp /var/artifacts/crypto-config/gov.hk/ca/admin/msp/cacerts/0-0-0-0-6055.pem /var/artifacts/crypto-config/gov.hk/peer0/assets/ca/gov.hk-ca-cert.pem

# Enroll peer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/gov.hk/peer0/assets/ca/gov.hk-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/gov.hk/peer0
fabric-ca-client enroll -d -u https://peer0.gov.hk:peer0PW@0.0.0.0:6055

# Copy Trusted Root Cert of HKGov to peer1
mkdir -p /var/artifacts/crypto-config/gov.hk/peer1/assets/ca
cp /var/artifacts/crypto-config/gov.hk/ca/admin/msp/cacerts/0-0-0-0-6055.pem /var/artifacts/crypto-config/gov.hk/peer1/assets/ca/gov.hk-ca-cert.pem

# Enroll peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/gov.hk/peer1/assets/ca/gov.hk-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/gov.hk/peer1
fabric-ca-client enroll -d -u https://peer1.gov.hk:peer1PW@0.0.0.0:6055

# Enroll HKGov's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/gov.hk/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/gov.hk/peer0/assets/ca/gov.hk-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-gov.hk:HKGovAdminPW@0.0.0.0:6055

# Copy admin cert to peer0
mkdir -p /var/artifacts/crypto-config/gov.hk/peer0/msp/admincerts
cp /var/artifacts/crypto-config/gov.hk/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/gov.hk/peer0/msp/admincerts/gov.hk-admin-cert.pem
# Copy admin cert to peer1
mkdir -p /var/artifacts/crypto-config/gov.hk/peer1/msp/admincerts
cp /var/artifacts/crypto-config/gov.hk/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/gov.hk/peer1/msp/admincerts/gov.hk-admin-cert.pem

# Rename admin key
mv /var/artifacts/crypto-config/gov.hk/admin/msp/keystore/* /var/artifacts/crypto-config/gov.hk/admin/msp/keystore/key.pem
