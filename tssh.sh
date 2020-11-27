#!/bin/bash

CONFIG_FILE="${HOME}/.tssh.conf"
SSH_EXEC=$(which ssh)
TMUX_EXEC=$(which tmux)

# shellcheck source=/dev/null
source "${CONFIG_FILE}"

msg()
{
    echo "Here the list of clusters."
    echo "Use \"tssh list [cluster_name]\" to list all hosts in the cluster"
} # msg

list_clusters()
{
    n=0
    for cluster in "${all_clusters[@]}"
    do
    	echo "${n})" : "${cluster}"
    	((n++))
    done |column
} # list_clusters

run()
{
    msg
    list_clusters
    read -p "Select a cluster to connect to: " nb
    if [ -z "${nb}" ] || ! [[ ${nb} =~ ^[0-9]+$ ]]
    then
        echo "Only integers are allowed."
        exit 0
    else
        cluster="${all_clusters[$nb]}"
    fi
} #run

is_up()
{
    if tmux info &> /dev/null; then 
        return 0
    else
        return 1
    fi
}

list()
{
    if [ -z "${1}" ]
    then
        msg
        list_clusters
        exit 0
	else
		hosts=$(eval "echo \${$1}")
		
		# Test if cluster name is not empty
		if [ -z "${hosts}" ]
		then
			echo "Bad cluster name. Chose a cluster name in the list. Run \"tssh list\"" 
			exit 1
		fi

		for host in ${hosts}
		do
			echo "${host}"
		done
	fi
    exit 0
} # list

# Check arguments
if [ -z "${1}" ]
then
	run
else
  	if [ "${1}" == "list" ] && [ -z "${2}" ]
    then
        list
    elif [ "${1}" == "list" ] && [ -n "${2}" ]
  	then
		list "${2}"
	fi
fi

connect_to_hosts()
{
     ${TMUX_EXEC} new-window
	for host in ${!cluster}
	do
		${TMUX_EXEC} splitw "${SSH_EXEC} $host"
		${TMUX_EXEC} select-layout tiled
	done
} # connect_to_hosts

kill_and_synchronize_panes()
{
    ${TMUX_EXEC} rename-window "${cluster}"
    ${TMUX_EXEC} set-window-option synchronize-panes
    ${TMUX_EXEC} kill-pane -t 0
} # kill_and_synchronize_panes

main()
{
    if ! is_up
    then
        ${TMUX_EXEC} new -s tssh_$$
    fi

    connect_to_hosts
    kill_and_synchronize_panes
} # main

# launch !
main

# EOF
