# Connection methods and details

## Setting a remote user

By default, Ansible connects to all remote devices with the username you are using on the control node. If that username does not exist on a remote device, you can set a different username for the connection. If you just need to do some tasks as a different user, look at [Understanding privilege escalation: become](https://docs.ansible.com/ansible/latest/playbook\_guide/playbooks\_privilege\_escalation.html#become). You can set the connection user in a playbook:

```yaml
---
- name: update webservers
  hosts: webservers
  remote_user: admin

  tasks:
  - name: thing to do first in this playbook
  . . .
```

## Setting up SSH keys

By default, Ansible assumes you are using SSH keys to connect to remote machines. SSH keys are encouraged, but you can use password authentication if needed with the `--ask-pass` option. If you need to provide a password for [privilege escalation](https://docs.ansible.com/ansible/latest/playbook\_guide/playbooks\_privilege\_escalation.html#become) (sudo, pbrun, and so on), use `--ask-become-pass`.

Note

Ansible does not expose a channel to allow communication between the user and the ssh process to accept a password manually to decrypt an ssh key when using the ssh connection plugin (which is the default). The use of `ssh-agent` is highly recommended.

To set up SSH agent to avoid retyping passwords, you can do:

```
$ ssh-agent bash
$ ssh-add ~/.ssh/id_rsa
```

Depending on your setup, you may wish to use Ansible’s `--private-key` command line option to specify a pem file instead. You can also add the private key file:

```
$ ssh-agent bash
$ ssh-add ~/.ssh/keypair.pem
```

Another way to add private key files without using ssh-agent is using `ansible_ssh_private_key_file.`

```ini
[defaults]
...
host_key_checking = False
remote_user = ubuntu
private_key_file = ./mykey.pem

```

## Difference between ansible\_ssh\_private\_key\_file and private\_key

#### **1. `ansible_ssh_private_key_file`**

**What It Is:**

* **Purpose:** This is a **standard Ansible inventory variable** used to specify the SSH private key file that Ansible should use when connecting to a particular remote host.
* **Usage Context:** It’s primarily used in your inventory files (like `hosts` or `inventory.yml`) to define connection details for each host.

**Example Usage:**

```ini
iniCopy code# In an inventory file (e.g., inventory.ini)
[webservers]
web1.example.com ansible_ssh_private_key_file=/path/to/private/key1.pem
web2.example.com ansible_ssh_private_key_file=/path/to/private/key2.pem
```

**When to Use It:**

* When you have different SSH keys for different hosts.
* To ensure Ansible uses the correct key for authenticating with each server.

#### **2. `private_key_file`**

**What It Is:**

* **Purpose:** This is **not a standard Ansible variable** for SSH connections. Instead, it’s typically used as a **generic variable** within playbooks, roles, or specific modules to reference a private key file for various tasks.
* **Usage Context:** Its meaning and use can vary depending on where and how you define it. It’s not inherently tied to Ansible’s SSH connection mechanism.

**Example Usage:**

*   **Within a Playbook:**

    ```yaml
    yamlCopy code- name: Deploy application
      hosts: webservers
      vars:
        private_key_file: /path/to/deployment/key.pem
      tasks:
        - name: Use the private key for a specific task
          some_module:
            key: "{{ private_key_file }}"
    ```
*   **Within a Role:**

    ```yaml
    yamlCopy code# roles/deploy/tasks/main.yml
    - name: Upload SSH key
      copy:
        src: "{{ private_key_file }}"
        dest: /home/user/.ssh/id_rsa
        mode: '0600'
    ```

**When to Use It:**

* When a specific task or module within your playbook requires a reference to a private key file.
* To pass key file paths as variables for flexibility and reuse within different parts of your playbook or roles.
