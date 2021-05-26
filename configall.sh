# Generamos info de crypto
./cryptogen generate --config=./crypto-config.yaml
# Generamos bloque genesis de configuracion
./configtxgen -profile LaLigaOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

# Creamos transaccion de configuracion del canal de laliga y le unimos los peers
./configtxgen -profile LaLigaOrgsChannel -channelID channel-laliga -outputCreateChannelTx ./channel-artifacts/channel-laliga.tx
./configtxgen -profile LaLigaOrgsChannel -channelID channel-laliga -outputAnchorPeersUpdate ./channel-artifacts/LaLigaOrgMSPanchors-laliga.tx -asOrg LaLigaOrgMSP
./configtxgen -profile LaLigaOrgsChannel -channelID channel-laliga -outputAnchorPeersUpdate ./channel-artifacts/RealMadridOrgMSPanchors-laliga.tx -asOrg RealMadridOrgMSP
./configtxgen -profile LaLigaOrgsChannel -channelID channel-laliga -outputAnchorPeersUpdate ./channel-artifacts/BarcelonaOrgMSPanchors-laliga.tx -asOrg BarcelonaOrgMSP
./configtxgen -profile LaLigaOrgsChannel -channelID channel-laliga -outputAnchorPeersUpdate ./channel-artifacts/AtleticoOrgMSPanchors-laliga.tx -asOrg AtleticoOrgMSP

# Creamos transaccion de configuracion del canal de equipos y le unimos los peers
./configtxgen -profile EquiposOrgsChannel -channelID channel-equipos -outputCreateChannelTx ./channel-artifacts/channel-equipos.tx
./configtxgen -profile EquiposOrgsChannel -channelID channel-equipos -outputAnchorPeersUpdate ./channel-artifacts/LaLigaOrgMSPanchors-equipos.tx -asOrg LaLigaOrgMSP
./configtxgen -profile EquiposOrgsChannel -channelID channel-equipos -outputAnchorPeersUpdate ./channel-artifacts/RealMadridOrgMSPanchors-equipos.tx -asOrg RealMadridOrgMSP
./configtxgen -profile EquiposOrgsChannel -channelID channel-equipos -outputAnchorPeersUpdate ./channel-artifacts/BarcelonaOrgMSPanchors-equipos.tx -asOrg BarcelonaOrgMSP
./configtxgen -profile EquiposOrgsChannel -channelID channel-equipos -outputAnchorPeersUpdate ./channel-artifacts/AtleticoOrgMSPanchors-equipos.tx -asOrg AtleticoOrgMSP

export CHANNEL_LALIGA_NAME=channel-laliga
export CHANNEL_EQUIPOS_NAME=channel-equipos
export VERBOSE=false
export FABRIC_CFG_PATH=$PWD

# Actualizamos las couchdb con la info de los canales
CHANNEL_NAME=$CHANNEL_LALIGA_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d
CHANNEL_NAME=$CHANNEL_EQUIPOS_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d
