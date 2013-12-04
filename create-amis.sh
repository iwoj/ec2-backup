#!/bin/bash

#EC2_KEYPAIR=clicklaw # name only, not the file name
#EC2_URL=https://ec2.us-east-1c.amazonaws.com
#EC2_PRIVATE_KEY=$HOME/.ec2/pk-clicklaw.pem
#EC2_CERT=$HOME/.ec2/cert-clicklaw.pem
#JAVA_HOME=/usr/lib/jvm/java-6-openjdk/

#/home/ubuntu/aws-missing-tools/ec2-automate-backup/ec2-automate-backup.sh -v "vol-54343714 vol-d91eb39a" -k 1 -n  >> /home/ubuntu/ec2-automate.log
#/home/ubuntu/aws-missing-tools/ec2-automate-backup/ec2-automate-backup.sh -v "vol-54343714 vol-d91eb39a" -p >> /home/ubuntu/ec2-automate.log

# aws ec2 describe-instances --filters Name=tag-value,Values=wiki.clicklaw.bc.ca Name=instance-state-name,Values=running |grep INSTANCES

TYPE=$1
NAMES=($2)
PATH=$PATH:/usr/local/bin/
#AWS_CONFIG_FILE=/home/ubuntu/backup.conf
#AWS_ACCESS_KEY_ID=AKIAIDPF2UPPETYXXOHQ
#AWS_SECRET_ACCESS_KEY=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
#REGION=us-east-1

for name in "${NAMES[@]}"
do
  instance=($(aws ec2 describe-instances --filters Name=tag-value,Values=$name Name=instance-state-name,Values=running |grep INSTANCES))
  instanceid=${instance[7]}
  label="$TYPE Backup - $name - $(date '+%F %H.%M')"
  amiid=($(aws ec2 create-image --instance-id $instanceid --name "$label" --description "$label"))
  aws ec2 create-tags --resources $amiid --tags Key=Backup-Date,Value="$(date)"
  aws ec2 create-tags --resources $amiid --tags Key=Backup-Type,Value=$TYPE
done

