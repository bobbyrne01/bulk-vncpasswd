#!/bin/bash

if [ ! $# == 2 ]; then
  echo "Usage: $0 <targetsFile> <newpassword>"
  echo "<targetsFile> should be CSV file containing: hostname,username,loginpassword"
  echo "eg"
  echo "server1.com,root,passw0rd"
  exit
fi

INPUT=$1
newPassword=$2
IFS=","


#Check .csv file exists
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

#Loop through each server
while read target user password
do
	echo ""
	echo "Copying /home/rob/git/bulk-vncpasswd/expect/vncpasswd.sh to $target@/root/vncpasswdExpect.sh .."
	result=$(sshpass -p "$password" scp -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /home/rob/git/bulk-vncpasswd/expect/vncpasswd.sh "$user"@"$target":/root/vncpasswdExpect.sh)
	echo "Copied /home/rob/git/bulk-vncpasswd/expect/vncpasswd.sh to $target@/root/vncpasswdExpect.sh"

	echo "Running /root/vncpasswdExpect.sh on $target as $user .."
        result=$(sshpass -p "$password" ssh -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -n "$user"@"$target" /root/vncpasswdExpect.sh "$newPassword" 2>/dev/null)
	resultCode=$?

        if [ $resultCode -eq 0 ]
        then
                echo "Set VNC password to $newPassword on $target"

	elif [ $resultCode -eq 126 ]
	then
		echo "Error on $target ..details below:"
		echo "Expect is not installed on $target"
                echo "End of error!"

	elif [ $resultCode -eq 255 ]
        then
                echo "Error on $target ..details below:"
                echo "Could not access $target"
                echo "End of error!"
        
        else
		echo "Error on $target ..details below:"
		echo "$resultCode"
		echo "$result"
		echo "End of error!"
        fi
done < $INPUT
