---
cover: >-
  https://images.unsplash.com/photo-1523474253046-8cd2748b5fd2?crop=entropy&cs=srgb&fm=jpg&ixid=M3wxOTcwMjR8MHwxfHNlYXJjaHw1fHxhbWF6b24lMjBzZXJ2ZXJ8ZW58MHx8fHwxNzI5NDg2NDc5fDA&ixlib=rb-4.0.3&q=85
coverY: -150
---

# Configure AWS EC2 Server with Ansible

We use an ansible plugin called dynamic inventory to automatically populate our inventory instead of manually relying on updating inventory file manually. Here are what it does:-

* Get inventory hosts from Amazon Web Services EC2.
* The inventory file is a YAML configuration file and must end with `aws_ec2.{yml|yaml}`. Example: `my_inventory.aws_ec2.yml`.

> <mark style="color:red;">IMPORTANT!</mark> : Make sure the the inventory yaml file must end with `aws_ec2.{yml|yaml}`. Example: `my_inventory.aws_ec2.yml`.

### [Requirements](https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws\_ec2\_inventory.html#id2)

The below requirements are needed on the local controller node that executes this inventory.

* python >= 3.6
* boto3 >= 1.26.0
* botocore >= 1.29.0

Run this to install the plugin via ansible galaxy

<pre class="language-bash"><code class="lang-bash"><strong># optional, didn't need to run this to get it working
</strong><strong>ansible-galaxy collection install amazon.aws
</strong></code></pre>

you will see something like :-

```bash
❯ ansible-inventory --graph      
@all:
  |--@ungrouped:
  |--@aws_ec2:
  |  |--44.210.88.184
  |  |--18.205.156.50
  |  |--54.90.93.162
(.venv) 
```
