# Introduction to Ansible

Check this slide here for [introduction to Ansible](https://docs.google.com/presentation/d/1OdEr8kYXHy44hmP21JU0CaiMazVCrk9tR6SsE3AGi9Q/edit?usp=sharing)

<figure><img src="https://lh7-rt.googleusercontent.com/slidesz/AGV_vUdjIhGfbsilNXz1gJkI5QivLY3RIQBR_mKy5ERkF0yx0isRR7L1ZhQ_V-iUzzcJ3i23DeSynvuCo3Etv0Pu-VZ9K-GzyoH27vVDOpsATaFVGIBFZsoT0D6ylsQZSqZG3D5xzIeHxbiA92alqksTGsQVVkGxM-je=s2048?key=RFtutVVLQxIAh-OI8WOPcw" alt=""><figcaption></figcaption></figure>

## What is Ansible

Ansible provides open-source automation that reduces complexity and runs everywhere. Using Ansible lets you automate virtually any task. Here are some common use cases for Ansible:

* Eliminate repetition and simplify workflows
* Manage and maintain system configuration
* Continuously deploy complex software
* Perform zero-downtime rolling updates

How Ansible Works

<figure><img src="../.gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

In the diagram above, the management node is the controlling node (managing node) that controls the whole execution of the playbook and the node from which you run the installation. The inventory file contains a list of hosts on which the Ansible modules must be executed. The management node establishes an SSH connection before running the modules on the host machines and installing the product. Once installed, it uninstalls the modules.
