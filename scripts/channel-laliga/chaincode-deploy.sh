export CHANNEL_NAME=channel-laliga
export CHAINCODE_NAME=laliga_chaincode
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=node
export ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer
export CC_SRC_PATH=/opt/gopath/src/github.com/chaincode
export ORDERER_CA=${ROOT}/crypto/ordererOrganizations/laliga.com/orderers/orderer.laliga.com/msp/tlscacerts/tlsca.laliga.com-cert.pem

# Empaquetamos el chaincode
peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION}

# Desplegamos en los peers
# LaLiga
peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz 

# RealMadrid
CORE_PEER_MSPCONFIGPATH=${ROOT}/crypto/peerOrganizations/realmadrid.org.laliga.com/users/Admin@realmadrid.org.laliga.com/msp CORE_PEER_ADDRESS=peer0.realmadrid.org.laliga.com:7051 CORE_PEER_LOCALMSPID="RealMadridOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=${ROOT}/crypto/peerOrganizations/realmadrid.org.laliga.com/peers/peer0.realmadrid.org.laliga.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

# Barcelona
CORE_PEER_MSPCONFIGPATH=${ROOT}/crypto/peerOrganizations/barcelona.org.laliga.com/users/Admin@barcelona.org.laliga.com/msp CORE_PEER_ADDRESS=peer0.barcelona.org.laliga.com:7051 CORE_PEER_LOCALMSPID="BarcelonaOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=${ROOT}/crypto/peerOrganizations/barcelona.org.laliga.com/peers/peer0.barcelona.org.laliga.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

# Atletico
CORE_PEER_MSPCONFIGPATH=${ROOT}/crypto/peerOrganizations/atletico.org.laliga.com/users/Admin@atletico.org.laliga.com/msp CORE_PEER_ADDRESS=peer0.atletico.org.laliga.com:7051 CORE_PEER_LOCALMSPID="AtleticoOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=${ROOT}/crypto/peerOrganizations/atletico.org.laliga.com/peers/peer0.atletico.org.laliga.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

echo "Introduce el id del codigo desplegado"
read code_id

# Commit en los peers
# LaLiga
peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('LaLigaOrgMSP.peer','RealMadridOrgMSP.peer','BarcelonaOrgMSP.peer')" --package-id $code_id
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('LaLigaOrgMSP.peer','RealMadridOrgMSP.peer','BarcelonaOrgMSP.peer')" --output json

# RealMadrid
CORE_PEER_MSPCONFIGPATH=${ROOT}/crypto/peerOrganizations/realmadrid.org.laliga.com/users/Admin@realmadrid.org.laliga.com/msp CORE_PEER_ADDRESS=peer0.realmadrid.org.laliga.com:7051 CORE_PEER_LOCALMSPID="RealMadridOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=${ROOT}/crypto/peerOrganizations/realmadrid.org.laliga.com/peers/peer0.realmadrid.org.laliga.com/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile ${ROOT}/crypto/ordererOrganizations/laliga.com/orderers/orderer.laliga.com/msp/tlscacerts/tlsca.laliga.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('LaLigaOrgMSP.peer','RealMadridOrgMSP.peer','BarcelonaOrgMSP.peer')" --package-id $code_id
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('LaLigaOrgMSP.peer','RealMadridOrgMSP.peer','BarcelonaOrgMSP.peer')" --output json

# Barcelona
CORE_PEER_MSPCONFIGPATH=${ROOT}/crypto/peerOrganizations/barcelona.org.laliga.com/users/Admin@barcelona.org.laliga.com/msp CORE_PEER_ADDRESS=peer0.barcelona.org.laliga.com:7051 CORE_PEER_LOCALMSPID="BarcelonaOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=${ROOT}/crypto/peerOrganizations/barcelona.org.laliga.com/peers/peer0.barcelona.org.laliga.com/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile ${ROOT}/crypto/ordererOrganizations/laliga.com/orderers/orderer.laliga.com/msp/tlscacerts/tlsca.laliga.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('LaLigaOrgMSP.peer','RealMadridOrgMSP.peer','BarcelonaOrgMSP.peer')" --package-id $code_id
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('LaLigaOrgMSP.peer','RealMadridOrgMSP.peer','BarcelonaOrgMSP.peer')" --output json

# commit
peer lifecycle chaincode commit -o orderer.laliga.com:7050 --tls --cafile $ORDERER_CA --peerAddresses peer0.laliga.org.laliga.com:7051 --tlsRootCertFiles ${ROOT}/crypto/peerOrganizations/laliga.org.laliga.com/peers/peer0.laliga.org.laliga.com/tls/ca.crt --peerAddresses peer0.realmadrid.org.laliga.com:7051 --tlsRootCertFiles ${ROOT}/crypto/peerOrganizations/realmadrid.org.laliga.com/peers/peer0.realmadrid.org.laliga.com/tls/ca.crt --peerAddresses peer0.barcelona.org.laliga.com:7051 --tlsRootCertFiles ${ROOT}/crypto/peerOrganizations/barcelona.org.laliga.com/peers/peer0.barcelona.org.laliga.com/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('LaLigaOrgMSP.peer','RealMadridOrgMSP.peer','BarcelonaOrgMSP.peer')"
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --output json
