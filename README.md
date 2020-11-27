### Description
tssh (TmuxSSH) provide a way to connect to multiple ssh hosts easily, based on a list of clusters defined in the configuration

### Prerequisites
* tmux installed

#### On mac:
```sh
$ brew install tmux
```

#### On Debian/Ubuntu:
```sh
$ apt update && apt install tmux
```

### Installation
```sh
$ git clone https://github.com/Chr0my/tssh.git ${WORKDIR}/
$ cd /usr/local/bin
$ ln -s ${WORKDIR}/tssh/tssh.sh tssh
$ cp ${WORKDIR}/tssh/tssh.conf.dist ${HOME}/.tssh.conf
```
Then reload your shell.

The configuration file `.tssh.conf` contains all clusters and is easily modifiable

### Usage
This will open a new splitted tmux window

#### Running
```sh
$ tssh
Here the list of clusters.
Use "tssh list [cluster_name]" to list all hosts in the cluster
0) : testing_cluster1   1) : testing_cluster2   2) : testing_all        3) : prod_cluster1
Select a cluster to connect to: 
```

#### Listing
```sh
$ tssh list testing_cluster1
host1
host2

$ tssh list testing_all
host1
host2
host3
host4
```
#### Adding a cluster
If you want to add a cluster:

In `${HOME}/.tssh.conf`:

```sh
new_cluster="host1
    host2
    host3"
````

```sh
all_clusters=(
testing_cluster1,
testing_cluster2,
[...]
new_cluster)
```
