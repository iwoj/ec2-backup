#!/bin/bash

#EC2_KEYPAIR=clicklaw # name only, not the file name
#EC2_URL=https://ec2.us-east-1c.amazonaws.com
#EC2_PRIVATE_KEY=$HOME/.ec2/pk-clicklaw.pem
#EC2_CERT=$HOME/.ec2/cert-clicklaw.pem
#JAVA_HOME=/usr/lib/jvm/java-6-openjdk/

#/home/ubuntu/aws-missing-tools/ec2-automate-backup/ec2-automate-backup.sh -v "vol-54343714 vol-d91eb39a" -k 1 -n  >> /home/ubuntu/ec2-automate.log
#/home/ubuntu/aws-missing-tools/ec2-automate-backup/ec2-automate-backup.sh -v "vol-54343714 vol-d91eb39a" -p >> /home/ubuntu/ec2-automate.log

TYPE=$1
PATH=$PATH:/usr/local/bin/
#AWS_CONFIG_FILE=/home/ubuntu/backup.conf
#AWS_ACCESS_KEY_ID=AKIAIDPF2UPPETYXXOHQ
#AWS_SECRET_ACCESS_KEY=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
#REGION=us-east-1

volumes[0]="vol-54343714"
volumes[1]="vol-d91eb39a"

for volume in "${volumes[@]}"
do
  echo $volume
  arr=($(aws ec2 create-snapshot --volume-id $volume --description "$TYPE Backup - $volume"))
  snapid=${arr[4]}
  aws ec2 create-tags --resources $snapid --tags Key=Backup-Type,Value=$TYPE
done

