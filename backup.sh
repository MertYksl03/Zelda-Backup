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
	 Create a temporary file safely
	temp_file=$(mktemp) || { echo "Failed to create temporary file"; exit 1; }

	# Write the content to the temporary file
	{
	    echo "LAST BACKUP TIME : $backuptime" &&
	    cat README.md
	} > "$temp_file" || { echo "Failed to prepare content"; rm "$temp_file"; exit 1; }

	# Safely update README.md
	cat "$temp_file" > README.md || { echo "Failed to update README.md"; rm "$temp_file"; exit 1; }

	# Clean up temporary file
	rm "$temp_file"

	eval "$git_commands"
	if [[ $? -eq 0 ]]; then
		echo "Uploading to Github is succesful"
		echo "BACKUP DONE"
	else
		echo "BACKUP FAILED"
	fi
fi
