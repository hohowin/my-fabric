# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/PccHMSP/ca/crypto
cp /var/artifacts/crypto-config/PccHMSP/ca/server/ca-cert.pem /var/artifacts/crypto-config/PccHMSP/ca/crypto

# Register and Enroll
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/PccHMSP/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/PccHMSP/ca/admin
fabric-ca-client enroll -d -u https://rca-pcch-admin:rca-pcch-adminPW@0.0.0.0:6054
fabric-ca-client register -d --id.name peer0.pcch.net --id.secret Tt4g3KLH --id.type peer -u https://0.0.0.0:6054
fabric-ca-client register -d --id.name peer1.pcch.net --id.secret C2npBNcf --id.type peer -u https://0.0.0.0:6054
fabric-ca-client register -d --id.name admin-pcch.net --id.secret Heym2rQK --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:6054

# Copy Trusted Root Cert of PccH to peer0
mkdir -p /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/ca
cp /var/artifacts/crypto-config/PccHMSP/ca/admin/msp/cacerts/0-0-0-0-6054.pem /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/ca/pcch.net-ca-cert.pem

# Enroll peer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/ca/pcch.net-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/PccHMSP/peer0.pcch.net
fabric-ca-client enroll -d -u https://peer0.pcch.net:Tt4g3KLH@0.0.0.0:6054

# Copy Trusted Root Cert of PccH to peer1
mkdir -p /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/assets/ca
cp /var/artifacts/crypto-config/PccHMSP/ca/admin/msp/cacerts/0-0-0-0-6054.pem /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/assets/ca/pcch.net-ca-cert.pem

# Enroll peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/assets/ca/pcch.net-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/PccHMSP/peer1.pcch.net
fabric-ca-client enroll -d -u https://peer1.pcch.net:C2npBNcf@0.0.0.0:6054

# Enroll PccH's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/PccHMSP/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/ca/pcch.net-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-pcch.net:Heym2rQK@0.0.0.0:6054

# Copy admin cert to peer0
mkdir -p /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/msp/admincerts
cp /var/artifacts/crypto-config/PccHMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/msp/admincerts/pcch.net-admin-cert.pem
# Copy admin cert to peer1
mkdir -p /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/msp/admincerts
cp /var/artifacts/crypto-config/PccHMSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/PccHMSP/peer1.pcch.net/msp/admincerts/pcch.net-admin-cert.pem

# Rename admin key
mv /var/artifacts/crypto-config/PccHMSP/admin/msp/keystore/* /var/artifacts/crypto-config/PccHMSP/admin/msp/keystore/key.pem
