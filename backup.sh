#!/bin/bash

cd ~/scripts/zelda-backup || { echo "Failed to change directory"; exit 1; }

echo "Backup starting..."

is_botw_copied=false
is_totk_copied=false
is_git_succesful=false
is_local_backup_created=false

backuptime=$(date +"%Y-%m-%d %H:%M:%S")

git_commands="
git add .
git commit -m \"$backuptime\"
git push
"

echo "Copying Breath of the Wild save files..."
if [ -d "/home/mert/.var/app/org.ryujinx.Ryujinx/config/Ryujinx/bis/user/save/0000000000000002" ]; then
    cp -r /home/mert/.var/app/org.ryujinx.Ryujinx/config/Ryujinx/bis/user/save/0000000000000002 Temp/Breath-of-the-Wild
    if [[ $? -eq 0 ]]; then
        is_botw_copied=true
    else
        echo "Failed to copy BOTW"
    fi
else
    echo "Source directory for BOTW does not exist"
    exit 1
fi

echo "Copying Tears of the Kingdom save files..."
if [ -d "/home/mert/.var/app/org.ryujinx.Ryujinx/config/Ryujinx/bis/user/save/0000000000000003" ]; then
    cp -r /home/mert/.var/app/org.ryujinx.Ryujinx/config/Ryujinx/bis/user/save/0000000000000003 Temp/Tears-of-the-Kingdom
    if [[ $? -eq 0 ]]; then
        is_totk_copied=true
    else
        echo "Failed to copy TOTK"
    fi
else
    echo "Source directory for TOTK does not exist"
    exit 1
fi

if [[ $is_botw_copied = true && $is_totk_copied = true ]]; then
    # Remove the old save 
    rm -rf Breath-of-the-Wild Tears-of-the-Kingdom
    # Copy the new save from the Temp folder
    cp -r Temp/* .
    # Check if the copying is ok  
    if [[ $? -eq 0 ]]; then
        echo "Both games copied successfully"
        is_local_backup_created=true
        echo "Deleting the Temp"
        rm -rf Temp
    else
        echo "ERROR: Can't create local backup (Couldn't copy files from the temp folder)"
        exit 1
    fi
fi

if [ "$is_local_backup_created" = true ]; then
    echo "Uploading files to github"

    # Update the backup-history
    temp_file=$(mktemp) || { echo "Failed to create temporary file"; exit 1; }

    # Write the content to the temporary file
    {
        echo "-- $backuptime -- " &&
        echo &&
        cat README.md
    } > "$temp_file" || { echo "Failed to prepare content"; rm "$temp_file"; exit 1; }

    # Safely update README.md
    cat "$temp_file" > README.md || { echo "Failed to update README.md"; rm "$temp_file"; exit 1; }

    # Clean up temporary file
    rm "$temp_file"

    # Run git commands
    # eval "$git_commands" || { echo "Git commands failed"; exit 1; }

    echo "Uploading to Github is successful"
    echo "BACKUP DONE"
else
    echo "Local backup was not created. Exiting."
    exit 1
fi
