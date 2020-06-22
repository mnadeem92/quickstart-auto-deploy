export WORKSPACE=`pwd`
source vars/script_config
echo $VAULT_PSW > ./vault_file
echo $NODE_PSW > ./psw_file
ansible-vault decrypt --vault-password-file ./vault_file vars/mdkey vars/mdkey.pub vars/credentials.yaml
ssh-keygen -R $NODE_IP
sshpass -f ./psw_file ssh-copy-id -i $WORKSPACE/vars/mdkey.pub -o StrictHostKeyChecking=no root@$NODE_IP
rm -rf ./vault_file
rm -rf ./psw
echo $NODE_IP > $WORKSPACE/inventory
export ANSIBLE_CONFIG=$WORKSPACE/vars/ansible.cfg
ansible-playbook -i $WORKSPACE/inventory -e NODE_IP=$NODE_IP -e HOST_NAME=$HOST_NAME -e @vars/config_vars.yaml -e @vars/credentials.yaml  $WORKSPACE/setup_env.yaml

ansible-playbook -i $WORKSPACE/inventory -e NODE_IP=$NODE_IP -e NETMASK=$NETMASK -e GATEWAY=$GATEWAY -e INTERFACE=$INTERFACE  -e DNS1=$DNS1 -e DNS2=$DNS2 -e NODE_TYPE=$NODE_TYPE -e @vars/config_vars.yaml -e @vars/credentials.yaml  $WORKSPACE/deploy_osp16.yaml

