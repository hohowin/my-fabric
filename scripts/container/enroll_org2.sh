# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/HKGovMSP/ca/crypto
cp /var/artifacts/crypto-config/HKGovMSP/ca/server/ca-cert.pem /var/artifacts/crypto-config/HKGovMSP/ca/crypto

# Register and Enroll
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/HKGovMSP/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/HKGovMSP/ca/admin
fabric-ca-client enroll -d -u https://rca-hkgov-admin:rca-hkgov-adminPW@0.0.0.0:6055
fabric-ca-client register -d --id.name peer0.gov.hk --id.secret peer0PW --id.type peer -u https://0.0.0.0:6055
fabric-ca-client register -d --id.name peer1.gov.hk --id.secret peer1PW --id.type peer -u https://0.0.0.0:6055
fabric-ca-client register -d --id.name admin-gov.hk --id.secret HKGovAdminPW --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:6055

# Copy Trusted Root Cert of HKGov to peer0
mkdir -p /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets/ca
cp /var/artifacts/crypto-config/HKGovMSP/ca/admin/msp/cacerts/0-0-0-0-6055.pem /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets/ca/gov.hk-ca-cert.pem

# Enroll peer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets/ca/gov.hk-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk
fabric-ca-client enroll -d -u https://peer0.gov.hk:peer0PW@0.0.0.0:6055

# Copy Trusted Root Cert of HKGov to peer1
mkdir -p /var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/assets/ca
cp /var/artifacts/crypto-config/HKGovMSP/ca/admin/msp/cacerts/0-0-0-0-6055.pem /var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/assets/ca/gov.hk-ca-cert.pem

# Enroll peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/assets/ca/gov.hk-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk
fabric-ca-client enroll -d -u https://peer1.gov.hk:peer1PW@0.0.0.0:6055

# Enroll HKGov's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/HKGovMSP/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/HKGovMSP&#x2F;peer0.gov.hk/assets/ca/gov.hk-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-gov.hk:HKGovAdminPW@0.0.0.0:6055

# Copy admin cert to peer0
mkdir -p /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/msp/admincerts
cp /var/artifacts/crypto-config/HKGovMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/msp/admincerts/gov.hk-admin-cert.pem
# Copy admin cert to peer1
mkdir -p /var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/msp/admincerts
cp /var/artifacts/crypto-config/HKGovMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/HKGovMSP/peer1.gov.hk/msp/admincerts/gov.hk-admin-cert.pem

# Rename admin key
mv /var/artifacts/crypto-config/HKGovMSP/admin/msp/keystore/* /var/artifacts/crypto-config/HKGovMSP/admin/msp/keystore/key.pem
