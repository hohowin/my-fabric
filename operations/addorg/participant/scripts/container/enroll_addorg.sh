# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/RebelMSP/ca/crypto
cp /var/artifacts/crypto-config/RebelMSP/ca/server/ca-cert.pem /var/artifacts/crypto-config/RebelMSP/ca/crypto

# Register and Enroll
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/RebelMSP/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/RebelMSP/ca/admin
fabric-ca-client enroll -d -u https://rca-rebel-admin:rca-rebel-adminPW@0.0.0.0:6056
fabric-ca-client register -d --id.name peer1.rebel.inc --id.secret Tt4g3KLH --id.type peer -u https://0.0.0.0:6056
fabric-ca-client register -d --id.name peer2.pcch.net --id.secret C2npBNcf --id.type peer -u https://0.0.0.0:6056
fabric-ca-client register -d --id.name admin.rebel.inc --id.secret Heym2rQK --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:6056

# Copy Trusted Root Cert of Rebel to peer1
mkdir -p /var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/assets/ca
cp /var/artifacts/crypto-config/RebelMSP/ca/admin/msp/cacerts/0-0-0-0-6056.pem /var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/assets/ca/rebel.inc-ca-cert.pem

# Enroll peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/assets/ca/rebel.inc-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc
fabric-ca-client enroll -d -u https://peer1.rebel.inc:Tt4g3KLH@0.0.0.0:6056

# Copy Trusted Root Cert of Rebel to peer2
mkdir -p /var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/assets/ca
cp /var/artifacts/crypto-config/RebelMSP/ca/admin/msp/cacerts/0-0-0-0-6056.pem /var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/assets/ca/rebel.inc-ca-cert.pem

# Enroll peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/assets/ca/rebel.inc-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc
fabric-ca-client enroll -d -u https://peer2.pcch.net:C2npBNcf@0.0.0.0:6056

# Enroll Rebel's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/RebelMSP/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/assets/ca/rebel.inc-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin.rebel.inc:Heym2rQK@0.0.0.0:6056

# Copy admin cert to peer1
mkdir -p /var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/msp/admincerts
cp /var/artifacts/crypto-config/RebelMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/RebelMSP/peer1.rebel.inc/msp/admincerts/rebel.inc-admin-cert.pem
# Copy admin cert to peer2
mkdir -p /var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/msp/admincerts
cp /var/artifacts/crypto-config/RebelMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/RebelMSP/peer2.rebel.inc/msp/admincerts/rebel.inc-admin-cert.pem

# Rename admin key
mv /var/artifacts/crypto-config/RebelMSP/admin/msp/keystore/* /var/artifacts/crypto-config/RebelMSP/admin/msp/keystore/key.pem
