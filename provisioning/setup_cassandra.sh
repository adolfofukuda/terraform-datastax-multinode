#!/bin/sh 
HELP="Takes a single integer argument like 0 or 1 representing which node this is."

node=$1
if [ -z "${node}" ]; then
    echo "VAR is unset or set to the empty string"
    exit 1
fi
# Install OpenJDK 8
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt update -y
sudo apt install openjdk-8-jdk -y
java -version

# instalando o DataStax

# libaio 
sudo apt-get install libaio1 -y

echo "deb https://debian.datastax.com/enterprise/ stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list

curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -

sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive DS_LICENSE=accept \
 apt-get install dse=6.7.0-1 \
    dse-full=6.7.0-1 \
    dse-libcassandra=6.7.0-1 \
    dse-libgraph=6.7.0-1 \
    dse-libhadoop2-client-native=6.7.0-1 \
    dse-libhadoop2-client=6.7.0-1 \
    dse-liblog4j=6.7.0-1 \
    dse-libsolr=6.7.0-1 \
    dse-libspark=6.7.0-1 \
    dse-libtomcat=6.7.0-1 -y

#configurando em cluster
sudo sed -i "s/cluster_name: 'Test Cluster'/cluster_name: 'cassandra_cluster'/g" /etc/dse/cassandra/cassandra.yaml
#Seed nodes are used to bootstrap new nodes into the cluster.  Without a seed node new nodes can't join.  Too many is bad but there should be more than one.
sudo sed -i "s/seeds: \"127.0.0.1\"/seeds: \"10.2.5.170,10.2.5.171\"/g" /etc/dse/cassandra/cassandra.yaml
sudo sed -i "s/listen_address: localhost/listen_address:/g" /etc/dse/cassandra/cassandra.yaml
sudo sed -i "s/rpc_address: localhost/rpc_address: 0.0.0.0/g" /etc/dse/cassandra/cassandra.yaml
if [ $node == "0" ]; then
    sudo sed -i "s/# broadcast_rpc_address: 1.2.3.4/broadcast_rpc_address: 10.2.5.170/g" /etc/dse/cassandra/cassandra.yaml
elif [ $node = "1" ]; then
    sudo sed -i "s/# broadcast_rpc_address: 1.2.3.4/broadcast_rpc_address: 10.2.5.171/g" /etc/dse/cassandra/cassandra.yaml
elif [ $node = "2" ]; then
    sudo sed -i "s/# broadcast_rpc_address: 1.2.3.4/broadcast_rpc_address: 10.2.5.172/g" /etc/dse/cassandra/cassandra.yaml
else
    echo "$HELP"
    exit 1
fi

sudo service dse start


