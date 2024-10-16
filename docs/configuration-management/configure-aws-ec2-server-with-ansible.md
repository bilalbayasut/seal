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

```bash
ansible-galaxy collection install amazon.aws
```

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



