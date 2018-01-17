#!/bin/bash
# 
#   
# 
#
#

source ./modules/job.sh
source ./settings.sh

# Submit the job for the first time
echo "First time submitting the job ..."
job_submit $$
echo "Wait 30 sec to make sure the job has been submitted ..."
sleep 30

# Start checking job status for 
retry_times=0
while [ $retry_times -le 5 ]
do
    echo "Check job status ..."
    job_check $$

    if [[ $job_stat == 0 ]] ; then
        echo "Job does not in queue, re-sumbiting ..."
        job_submit $$
        echo "Wait 30 sec to make sure the job has been submitted ..."
        sleep 30
        retry_times=$(($retry_times+1))
    else
        echo "Job is in queue, waiting 30 sec for the next check..."
        sleep 30
        retry_times=0
    fi
done
echo "Retry more than 5 times, process stops!"
