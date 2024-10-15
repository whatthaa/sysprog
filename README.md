# Sysprog Package Installer

This repository provides a streamlined experience for installing a package that calculates the number of files in the `/etc` directory, excluding directories and symbolic links. The repository builds two package formats: `.RPM` and `.DEB`, both of which can be managed through Jenkins running in a Docker container.

## Prerequisites

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Jenkins](https://www.jenkins.io/) (will be set up through Docker)

## Installation Instructions

Follow these steps to set up the environment and build the packages:

**Clone the Repository**  
Download the repository to your local machine:
```bash
git clone https://github.com/whatthaa/sysprog
```
**Navigate to the Repository Directory**

Change to the repository directory:
```bash
cd ~/sysprog
```
**Install Docker (if not already installed)**

If Docker is not installed, you can install it for APT using:
```bash
sudo apt install docker.io
```
**Build the Docker Image**

Build the Docker configuration for Jenkins:
```bash
sudo docker build -t my-jenkins .
```
**Run Jenkins in Docker**

Start the Docker container for Jenkins:
```bash
sudo docker run -d \
    -p 8080:8080 \
    -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name my-jenkins \
    jenkins/jenkins:lts
```
After executing following command it starts the Docker container, making it accessible on port 8080. It also maps the Jenkins home directory and Docker socket to the container.

## Usage
**Create a New Jenkins Job**  
Once Jenkins is up and running, follow these steps to create a new job:

- Open Jenkins in your browser at [http://localhost:8080](http://localhost:8080).
- From the dashboard, click on **"New Item"**.
- Enter a name for your job and select **"Pipeline"** as the job type.
- Click **"OK"** to create the job.

**Configure the Pipeline Job**  
Set up the pipeline job to connect with following GitHub repository:

- In the job configuration page, scroll down to the **"Pipeline"** section.
- Under **"Definition"**, select **"Pipeline script from SCM"**.
- For **"SCM"**, choose **"Git"**.
- In the **"Repository URL"** field, enter: https://github.com/whatthaa/sysprog

**Save and Run the Job**  

- Click **"Save"** to store the job configuration.
- Proceed to **"Build Now"** option under created Pipeline Job, **select package type:** `.RPM` or `.DEB` and wait for finishing the build and install.

