# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/ca/crypto
cp /var/artifacts/crypto-config/WakandaGovMSP/ca/server/ca-cert.pem /var/artifacts/crypto-config/WakandaGovMSP/ca/crypto

# Register and Enroll
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/WakandaGovMSP/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/WakandaGovMSP/ca/admin
fabric-ca-client enroll -d -u https://rca-wakanda-admin:rca-wakanda-adminPW@0.0.0.0:6055
fabric-ca-client register -d --id.name peer0.gov.wakanda --id.secret 4PBPEkwt --id.type peer -u https://0.0.0.0:6055
fabric-ca-client register -d --id.name peer1.gov.wakanda --id.secret Q528SdnZ --id.type peer -u https://0.0.0.0:6055
fabric-ca-client register -d --id.name admin-gov.wakanda --id.secret mEN6bpQW --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:6055

# Copy Trusted Root Cert of WakandaGov to peer0
mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/ca
cp /var/artifacts/crypto-config/WakandaGovMSP/ca/admin/msp/cacerts/0-0-0-0-6055.pem /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/ca/gov.wakanda-ca-cert.pem

# Enroll peer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/ca/gov.wakanda-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda
fabric-ca-client enroll -d -u https://peer0.gov.wakanda:4PBPEkwt@0.0.0.0:6055

# Copy Trusted Root Cert of WakandaGov to peer1
mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/assets/ca
cp /var/artifacts/crypto-config/WakandaGovMSP/ca/admin/msp/cacerts/0-0-0-0-6055.pem /var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/assets/ca/gov.wakanda-ca-cert.pem

# Enroll peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/assets/ca/gov.wakanda-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda
fabric-ca-client enroll -d -u https://peer1.gov.wakanda:Q528SdnZ@0.0.0.0:6055

# Enroll WakandaGov's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/WakandaGovMSP/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/ca/gov.wakanda-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-gov.wakanda:mEN6bpQW@0.0.0.0:6055

# Copy admin cert to peer0
mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/msp/admincerts
cp /var/artifacts/crypto-config/WakandaGovMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/msp/admincerts/gov.wakanda-admin-cert.pem
# Copy admin cert to peer1
mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/msp/admincerts
cp /var/artifacts/crypto-config/WakandaGovMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/WakandaGovMSP/peer1.gov.wakanda/msp/admincerts/gov.wakanda-admin-cert.pem

# Rename admin key
mv /var/artifacts/crypto-config/WakandaGovMSP/admin/msp/keystore/* /var/artifacts/crypto-config/WakandaGovMSP/admin/msp/keystore/key.pem
