# ad-hoc commands
```bash
ansible all -i inventory.ini -m ping --private-key=mykey.pem
# to see what ansible sees
ansible-inventory -i /path/to/inventory/file --graph
```