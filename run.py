import sys
import csv
import subprocess

if len(sys.argv) != 3:
	print 'Usage:', sys.argv[0], '<targetsFile> <newpassword>'
	print "<targetsFile> should be CSV file containing: hostname,username,loginpassword"
	print "eg"
  	print "server1.com,root,passw0rd"
else:
	INPUT=sys.argv[1]
	newPassword=sys.argv[2]

	try:
	   with open(INPUT):
		with open(INPUT, 'rb') as csvfile:
		    spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
		    for row in spamreader:
			print ''
			print 'Copying /home/rob/git/bulk-vncpasswd/expect/vncpasswd.sh to', row[0], '@/', row[1], '/vncpasswdExpect.sh ..'

			command = ['/usr/bin/sshpass', '-p', row[2], 'scp', '-o', 'LogLevel=quiet', '-o', 'ConnectTimeout=1', '-o', 'UserKnownHostsFile=/dev/null', '-o', 'StrictHostKeyChecking=no', '/home/rob/git/bulk-vncpasswd/expect/vncpasswd.sh', row[1] + '@' + row[0] + ':/' + row[1] + '/vncpasswdExpect.sh']

			p = subprocess.Popen(command, stdout=subprocess.PIPE)
			out, err = p.communicate()
			print 'Done.'
			print ''

			print 'Running /', row[1], '/vncpasswdExpect.sh on', row[0], 'as', row[1], '..'
			command = ['/usr/bin/sshpass', '-p', row[2], 'ssh', '-o', 'LogLevel=quiet', '-o', 'ConnectTimeout=1', '-o', 'UserKnownHostsFile=/dev/null', '-o', 'StrictHostKeyChecking=no', '-n', row[1] + '@' + row[0], '/' + row[1] + '/vncpasswdExpect.sh', newPassword, '2>/dev/null']

			p = subprocess.Popen(command, stdout=subprocess.PIPE)
			out, err = p.communicate()
			print 'Done.'

	except IOError:
	   print INPUT, 'does not exist! Exiting ..'
