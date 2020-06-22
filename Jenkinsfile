pipeline {
    agent { node "Master" }
    stages {
        stage('git_checkout_repo') {
	  steps {
             checkout(
            [$class: 'GitSCM',
            branches: [[name: '*/master']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [],
            submoduleCfg: [],
            userRemoteConfigs: [
                [url: 'https://github.com/mnadeem92/quickstart-auto-deploy.git']
                ]
            ]
        )
}
        }
        stage('decrypt_vault_data') {
            steps {
                sh '''
		  ls $WORKSPACE
                  cd $WORKSPACE
                  echo $VAULT_PSW > /tmp/vault_file
                  echo $NODE_PSW > /tmp/psw_file
                  ansible-vault decrypt --vault-password-file /tmp/vault_file vars/mdkey vars/mdkey.pub vars/credentials.yaml
                  ssh-keygen -R $NODE_IP
                  sshpass -f /tmp/psw_file ssh-copy-id -i $WORKSPACE/vars/mdkey.pub -o StrictHostKeyChecking=no root@$NODE_IP
                  rm -rf /tmp/vault_file
                  rm -rf /tmp/psw
                '''
            }
        }
        stage('create inventory'){
            steps {
                sh '''
		  echo $NODE_IP > $WORKSPACE/inventory
		   '''
		   }
            }
	
        stage('setup environment'){
	  steps {
                withEnv(['ANSIBLE_CONFIG=$WORKSPACE/vars/ansible.cfg']){
                ansiblePlaybook(
                      extras: '-e NODE_IP=$NODE_IP -e HOST_NAME=$HOST_NAME -e @vars/config_vars.yaml -e @vars/credentials.yaml',
                      installation: 'ansible',
                      inventory: '$WORKSPACE/inventory',
                      playbook: '$WORKSPACE/setup_env.yaml',
                )
               }
	      }
            }
        stage('Deploy OpenStack'){
	  steps {
                withEnv(['ANSIBLE_CONFIG=$WORKSPACE/vars/ansible.cfg']){
                ansiblePlaybook(
                      extras: '-e NODE_IP=$NODE_IP -e NETMASK=$NETMASK -e GATEWAY=$GATEWAY -e INTERFACE=$INTERFACE  -e DNS1=$DNS1 -e DNS2=$DNS2 -e NODE_TYPE=$NODE_TYPE -e @vars/config_vars.yaml -e @vars/credentials.yaml',
                      installation: 'ansible',
                      inventory: '$WORKSPACE/inventory',
                      playbook: '$WORKSPACE/deploy_osp16.yaml',
                )
               }
	      }
            }

        
    }
}
