# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/pcch.net/ca/crypto
cp /var/artifacts/crypto-config/rca.pcch.net/server/ca-cert.pem /var/artifacts/crypto-config/pcch.net/ca/crypto

# Register and Enroll
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/pcch.net/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/pcch.net/ca/admin
fabric-ca-client enroll -d -u https://rca-pcch-admin:rca-pcch-adminPW@0.0.0.0:6054

fabric-ca-client register -d --id.name peer0.pcch.net --id.secret peer0PW --id.type peer -u https://0.0.0.0:6054
fabric-ca-client register -d --id.name peer1.pcch.net --id.secret peer1PW --id.type peer -u https://0.0.0.0:6054
fabric-ca-client register -d --id.name admin-pcch.net --id.secret PccHAdminPW --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:6054

# Copy Trusted Root Cert of PccH to peer0
mkdir -p /var/artifacts/crypto-config/pcch.net/peer0/assets/ca
cp /var/artifacts/crypto-config/pcch.net/ca/admin/msp/cacerts/0-0-0-0-6054.pem /var/artifacts/crypto-config/pcch.net/peer0/assets/ca/pcch.net-ca-cert.pem

# Enroll peer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/pcch.net/peer0/assets/ca/pcch.net-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/pcch.net/peer0
fabric-ca-client enroll -d -u https://peer0.pcch.net:peer0PW@0.0.0.0:6054

# Copy Trusted Root Cert of PccH to peer1
mkdir -p /var/artifacts/crypto-config/pcch.net/peer1/assets/ca
cp /var/artifacts/crypto-config/pcch.net/ca/admin/msp/cacerts/0-0-0-0-6054.pem /var/artifacts/crypto-config/pcch.net/peer1/assets/ca/pcch.net-ca-cert.pem

# Enroll peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/pcch.net/peer1/assets/ca/pcch.net-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/pcch.net/peer1
fabric-ca-client enroll -d -u https://peer1.pcch.net:peer1PW@0.0.0.0:6054

# Enroll PccH's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/pcch.net/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/pcch.net/peer0/assets/ca/pcch.net-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-pcch.net:PccHAdminPW@0.0.0.0:6054

# Copy admin cert to peer0
mkdir -p /var/artifacts/crypto-config/pcch.net/peer0/msp/admincerts
cp /var/artifacts/crypto-config/pcch.net/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/pcch.net/peer0/msp/admincerts/pcch.net-admin-cert.pem
# Copy admin cert to peer1
mkdir -p /var/artifacts/crypto-config/pcch.net/peer1/msp/admincerts
cp /var/artifacts/crypto-config/pcch.net/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/pcch.net/peer1/msp/admincerts/pcch.net-admin-cert.pem

# Rename admin key
mv /var/artifacts/crypto-config/pcch.net/admin/msp/keystore/* /var/artifacts/crypto-config/pcch.net/admin/msp/keystore/key.pem
