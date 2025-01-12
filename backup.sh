#!/bin/bash

echo "Backup starting..."

is_botw_copied=false
is_totk_copied=false
is_git_succesful=false

backuptime=$(date +"%Y-%m-%d %H:%M:%S")

git_commands="
git add . 
git commit -m \"$backuptime\"
git push
"

echo "Copying Breath of the Wild  save files"
	cp -r /home/mert/.var/app/org.ryujinx.Ryujinx/config/Ryujinx/bis/user/save/0000000000000002 Breath-of-the-Wild
	if [[ $? -eq 0 ]]; then
		is_botw_copied=true
	else
	    echo "Failed to copy BOTW"
	fi

echo "Copying Tears of the Kingdom save files"
	cp -r /home/mert/.var/app/org.ryujinx.Ryujinx/config/Ryujinx/bis/user/save/0000000000000003 Tears-of-the-Kingdom
	#check and prints if the operation is succes
	if [[ $? -eq 0 ]]; then
		is_totk_copied=true
	else
	    echo "Failed to copy TOTK"
	fi

if [[ $is_botw_copied = true  && $is_totk_copied = true ]]; then
	echo "Both games copied succesfully"
	echo "Backups Created"
	echo "Uploading files to github"

	#update the backup-history
	backuptime > temp_file
	cat BACKUP-HISTORY.md >> temp_file
	mv temp_file BACKUP-HISTORY.md

	eval "$git_commands"
fi
