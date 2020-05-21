[[ -f /usr/bin/expect ]] || { yum install expect -y; }
/usr/bin/expect << EOF
set timeout 30
spawn mysql_secure_installation
expect {
	"enter for none" { send "\r"; exp_continue}
	"Y/n" { send "Y\r" ; exp_continue}
	"password:" { send "{{ dbpass }}\r"; exp_continue}
	"new password:" { send "{{ dbpass }}\r"; exp_continue}
	"Y/n" { send "Y\r" ; exp_continue}
	eof { exit }
}
EOF
