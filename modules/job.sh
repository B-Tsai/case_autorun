#!/bin/bash
#
#
#
#

function job_submit()
{
    # Submit the job and get its job-ID
    job_sub_msg=`ssh $user_name@$remote_host "workgroup -g $group_name -C 'qsub $case_dir_remote/$qs_file'"` 
    job_ID=${job_sub_msg//[^0-9]/}
}


function job_check()
{
    # Get job stat
    job_stat_msg=`ssh $user_name@$remote_host "qstat -u $user_name -j $job_ID"` 
    if [[ $job_stat_msg == "" ]] ; then
        job_stat=0
    else
        job_stat=1
    fi
}
