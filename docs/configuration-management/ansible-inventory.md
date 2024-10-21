---
cover: >-
  https://images.unsplash.com/photo-1616401784845-180882ba9ba8?crop=entropy&cs=srgb&fm=jpg&ixid=M3wxOTcwMjR8MHwxfHNlYXJjaHwxfHxpbnZlbnRvcnl8ZW58MHx8fHwxNzI5NDg2NDI5fDA&ixlib=rb-4.0.3&q=85
coverY: 0
---

# Ansible Inventory

The Inventory is the collection of the machines that we would like to manage. Usually, the default location for inventory is `/etc/ansible/hosts` but we can also define a custom one in any directory.&#x20;

To make sure ansible can connect to the servers, we usually do like this :-

```bash
ansible all -i inventory.ini -m ping --private-key=mykey.pem

# or this if we want to check what servers ansible can map
ansible-inventory -i /path/to/inventory/file --graph
```

We used the information acquired by Terraform to populate our hosts file. We will talk more about ad-hocs command in the next section.

We specified some variables, such as the host, user, and SSH connection parameters necessary to connect to our managed nodes. Here’s a full list of [inventory parameters](https://docs.ansible.com/ansible/latest/user\_guide/intro\_inventory.html#connecting-to-hosts-behavioral-inventory-parameters) that we can configure per host.

We will keep this inventory simple for the time being, but check out [this guide](https://docs.ansible.com/ansible/latest/user\_guide/intro\_inventory.html) to explore other inventory options such as creating host groups, adding ranges of hosts, and grouping variables.

For example, we can define groups of hosts like this:\


```bash
[webservers]
webserver1.example.com
webserver2.example.com
webserver3.example.com
192.0.6.45

[databases]
database1.example.com
database2.example.com
```

In the above example, we defined two groups of hosts, webservers and databases.
