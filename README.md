# Agens Graph, Cluster Recipe Using Docker and Swarm

## Step 1
Need to initialize docker swarm fun the following
 
```sh
docker swarm init --advertise-addr <ip address>`
```

Response should be like here:
```sh
`Swarm initialized: current node (r1c3aurggupce0r24ynzkfokw) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-53f89dj9gm3wd2vdo3ebnyizmrs1hcnwxf26sm2e9sx2yrp7qe-0o6tegdwnot5l4ll04vrb3j6n \
    192.168.0.2:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```
## Step 2
Now need to configure network, network will be called 'agensgraphnet'
 
 The optional --opt encrypted flag enables an additional layer of encryption in the overlay driver for vxlan traffic between containers on different nodes.
 ```sh
 docker network create --driver overlay --subnet 10.0.9.0/24 --opt encrypted agensgraphnet
 ```
 ## Step 3
For a highly available Agens Graph cluster configuration you would want the master database to run on a different host than where the replica databases will be run. Also, you might have a particular host you want the master container to be running on since it will be providing a write capability. Remember, in a cluster, replica databases are read-only, whereas the master is read-write. 

Find id of your node
```sh
docker node ls
```
Update node
```sh
docker node update --label-add type=master r1c
```

where **r1c** is node ID
 
## Step 4 
Run cluster
 
 ./run-cluster.sh
 
Response should be like that

```sh 
cleaning up ...
Error response from daemon: service master not found
Error response from daemon: service replica1 not found
Error response from daemon: service replica2 not found
Error response from daemon: service replica3 not found
starting agens-graph master container...
lw48mf361i7f3dc5rmb0wkzwh
sleep for a bit before starting the replica...
rj4d04dryyb7r4bew57uttgta
d67mq3pa0xoz2d5sy8uqfruix
0dwjcehxwzz9ub18oqfiny0hm
```

## Step 5
Let's check
```sh
docker service ps master
docker service ps replica
```
You can verify you have replicas by viewing the pg_stat_replication table

```sh
docker exec -it $(docker ps -q) psql -U postgres -c 'table pg_stat_replication' 
```

## Conclusion
Cluster based on 
[Agens Graph Docker image](https://github.com/maxim-s/agens-graph-docker)

[AgensGraph: Powerful Graph Database](https://github.com/bitnine-oss/agensgraph)



