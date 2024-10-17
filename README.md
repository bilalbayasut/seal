# SEAL
```bash
# use staging env
terraform apply -var-file=staging.env --auto-approve
```

```bash
# use staging env
ANSIBLE_CONFIG=./configs/ansible.cfg ansible-playbook ./playbooks/install_docker_wordpress.yml --extra-vars "@env.yml"
```