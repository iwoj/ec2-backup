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
TEN_DAYS=$((60*60*24*10))
ONE_WEEK=$((60*60*24*7))
ONE_MONTH=$((60*60*24*31))
SIX_MONTHS=$(($ONE_DAY*30*6+3))
ONE_YEAR=$(($ONE_DAY*356))

lines=($(aws ec2 describe-images --filters "Name=tag-key,Values=Backup-Type,Name=tag-value,Values=$BACKUP_TYPE" | grep IMAGES))

for line in "${lines[@]}"
do
  IFS=$OLD_IFS
  arr=($line)
  AMIID=${arr[10]}
  taginfo=($(aws ec2 describe-tags --filters "Name=resource-id,Values=$AMIID" "Name=key,Values=Backup-Date"))
  TIME="${taginfo[4]} ${taginfo[5]} ${taginfo[6]} ${taginfo[7]} ${taginfo[8]} ${taginfo[9]}"
  TIME_DIFF=$(($NOW - $(date -d "$TIME" +%s)))
  case "$PURGE_AGE" in
    one_hour)
      if [ "$TIME_DIFF" -gt "$ONE_HOUR" ]; then
        aws ec2 deregister-image --image-id $AMIID
      fi
      ;;
    one_day)
      if [ "$TIME_DIFF" -gt "$ONE_DAY" ]; then
        aws ec2 deregister-image --image-id $AMIID
      fi
      ;;
    ten_days)
      if [ "$TIME_DIFF" -gt "$TEN_DAYS" ]; then
        aws ec2 deregister-image --image-id $AMIID
      fi
      ;;
    one_week)
      if [ "$TIME_DIFF" -gt "$ONE_WEEK" ]; then
        aws ec2 deregister-image --image-id $AMIID
      fi
      ;;
    one_month)
      if [ "$TIME_DIFF" -gt "$ONE_MONTH" ]; then
        aws ec2 deregister-image --image-id $AMIID
      fi
      ;;
    one_year)
      if [ "$TIME_DIFF" -gt "$ONE_YEAR" ]; then
        aws ec2 deregister-image --image-id $AMIID
      fi
      ;;
  esac
done



