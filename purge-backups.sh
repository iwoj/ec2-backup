#!/bin/bash

#EC2_KEYPAIR=clicklaw # name only, not the file name
#EC2_URL=https://ec2.us-east-1c.amazonaws.com
#EC2_PRIVATE_KEY=$HOME/.ec2/pk-clicklaw.pem
#EC2_CERT=$HOME/.ec2/cert-clicklaw.pem
#JAVA_HOME=/usr/lib/jvm/java-6-openjdk/

#/home/ubuntu/aws-missing-tools/ec2-automate-backup/ec2-automate-backup.sh -v "vol-54343714 vol-d91eb39a" -k 1 -n  >> /home/ubuntu/ec2-automate.log
#/home/ubuntu/aws-missing-tools/ec2-automate-backup/ec2-automate-backup.sh -v "vol-54343714 vol-d91eb39a" -p >> /home/ubuntu/ec2-automate.log

BACKUP_TYPE=$1
PURGE_AGE=$2
PATH=$PATH:/usr/local/bin/
OLD_IFS=$IFS
IFS='
'
#AWS_CONFIG_FILE=/home/ubuntu/backup.conf
#AWS_ACCESS_KEY_ID=AKIAIDPF2UPPETYXXOHQ
#AWS_SECRET_ACCESS_KEY=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
#REGION=us-east-1
NOW=`date +%s`
ONE_HOUR=$((60*60))
ONE_DAY=$((60*60*24))
ONE_WEEK=$((60*60*24*7))
ONE_MONTH=$((60*60*24*31))
ONE_YEAR=$(($ONE_MONTH*12))

lines=($(aws ec2 describe-snapshots --filters "Name=tag-key,Values=Backup-Type,Name=tag-value,Values=$BACKUP_TYPE" | grep SNAPSHOTS))

for line in "${lines[@]}"
do
  IFS=$OLD_IFS
  arr=($line)
  SNAP_TIME=${arr[6]}
  SNAP_ID=${arr[5]}
  TIME_DIFF=$(($NOW - $(date -d $SNAP_TIME +%s)))
  case "$PURGE_AGE" in
    one_hour)
      if [ "$TIME_DIFF" -gt "$ONE_HOUR" ]; then
        aws ec2 delete-snapshot --snapshot-id $SNAP_ID
      fi
      ;;
    one_day)
      if [ "$TIME_DIFF" -gt "$ONE_DAY" ]; then
        aws ec2 delete-snapshot --snapshot-id $SNAP_ID
      fi
      ;;
    one_week)
      if [ "$TIME_DIFF" -gt "$ONE_WEEK" ]; then
        aws ec2 delete-snapshot --snapshot-id $SNAP_ID
      fi
      ;;
    one_month)
      if [ "$TIME_DIFF" -gt "$ONE_MONTH" ]; then
        aws ec2 delete-snapshot --snapshot-id $SNAP_ID
      fi
      ;;
    one_year)
      if [ "$TIME_DIFF" -gt "$ONE_YEAR" ]; then
        aws ec2 delete-snapshot --snapshot-id $SNAP_ID
      fi
      ;;
  esac
done



