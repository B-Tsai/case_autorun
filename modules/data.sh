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
    
    # Get the latest time step on local host
    latest_time_step=`ssh $user_name@$remote_host "foamListTimes -case $case_dir_local -latestTime"`

    # Remove data on remote host
    for time_step in $list_time_step
    do
        if [[ $time_step != $latest_time_step ]] ; then
            `ssh $user_name@$remote_host "rm -rf $case_dir_remote/processor*/$time_step"`
        fi
    done
}

