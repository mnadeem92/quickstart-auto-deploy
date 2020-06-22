# OSP Auto Deploy

This repository is for deployment of OSP16 based quickstart environment. It contains Jenkins pipelines, Shell script, Ansible play book and templates required for deployment. The OSP environment can be deployed in 2 ways via

* **Jenkins**
* **Shell script**

The deployment mainly consist of 2 phase, the first phase is configuring the target node and the second phase is the deployment of the actual services.

**Topology:** All in one


# Structure of repository

**setup_env.yaml:** This file contains the ansible task for configuring the target node.

**deploy_osp16.yaml:** This file contains the ansible task for deploying the OSP environment.

**jenkinsfile:** This file containing the pipeline definition for configuring the terget node and deploying the OSP environment from scratch.

**Jenkinsfile2:** This file containing the pipeline definition for re-deploying the OSP environment only when the target node is already configured.

**osp_deploy.sh:** This is the OSP deployment shell script, an alternate way to deploy the OSP environment independent of the jenkins.

**vars:** This directory contains below config and template files required by the deployment pipeline.

**templates:** This directory contains the Jinja2 templates file required for openstack deployment.

~~~
vars/ansible.cfg: Ansible configuration file
vars/config_vars.yaml: Variable config file for ansible playbook
vars/credentials.yaml: Encrypted file contains RHSM credentials
vars/credentials.yaml.sample: Sample reference file for credentials.yaml
vars/mdkey: Encrypted private key to access the target node for stack user
vars/mdkey.pub: Encrypted public key which is injected to target node stack user.
vars/script_config: This file contains the params required by the deploy.sh script and required to set only when deploying the environment via shell script.
templates/containers-prepare-parameters.yaml.j2: Contains details of container registry and tags
templates/standalone_parameters.yaml.j2: Contains default parameters for OSP deployment
~~~

**IMPORTANT:** The ansible vault password(VAULT_PSW) is required to decrypt above encrypted files, If you do not know the existing VAULT_PSW then you can alway override the encrypted file with your own VAULT_PSW as mentioned below

~~~
rm -rf vars/credentials.yaml vars/mdkey vars/mdkey.pub # Delete encrypted files
ssh-keygen -f vars/mdkey                               # Generate new ssh key
cp vars/credentials.yaml.sample vars/credentials.yaml  # Set the new credential values in credentials.yaml 
ansible-vault encrypt vars/credentials.yaml vars/mdkey vars/mdkey.pub # Encrypt the files with a new vault password 
~~~

# Jenkins/script_config Parameters

**NODE_TYPE:** Set type to target node to 'baremetal'(default) for physical server or 'vm' for virtual machine. 

**NODE_IP:** IP of the target node.

**NODE_PSW:** Root password of the target node.

**HOST_NAME:** Host name / CNAME of the target node.

**INTERFACE:** Interface name associated with NODE_IP.

**NETMASK:** Network Mask .

**GATEWAY:** Gateway to the target node network.

**DNS1:** 1st DNS of the target node network.

**DNS2:** 2nd DNS of the target node network.

**VAULT_PSW:** Ansible vault password which has used for encrypted files.


# How to Run

* **Jenkins:**
~~~~~~~~~~
- Create a new project in the Jenkins of kind "Pipeline"
- Use "Jenkinsfile" pipeline file provided to create the pipeline.
- Add all Jenkins Parameters define in above section.
- You need to have Jenkins configured to have Ansible Plugins.
- Execute the pipeline
~~~~~~~~~~

* **Shell script:**
~~~~~~~~~~
- Set the required parameters in vars/script_config file
- Execute the deployment script: sh osp_deploy.sh
~~~~~~~~~~

**Note**: Ansible(version >=2.7.16) should be installed on the node from where the script/pipeline has executed.

