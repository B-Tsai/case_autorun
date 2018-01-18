#!/bin/bash
#
#
#
#

function data_download()
{
    # Download data (checksum)
    `rsync --append-verify $user_name@$remote_host:$case_dir_remote/* $case_dir_local/`
}


function data_remove()
{
    # Get the time step list on local host
    list_time_step=`ssh $user_name@$remote_host "foamListTimes -case $case_dir_local"`
    read -a array_time_step <<<$list_time_step
    
    # Get the latest time step on local host
    latest_time_step=`ssh $user_name@$remote_host "foamListTimes -case $case_dir_local -latestTime"`

    # Remove data on remote host (still keep 2 latest time steps)
    for time_step in ${array_time_step[@]}
    do
        if [ $time_step != ${array_time_step[-1]} ] && [ $time_step != ${array_time_step[-2]} ] ; then
            `ssh $user_name@$remote_host "rm -rf $case_dir_remote/processor*/$time_step"`
        fi
    done
}

