!#/bin/bash
# check whether samba installed or not

if [ $(dpkg-query -W -f='${Status}' samba 2>/dev/null | grep -c "ok installed") -eq 0 ];

then

  apt-get install samba;

fi

#configuration for share folder


echo " [global]
        disable netbios = yes
        workgroup = workgroup
        server string = db1
        dns proxy = no
        log file = /var/log/samba/log.%m
        max log size = 1000
        syslog = 0
        panic action = /usr/share/samba/panic-action %d
        obey pam restrictions = yes
        unix password sync = yes
        passwd program = /usr/bin/passwd %u
        passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
        pam password change = yes
        map to guest = bad user
        usershare allow guests = yes
        security = user
        username map = /etc/samba/smbusers
        load printers = no
        printing = bsd
        printcap name = /dev/null
        disable spoolss = yes
 
[temp]
        path = /srv/temp
        writeable = yes
        browseable = no
        valid users = temp
        create mask = 0700
        directory mask = 0700
[share]
	comment = File Server Share
        path = /srv/samba/share
        browseable = yes
	guest ok = yes
	read only = no
        create mask = 0755 " > smb.conf
#move, make, change file and forder permission 

mv smb.conf /etc/samba/smb.conf

mkdir -p /srv/samba/share

chown nobody.nogroup /srv/samba/share

echo " this is test text file
" > test.txt

mv test.txt /srv/samba/share/ 

#start samba server
service smbd start
service nmbd start

