# Description: A simple deployment script to deploy files to a remote server
# Created by: Kemboi 
# Followed the roadmap dev guide
# use the .ssh/config file to set up the ssh connection to the remote server saved as was deploy
#!/bin/bash

LOCAL_PATH="folder/path"
REMOTE_USER="user"
REMOTE_HOST="instance"
REMOTE_PATH="/var/www/html"


#adding error checking
command() {
    $@
    if [ $? -ne 0 ]; then
        echo "Error: $@"
        exit 1
    fi
}

echo "Setting up remote directory..."
command ssh aws-deploy "sudo mkdir -p $REMOTE_PATH && sudo chown -R $REMOTE_USER:$REMOTE_USER $REMOTE_PATH"
echo "Remote directory setup completed successfully!"

echo "Copying files to remote directory..."
# rsync uses the -avz flag to archive files and copy them recursively, while preserving symlinks, permissions, timestamps, owner, and group.
# The --chmod flag is used to set the permissions of the copied files and directories.

command rsync -avz --chmod=D755,F644 "$LOCAL_PATH/" "aws-deploy:$REMOTE_PATH/"
echo "Files copied successfully!"

echo "Setting final permissions..."
command ssh aws-deploy "sudo chown -R www-data:www-data $REMOTE_PATH"


echo "Deployment completed successfully!"