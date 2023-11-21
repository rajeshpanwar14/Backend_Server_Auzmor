# Project README

This README document provides comprehensive instructions on setting up and running the application. It covers essential steps, including installing the required Ruby and Rails versions, checking versions, starting the Rails server and console, migrating the database, and running unit/integration tests using RSpec.


# Technology Stack

- **Database**: PostgreSQL 14
- **Caching**: Redis
- **Testing**: RSpec
- **Hosting**: AWS EC2 Instance
- **API Testing**: Postman



## Setup Instructions

### Ruby Version

1. Install Ruby version 2.6.8:

    ```bash
    rbenv install 2.6.8
    # or
    rvm install 2.6.8
    ```

2. Install JRuby version 9.3.3.0:

    ```bash
    rbenv install jruby-9.3.3.0
    ```

3. Install Rails version 6.0.6.1:

    ```bash
    gem install rails -v 6.0.6.1
    ```

### Verify Installed Versions

- Check Rails version:

    ```bash
    rails -v
    ```

- Check Ruby version:

    ```bash
    ruby -v
    ```

## Start the Rails Server/Console:

1. Start Rails server:

    ```bash
    rails s
    # or 
    rails s -p port_number
    ```

2. To Start Rails console:

    ```bash
    rails c
    ```

## Unit/Integration Testing:

1. Install dependencies:

    ```bash
    gem 'rspec-rails'
    # then run: 
    bundle install
    ```

2. Generate RSpec configuration:

    ```bash
    rails generate rspec:install
    ```

3. Set the rails environment for test cases:

    ```bash
    rails db:environment:set RAILS_ENV=test
    ```

4. To execute all test cases:

    ```bash
    bundle exec rspec
    ```

5. To execute a specific file's test cases:

    ```bash
    bundle exec rspec spec/path/to/file_spec.rb
    # or 
    rspec
    ```

## Now we can test our APIs using Postman

## For Basic authentication:

- Change authorization in Postman to Basic Auth.
- Then enter username and password:
    - Username will be the username in the accounts table.
    - Passwords will be auth_id.

## Sample Curl 

1. For Outbound:

    ```bash
    curl --location '13.126.255.78/outbound/sms' \
    --header 'Authorization: Basic dXNlcl9vbmU6YXV0aDEyMw==' \
    --form 'from="4924195509197"' \
    --form 'to="4924195509197"' \
    --form 'text="Hello World"'
    ```

2. For Inbound:

    ```bash
    curl --location '13.126.255.78/inbound/sms' \
    --header 'Authorization: Basic dXNlcl9vbmU6YXV0aDEyMw==' \
    --form 'from="4924195509197"' \
    --form 'to="4924195509197"' \
    --form 'text="Hello World"'
    ```

# Connecting to an EC2 Instance via SSH

This guide will walk you through the process of connecting to an EC2 instance using SSH.

## Setup The PEM File

1. **Download PEM File:**
   - Download the pem file.

2. **Change File Permissions:**
   - Open the terminal and navigate to the directory where the PEM file is located.
   - Run the command:
     ```bash
     chmod 400 rajesh_ruby_2.pem
     ```

## Connect to the EC2 Instance

3. **SSH Connection:**
   - In the terminal, use the following command to connect to the EC2 instance:
     ```bash
     ssh -i "rajesh_ruby_2.pem" ubuntu@ec2-13-126-255-78.ap-south-1.compute.amazonaws.com
     ```

4. **First Connection Prompt:**
   - Upon the first connection, a prompt will appear asking to add the key.
   - **Do Not Skip.**
   - Type "yes" and press Enter to proceed.


## Important
- **Security Precautions:**
  - Please do not share the PEM file publicly.


# EC2 Instance Terminal Management

This guide outlines how to manage terminals on an EC2 instance where the server and Redis are running on different terminals.

## Connect To Byobu Session

- **To Connect Or To Start A Byobu Session:**
  - In Terminal, use the command:
    ```bash
    byobu
    ```
  - This will connect you to the existing session.

## Terminal Setup

### Server Terminal (Terminal 0)
The server is running on Terminal 0. Do not close this terminal.

### Redis Terminal (Terminal 2)
Redis is running on Terminal 2. Do not close this terminal.

## Instructions
1. **Switching Terminals:**
   - Use `fn + F3` to cycle between the different terminals.
   
2. **Creating a New Terminal:**
   - If you need an additional terminal, press `fn + F2`.
   
3. **Exiting a Terminal:**
   - Ensure all running processes are stopped.
   - Type `exit` and press `Enter` to close the terminal.

4. **Disconnecting:**
   - Press `fn + F6` to disconnect.
   - Close the local terminal.

## Notes
- **Viewing Redis Logs:**
  - Run `redis-cli` in the Redis terminal (Terminal 1).
  - Type `KEYS *` and press `Enter` to view the keys in the Redis instance.

- **Running Rails Console:**
  - To run Rails console, use the command:
    ```bash
    rails c
    ```
  - This will start the Rails console for your application.