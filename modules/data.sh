#!/bin/bash
#
#
#
#


# Download data (checksum)
function data_download()
{
    `rsync --append-verify $user_name@$remote_host:$case_dir_remote/* $case_dir_local/`
}


# Remove data from remote host
function data_remove()
{
    # Get the time step list on local host
    list_time_step=`foamListTimes -case $case_dir_local`
    read -a array_time_step <<<$list_time_step
    
    # Get the latest time step on local host
    latest_time_step=`foamListTimes -case $case_dir_local -latestTime`

    # Remove data on remote host (still keep 2 latest time steps)
    if [ ${#array_time_step[@]} > 2 ] ; then
        for time_step in ${array_time_step[@]}
        do
            if [ $time_step != ${array_time_step[-1]} ] && [ $time_step != ${array_time_step[-2]} ] ; then
                `ssh $user_name@$remote_host "rm -rf $case_dir_remote/processor*/$time_step"`
            fi
        done
    fi
}


# Remove last time step from remote host
function data_remove_last()
{
    # Get the time step list on remote host
    list_time_step_remote=`ssh $user_name@$remote_host "foamListTimes -case $case_dir_remote/processor0"`
    read -a array_time_step_remote <<<$list_time_step_remote

    # Get the latest time step on remote host
    latest_time_step_remote=`ssh $user_name@$remote_host "foamListTimes -case $case_dir_remote/processor0 -latestTime"`

    # Remove data on both local and remote host
    if [ ${#array_time_step_remote[@]} > 2 ] ; then
        `rm -rf $case_dir_local/$latest_time_step_remote`
        `rm -rf $case_dir_local/processor*/$latest_time_step_remote`
        `ssh $user_name@$remote_host "rm -rf $case_dir_remote/processor*/$latest_time_step_remote"`
    fi
}


# Reconstruct OpenFOAM data
function data_reconstructOpenFOAM()
{
    `reconstructPar -newTimes`
}

