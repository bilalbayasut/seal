---
description: Make your playbook customizable
cover: >-
  https://images.unsplash.com/photo-1653074281018-c08f358059ab?q=80&w=1933&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
coverY: 144
---

# Ansible Variables

### What are Ansible variables?

Ansible variables are dynamic values used within Ansible playbooks and roles to enable customization, flexibility, and reusability of configurations. They are very similar to variables in programming languages, helping you manage complex tasks more efficiently by allowing the same playbook or role to be applied across different environments, systems, or contexts without the need for hardcoding specific information.

#### Why are variables useful in Ansible?

The use of variables simplifies the management of dynamic values throughout an Ansible project and can potentially reduce the number of human errors. We have a convenient way to handle variations and differences between different environments and systems with variables.&#x20;

Another advantage of variables in Ansible is that we have the flexibility to define them in multiple places with different precedence according to our use case. We can also register new variables in our playbooks by using the returned value of a task.

### Variable naming rules

Ansible has a strict set of rules to create valid variable names. Variable names can contain only letters, numbers, and underscores and must start with a letter or underscore. Some strings are reserved for other purposes and aren’t valid variable names, such as [Python Keywords](https://docs.python.org/3/reference/lexical\_analysis.html#keywords) or [Playbook Keywords](https://docs.ansible.com/ansible/latest/reference\_appendices/playbooks\_keywords.html#playbook-keywords).

Apart from these, as for every programming language and configuration language, the variable names should be short and meaningful, because otherwise, you will have a hard time with debugging them, especially in a complex playbook.

Good variable names:

* web\_server\_port
* db\_connection\_timeout
* ssh\_private\_key
* max\_attempts\_retry

All of the above variable names make sense and are very easy to understand, even without seeing them used in the code.

Bad variable names:

* my\_var – even though it is valid, you don’t understand what this is doing without seeing it in the code
* tm@p%$2 – this contains special characters, so it is invalid
* 1var – this starts with a number, so it is invalid

### Types of variables in Ansible

Variables in Ansible can come from different sources and can be used in playbooks, roles, inventory files, and even within modules.&#x20;

Here are the variable types you may encounter while using Ansible:

* Playbook variables – These variables are used to pass values into playbooks and roles and can be defined inline in playbooks or included in external files.
* Task variables – These variables are specific to individual tasks within a playbook. These can override other variable types for the scope of the task in which they are defined.
* Host variables – Specific to hosts, these variables are defined in the inventory or loaded from external files or scripts and can be used to set attributes that differ between hosts.
* Group variables – Similar to host variables but used for a group of hosts and are defined in the inventory or separate files in the group\_vars directory.
* Inventory variables – These variables are defined in the inventory file itself and can be applied at different levels (host, group, all groups).
* Fact variables – Gathered by Ansible from the target machines, facts are a rich set of variables (including IP addresses, operating system, disk space, etc.) that represent the current state of the system and are automatically discovered by Ansible.
* Role variables – Defined within a role, these variables are usually part of the role’s default variables (defaults/main.yaml file) or variables intended to be set by the role user (vars/main.yaml file) and are used to enable reusable and configurable roles.
* Extra variables – Passed to Ansible at runtime using the -e or –extra-vars command-line option. They have the highest precedence and can be used to override other variables or to pass data that might change between executions.
* Magic variables – Special variables such as hostvars, group\_names, groups, inventory\_hostname, and ansible\_playbook\_python, provide information about the execution context and allow access to inventory data programmatically.
* Environment variables –  Used within Ansible playbooks to access environment variables from the system running the playbook or from remote systems.

### Simple variables

The simplest use case of variables is to define a variable name with a single value using standard [YAML syntax](https://spacelift.io/blog/yaml). Although this pattern can be used in many places, we will show an example in a playbook for simplicity.

```yaml
- name: Example Simple Variable
  hosts: all
  become: yes
  vars:
    username: bob

  tasks:
  - name: Add the user {{ username }}
    ansible.builtin.user:
      name: "{{ username }}"
      state: present
```

In the above example, after the vars block, we define the variable username, and assign the value bob. Later, to reference the value in the task, we use [Jinja2 syntax](https://docs.ansible.com/ansible/latest/user\_guide/playbooks\_templating.html) like this “\{{ username \}}”&#x20;

If a variable’s value starts with curly braces, [we must quote the whole expression](https://docs.ansible.com/ansible/latest/user\_guide/playbooks\_variables.html#when-to-quote-variables-a-yaml-gotcha) to allow YAML to interpret the syntax correctly.

### List, dictionary & nested variables

There are many other options to define more complex variables like lists, dictionaries, and nested structures. To create a variable with multiple values, we can use YAML lists syntax:

```yaml
vars:
  version:
    - v1
    - v2
    - v3
```

To reference a specific value from the list we must select the correct field. For example, to access the third value _v3_:

```yaml
version: "{{ version[2] }}"

```

Another useful option is to store key-value pairs in variables as dictionaries. For example:

```yaml
vars:
  users: 
    - user_1: maria
    - user_2: peter
    - user_3: sophie
```

Similarly, to reference the third field from the dictionary, use the bracket or dot notation:

```yaml
users['user_3']
users.user_3
```

Note that the bracket notation is preferred as you might encounter problems using the dot notation in special cases.

Sometimes, we have to create or use nested variable structures. For example, facts are nested data structures. We have to use a bracket or dot notation to reference nested variables.

```yaml
vars:
  cidr_blocks:
      production:
        vpc_cidr: "172.31.0.0/16"
      staging:
        vpc_cidr: "10.0.0.0/24"

tasks:
- name: Print production vpc_cidr
  ansible.builtin.debug:
    var: cidr_blocks['production']['vpc_cidr']
```

### Special variables

Ansible special variables are a set of predefined variables that contain information about the system data, inventory, or execution context inside an Ansible playbook or role. These include magic variables, connection variables, and facts. The names of these variables are reserved.&#x20;

#### Magic variables

[Magic variables](https://docs.ansible.com/ansible/latest/reference\_appendices/special\_variables.html#magic-variables) are automatically created by Ansible and cannot be changed by a user. These variables will always reflect the internal state of Ansible, so they can be used only as they are.

```yaml
---
- name: Echo playbook
  hosts: localhost
  gather_facts: no
  tasks:
    - name: Echo inventory_hostname
      ansible.builtin.debug:
        msg:
          - "Hello from Ansible playbook!"
          - "This is running on {{ inventory_hostname }}"
```

In the above playbook, we are defining a playbook that uses the _inventory\_hostname_ magic variable. We are using this variable to get the name of the host on which Ansible runs and print a message with it as shown below.

```yaml
PLAY [Echo playbook] ********************************************************************************************************************************

TASK [Echo inventory_hostname] **********************************************************************************************************************
ok: [localhost] => {
    "msg": [
        "Hello from Ansible playbook!",
        "This is running on localhost"
    ]
}

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Apart from **inventory\_hostname**, some other essential magic variables are:

* hostvars → leveraged for getting information about other hosts in the inventory, including any variables that are associated with them.\

* play\_hosts → lists all the hosts that are targeted by the current play.
* group\_names → contains a list of groups names to which the current host belongs in the inventory.
* groups → key/value pair of all the groups in the inventory with all the hosts that belong to each group.

#### Ansible facts

[Ansible facts](https://docs.ansible.com/ansible/latest/reference\_appendices/special\_variables.html#facts) are leveraged for getting system and hardware facts gathered about the current host during playbook execution. This data is often utilized for creating dynamic inventories, templating, or making decisions based on host-specific attributes. The gathered facts can be accessed using the _ansible\_facts_ variable, allowing you to reference specific information like the operating system, IP address, or CPU architecture.

To collect facts about a specific host, you can run the following command:

```yaml
ansible -m setup <hostname>
```

Also, you can add the _`gather_facts: yes`_ option to your playbook to ensure facts are collected after executing tasks.

With Ansible facts, you have the option to filter for specific facts like os or even the IP address. This can be done with:

```yaml
ansible -m setup <hostname> -a "filter=<fact_name>
```

**What is the difference between variables and facts in Ansible?**

Variables are defined by the user, whereas facts are discovered directly from the target machines. While variables are used for playbook and role customization, facts provide insight into the current state of the target machines based on real-time system information. Variables can be modified and even overridden in various parts of playbooks and roles and even on the run-time, while facts are considered to be read-only system snapshots.

#### Connection variables

[Connection variables](https://docs.ansible.com/ansible/latest/reference\_appendices/special\_variables.html#connection-variables) are used to define how the machine that runs Ansible connects to remote hosts during the execution of tasks and playbooks. These variables provide flexibility in managing various connection types, authentication methods, and host-specific configurations.

```yaml
---
- name: Echo message on localhost
  hosts: localhost
  connection: local
  gather_facts: no
  vars:
    message: "Hello from Ansible playbook on localhost!"
  tasks:
    - name: Echo message and connection type
      ansible.builtin.shell: "echo '{{ message }}' ; echo 'Connection type: {{ ansible_connection }}'"
      register: echo_output

    - name: Display output
      ansible.builtin.debug:
        msg: "{{ echo_output.stdout_lines }}"
```

In the above example, we are using the connection variable, to show the connection type on a run as shown below:

```yaml
PLAY [Echo message on local host] *******************************************************************************************************************

TASK [Echo message and connection type] *************************************************************************************************************
changed: [localhost]

TASK [Display output] *******************************************************************************************************************************
ok: [localhost] => {
    "msg": [
        "Hello from Ansible playbook on localhost!",
        "Connection type: local"
    ]
}

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### Registering variables

During our plays, we might find it handy to utilize the output of a task as a variable that we can use in the following tasks. We can use the keyword register to create our own custom variables from task output.

```yaml
- name: Example Register Variable Playbook
  hosts: all
  
  tasks:
  - name: Run a script and register the output as a variable
    shell: "find hosts"
    args:
      chdir: "/etc"
    register: find_hosts_output
  - name: Use the output variable of the previous task
    debug:
      var: find_hosts_output
```

In the above example, we register the output of the command _find /etc/hosts_, and we showcase how we can use the variable in the next task by printing its value.

<figure><img src="https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F04%2Fimage3.png&#x26;w=3840&#x26;q=75" alt=""><figcaption></figcaption></figure>

A powerful pattern is to combine registered variables with conditionals to create tasks that will only be executed when certain custom conditions are true.

```yaml
- name: Example Registered Variables Conditionals
  hosts: all
  
  tasks:
  - name: Register an example variable
    shell: cat /etc/hosts
    register: hosts_contents

  - name: Check if hosts file contains the word "localhost"
    debug:
      msg: "/etc/hosts file contains the word localhost"
    when: hosts_contents.stdout.find("localhost") != -1
      var: find_hosts_output
```

Here, we registered in the variable _hosts\_contents_ the contents of /etc/hosts file, and we execute the second task only if the file contains the word _localhost_.

<figure><img src="https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F04%2Fimage2.png&#x26;w=3840&#x26;q=75" alt=""><figcaption></figcaption></figure>

Since registered variables are stored in memory, it’s not possible to use them in future plays, and they are only available for the current playbook run.

💡 You might also like:

* [Using Terraform & Ansible together](https://spacelift.io/blog/using-terraform-and-ansible-together)
* [7 Ansible use cases for management & automation](https://spacelift.io/blog/ansible-use-cases)
* [44 Ansible best practices to follow](https://spacelift.io/blog/ansible-best-practices)

### Environment variables

Environment variables are a powerful way to influence the behavior of playbooks and tasks by passing external values into the Ansible runtime environment. These can be system environment variables available where Ansible is executed or on the managed nodes.

You should be cautious when using environment variables for sensitive data, as their values might be logged or exposed in debugging output, and relying on them will affect the overall portability and reusability of your playbook. Setting environment variables within tasks or plays will override those of the same name in the system environment for the duration of the task or play execution.

### How to share and reuse Ansible variables?

When we want to reuse and share variables, we can leverage _YAML anchors and aliases_. They provide us with great flexibility in handling shared variables and help us reduce the repetition of data. Learn more in our [Complete YAML Guide](https://spacelift.io/blog/yaml).

_Anchors_ are defined with &, and then referenced with an _alias_ denoted with \*. Let’s go and check a hands-on example in a playbook.

```yaml
- name: Example Anchors and Aliases
  hosts: all
  become: yes
  vars:
    user_groups: &user_groups
     - devs
     - support
    user_1:
        user_info: &user_info
            name: bob
            groups: *user_groups
            state: present
            create_home: yes
    user_2:
        user_info:
            <<: *user_info
            name: christina
    user_3:
        user_info:
            <<: *user_info
            name: jessica
            groups: support

  tasks:
  - name: Add several groups
    ansible.builtin.group:
      name: "{{ item }}"
      state: present
    loop: "{{ user_groups }}"

  - name: Add several users
    ansible.builtin.user:
      <<: *user_info
      name: "{{ item.user_info.name }}"
      groups: "{{ item.user_info.groups }}"
    loop:
      - "{{ user_1 }}"
      - "{{ user_2 }}"
      - "{{ user_3 }}"
```

Here, since some options are shared between users, instead of rewriting the same values, we share the common ones with the anchor _\&user\_info_. For every subsequent user declaration, we use the alias _\*user\_info_ to avoid repeating ourselves as much as possible.

The values for _state_ and _create\_home_ are the same for all the users, while _name_ and _groups_ are replaced using the merge operator <<.&#x20;

Similarly, we reuse the _user\_groups_ declaration in the definition of the _user\_info_ anchor. This way, we don’t have to type the same groups again for _user\_2_ while we still have the flexibility to override the groups, as we do for _user\_3_.&#x20;

The result is that _user\_1_ and _user\_2_ are added to groups _devs_ and _support,_ while _user\_3_ is added only to the _support_ group.

<figure><img src="https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F04%2Fimage4.png&#x26;w=3840&#x26;q=75" alt=""><figcaption></figcaption></figure>

### Variable scope

Ansible provides many options on setting variables, and the ultimate decision on where to set them lies with us based on the scope we would like them to have. Conceptually, there are three main options available for scoping variables.&#x20;

First, we have the global scope where the values are set for all hosts. This can be defined by the Ansible configuration, environment variables, and command line.&#x20;

We set values for a particular host or group of hosts using the host scope. For example, there is an option to define some variables per host in the _inventory_ file.

Lastly, we have the play scope, where values are set for all hosts in the context of a play. An example would be the _vars_ section we have seen in previous examples in each playbook.

### Where to set Ansible variables?

Variables can be defined with Ansible in many different places. There are options to set variables in playbooks, roles, inventory, var files, and command line. Let’s go and explore some of these options.&#x20;

#### 1. Vars block

As we have previously seen, the most straightforward way is to define variables in a play with the vars section.

```yaml
- name: Set variables in a play
  hosts: all
  vars:
    version: 12.7.1
```

#### 2. Inventory files

Another option is to define variables in the inventory file. We can set variables per host or set shared variables for groups. This example defines a different _ansible user_ to connect for each host as a host variable and the same _HTTP port_ for all web servers as a group variable.

```yaml
[webservers]
webserver1 ansible_host=10.0.0.1 ansible_user=user1
webserver2 ansible_host=10.0.0.2 ansible_user=user2

[webservers:vars]
http_port=80
```

To better organize our variables, we could gather them in separate host and group variables files. In the same directory where we keep our [Ansible inventory](https://spacelift.io/blog/ansible-variables) or playbook files, we can create two folders named group\_vars and host\_vars that would contain our variable files. For example:

```yaml
group_vars/databases 
group_vars/webservers
host_vars/host1
host_vars/host2
```

#### 3. Custom var files

Variables can also be set in _custom var files_. Let’s check an example that uses variables from an external file and the _group\_vars_ and _host\_vars_ directories.

```yaml
- name: Example External Variables file
  hosts: all
  vars_files:
    - ./vars/variables.yml

  tasks:
  - name: Print the value of variable docker_version
    debug: 
      msg: "{{ docker_version}} "
  
  - name: Print the value of group variable http_port
    debug: 
      msg: "{{ http_port}} "
  
  - name: Print the value of host variable app_version
    debug: 
      msg: "{{ app_version}} "
```

The _vars/variables.yml_ file:

```yaml
docker_version: 20.10.12
```

The _group\_vars/webservers_ file:

```yaml
http_port: 80
ansible_host: 127.0.0.1
ansible_user: vagrant
```

The _host\_vars/host1_ file:

```yaml
app_version: 1.0.1
ansible_port: 2222
ansible_ssh_private_key_file: ./.vagrant/machines/host1/virtualbox/private_key
```

The _host\_vars/host2_ file:

```yaml
app_version: 1.0.2
ansible_port: 2200
ansible_ssh_private_key_file: ./.vagrant/machines/host2/virtualbox/private_key
```

The inventory file contains a group named _webservers_ that includes our two hosts, _host1_ and _host2:_

```yaml
[webservers]
host1 
host2
```

If we run this playbook, we notice the same value is used in both hosts for the group variable _http\_port_ but a different one for the host variable _app\_version._

<figure><img src="https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F04%2Fimage1.png&#x26;w=3840&#x26;q=75" alt=""><figcaption></figcaption></figure>

A good use case for having separate variables files is that you can keep in them sensitive values without storing them in playbooks or source control systems.

Occasionally we might find it helpful to define or override variables at runtime by passing them at the command line with –extra-vars or –e argument. For example:

```yaml
ansible-playbook example-external-vars.yml --extra-vars "app_version=1.0.3"
```

### Variables precedence

Since variables can be set in multiple places, Ansible applies variable precedence to select the variable value according to some hierarchy. The general rule is that variables defined with a more explicit scope have higher priority.

For example, role defaults are overridden by mostly every other option. Variables are also flattened to each host before each play, so all group and hosts variables are merged. Host variables have higher priority than group variables.&#x20;

Explicit variable definitions like the _vars_ directory or an _include\_vars_ task override variables from the inventory. Finally, extra vars defined at runtime always win precedence. For a complete list of options and their hierarchy, look at the official documentation [Understanding variable precedence](https://docs.ansible.com/ansible/latest/user\_guide/playbooks\_variables.html#understanding-variable-precedence).

### Best practices for managing Ansible variables

Since Ansible provides a plethora of options to define variables, it might be a bit confusing to figure out the best way and place to set them. Let’s go and check some common & best practices around setting variables that might help us better organize our Ansible projects.

* Always give descriptive and clear names to your variables. Taking a moment to properly think about how to name variables always pays off long-term.
* If there are default values for common variables, set them in group\_vars/all
* Prefer setting group and host vars in group\_vars and host\_vars directories instead of in the inventory file.
* If variables related to geography or behavior are tied to a specific group, prefer to set them as group variables.
* If you are using roles, always set default role variables in roles/your\_role/defaults/main.yml
* When you call roles, pass variables that you wish to override as parameters to make your plays easier to read.

```yaml
roles:
       - role: example_role
         vars:
            example_var: 'example_string'
```

* You can always use –extra-vars or –e to override every other option.
* Don’t store sensitive variables in your source code repository in plain text. You can leverage [Ansible Vault](https://spacelift.io/blog/ansible-vault#encrypting-sensitive-info-with-ansible-vault) in these cases.

In general, try to keep variable usage as simple as possible. You don’t have to use all the existing options and spread variables definition all over the place because that makes debugging your Ansible projects difficult. Try to find a structure that suits your needs best and stick to it!&#x20;
