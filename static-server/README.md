# Static site server

This is a devops roadmap project that tests the user's ability to use **nginx** and **rsync** in setting up a website and syncing files.

## Step 1 Setup server and Nginx

1. Setup your remote server in AWS (using the free-tier).
2. Save your ssh keys and setup ssh/config file to allow easier access.
3. install `nginx` , enable and start the service.

    ```bash
    sudo apt install nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    ```

4. Create the `var/www/html` directory which **nginx** use as the default directory.

5. setup the nginx configuration in `/etc/nginx/nginx.conf`

## Step 2: Setup the static website files.

1. Create the html file for the website.

## Step 3: Create the `deploy.sh` script

1. create the `deploy.sh` script using nano or any other IDE
2. add the content

    ```bash
    #!/bin/bash
    
    LOCAL_PATH="folder/path"
    REMOTE_USER="user"
    REMOTE_HOST="instance ip"
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
    # command rsync -avz -e "ssh -i $SSH_KEY_PATH" "$LOCAL_PATH" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
    command rsync -avz --chmod=D755,F644 "$LOCAL_PATH/" "aws-deploy:$REMOTE_PATH/"
    echo "Files copied successfully!"
    
    echo "Setting final permissions..."
    command ssh aws-deploy "sudo chown -R www-data:www-data $REMOTE_PATH"
    
    
    echo "Deployment completed successfully!"
    ```

3. use ssh configs to connect to the server `aws-deploy`