#!/bin/bash
# 
#   
# 
#
#

source ./modules/job.sh
source ./settings.sh
`of240`

# Submit the job for the first time
echo "First time submitting the job ..."
job_submit $$
sleep 5

retry_times=0
latest_time_step_remote=0
while [ $retry_times -le 5 ]
do
    # Start checking job status
    echo "Check job status ..."
    job_check $$

    # If job does no exit, then do more checks
    if [[ $job_stat == 0 ]] ; then
        # Check if all the simulation has been done
        if [[ $end_time_step != $latest_time_step_remote ]] ; then
            # If retry times more than 4 times, remove the last time step data (might be broken)
            if [[ $retry_times == 4 ]] ; then
                data_remove_last $$
            fi

            echo "Job does not in queue, re-sumbiting ..."
            job_submit $$
            retry_times=$(($retry_times+1))
            sleep 5
       else
            # if reach the end time step, end the loop
            break
        fi

    else
        echo "Job is in queue, wait 60 sec ..."
        sleep 60
        retry_times=0

        # Download data from remote host to local host
        echo "Downloading data from remote host ..."
        data_download $$

        # Remove data on remote host
        echo "Removing data from remote host ..."
        data_remove $$
    
        # Reconstruct OpenFOAM data
        data_reconstructOpenFOAM $$
        fi
done

if [[ $retry_times > 5 ]] ; then
    echo "Retry more than 5 times, process stops!"
else
    echo "Job has finished!"
fi



