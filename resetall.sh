docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
rm -r channel-artifacts/
rm -r crypto-config/
docker volume create portainer_data
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
./configall.sh