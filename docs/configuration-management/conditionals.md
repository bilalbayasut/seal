---
cover: >-
  https://images.unsplash.com/photo-1516246843873-9d12356b6fab?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
coverY: 112.07705192629817
---

# Conditionals

### What is an Ansible conditional?

Conditionals are an Ansible feature that allows you to control the execution flow of playbook tasks based on declared conditions. Tasks that include the Ansible conditionals are executed only if specific criteria are met; if the condition is false, the task is skipped. This capability is particularly valuable when managing diverse environments with different operating systems or configurations.\


Ansible conditionals have many different use cases, including:&#x20;

* Inputting certain variables based on the environment you are running the playbook against
* Kicking off DB backup only when the disk space usage is above a certain threshold&#x20;
* Triggering  reboots if certain files were changed or updated&#x20;
* Adding or modifying users based on their roles and departments&#x20;
* Skipping tasks under certain conditions
* Notifying teams if tasks related to their team were added or modified (e.g., Notify DB team if Database configurations have been changed)

#### Types of Ansible conditionals

Below are types of Ansible conditionals we can use throughout our playbooks:

* Simple conditions — Run a task if a single variable is equivalent to the condition listed in the `when` statement.
* Registered variables conditions — Capture the result of a previous task using `register` and use it as a condition on a later task using `when`.&#x20;
* Ansible facts conditions — Ansible Facts offer a set of variables you can reference to gather system data such as OS, hardware details, etc. You can set conditions based on the Ansible facts to execute your task.&#x20;
* Logical operators — This includes operators such as AND, OR, and NOT. They allow you to combine different conditions and offer more logical options for running your tasks.

### Using when and register conditions in Ansible playbooks

Let’s start by reviewing the `when` statement and utilizing it alongside the `register` statement.

#### Ansible `when` condition

The following example is a simple scenario using the Ansible `when` statement to validate that a condition is true. The task will run only if the condition is true. If it is false, the task will be skipped to ensure no misconfigurations with environments occur will take place.

```yaml
- name: Start service if on production
  service:
    name: httpd
    state: started
  when: environment == 'production'
```

#### Ansible `register` condition

Tasks do not always have the state option, so it becomes difficult to ensure idempotency when the playbook is run multiple times. In these cases, you can `register` a validate step (checking if that application exists) as a variable and place a `when` condition for this registered variable to exist to run the dependent tasks. The Ansible register conditional ensures the tasks you don’t want to run again are skipped.

For example, we want to install a Tomcat application, but the Download/Extract task shouldn’t run each time during our Playbook runs because it could slow down the run time or possibly replace config files we have already set up. To do this, we can easily utilize the `register`/`when` conditionals.

```yaml
- name: Check if Tomcat Webapp Exists
  stat:
    path: /opt/tomcat/webapps/ROOT/WEB-INF/web.xml
  register: tomcat_extracted

- name: Download Apache Tomcat
  get_url:
    url: "https://downloads.apache.org/tomcat/tomcat-9/v{{ tomcat_version }}/bin/apache-tomcat-{{ tomcat_version }}.tar.gz"
    dest: "/tmp/apache-tomcat-{{ tomcat_version }}.tar.gz"
  when: not tomcat_extracted.stat.exists

- name: Extract Tomcat
  unarchive:
    src: "/tmp/apache-tomcat-{{ tomcat_version }}.tar.gz"
    dest: /opt/tomcat
    remote_src: true
    extra_opts: ["--strip-components=1"]
  when: not tomcat_extracted.stat.exists
```

Note: The syntax for the conditionals is based on the return values for the Ansible stat module. When registering a variable under a module, you receive a dictionary of all the return values you can reference in your when conditionals.

For this example, we are referencing the ‘stat’ dictionary with a return value of the boolean ‘exists’_._ You can find these in Ansible’s documentation for the module you use.&#x20;

If we run this playbook a second time, it would automatically skip the Download and Extract tasks because the file path already exists on the target host:

```bash
module.myapp.module.ansible-my-app.null_resource.ansible_run (remote-exec): TASK [tomcat_role : Check if Tomcat Webapp Exists] *****************************

module.myapp.module.ansible-my-app.null_resource.ansible_run (remote-exec): ok: [10.10.10.10]

module.myapp.module.ansible-my-app.null_resource.ansible_run (remote-exec): TASK [tomcat_role : Download Apache Tomcat] ************************************

module.myapp.module.ansible-my-app.null_resource.ansible_run (remote-exec): skipping: [10.10.10.10]

module.myapp.module.ansible-my-app.null_resource.ansible_run (remote-exec): TASK [tomcat_role : Extract Tomcat] ********************************************

module.myapp.module.ansible-my-app.null_resource.ansible_run (remote-exec): skipping: [10.10.10.10]
```

Read more about Ansible playbooks: [Ansible Playbooks: Complete Guide with Examples](https://spacelift.io/blog/ansible-playbooks).

### Conditions using Ansible Facts

So far, we have covered how to use conditionals with specific values assigned to variables, but what if we already have that information, and we can validate whether a conditional is true or false based on the ‘fact’ of the target host machine?&#x20;

#### Ansible when conditional in Ansible Facts

Ansible\_facts allows you to take facts related to aspects of your target host, such as OS, device, IP address, and filesystems. You can use the Ansible `when` condition to validate if a specific fact is true or not in order for your task to run.&#x20;

For example, if you have a different Linux OS across your environment and you want to ensure you install the correct application per OS, you can use a condition like the following to make sure your playbooks run successfully:

```yaml
- name: Install a package ONLY on Red Hat-based systems
  yum:
    name: httpd
    state: present
  when: ansible_os_family == "RedHat"
```

To find the ansible\_os\_family value you can run a test playbook against each of your Linux OS target hosts (Ubuntu, RedHat) using the following debug module to retrieve the entire dictionary of all the ansible\_facts you can reference in your conditional:&#x20;

```yaml
- name: Print all available facts
  debug:
    var: ansible_facts
```

This will give you a dictionary resembling the following (only it will show the output for the section that includes ‘ansible\_os\_family’ because this generates a large output), which you can reference in many ways to ensure you are running the correct tasks against the correct machines:

```bash
{
    "ansible_nodename": "centos-7-rax-dfw-0003427354",
    "ansible_os_family": "RedHat",
    "ansible_pkg_mgr": "yum",
    "ansible_processor": [
        "0",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "1",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "2",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "3",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "4",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "5",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "6",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "7",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz"
    ],
}
```

#### Ansible `when` and `register` conditionals in Ansible Facts

Another common technique for improving consistency in your Ansible playbooks is to use both when and register with ansible\_facts in the same task.&#x20;

For example, we may have tasks that need to be installed on a specific OS distro and the dependent tasks can only run if the initial task is true. We want to ensure NTP is installed across all of our Linux boxes because CentOS and Ubuntu have different package names and different package managers.&#x20;

To install Chrony (the CentOS NTP package) on CentOS/RHEL machines only and NTP on Ubuntu/Debian machines, we can utilize the `when` condition with the ansible\_fact and register/when to create a dependency on the initial task.&#x20;

```yaml
 - name: Install Chrony on CentOS/RHEL
      yum:
        name: chrony
        state: present
      when: ansible_facts['os_family'] == "RedHat"
      register: package_installed

    - name: Ensure Chrony service is enabled and running on CentOS/RHEL
      systemd:
        name: chronyd
        state: started
        enabled: yes
      when: package_installed is changed

    - name: Install NTP on Ubuntu/Debian
      apt:
        name: ntp
        state: present
      when: ansible_facts['os_family'] == "Debian"
      register: package_installed

    - name: Ensure NTP service is enabled and running on Ubuntu/Debian
      systemd:
        name: ntp
        state: started
        enabled: yes
      when: package_installed is changed
```

💡 You might also like:

* [Common infrastructure challenges and how to solve them](https://spacelift.io/blog/infrastructure-problems-that-spacelift-solves)
* [How to better manage Ansible and overcome challenges](https://spacelift.io/blog/spacelift-ansible-integration-beta)
* [44 Ansible best practices to follow](https://spacelift.io/blog/ansible-best-practices)

### Using the when condition in Ansible roles

As a best practice, you should use [Ansible roles](https://spacelift.io/blog/ansible-roles) in your playbooks. They allow you to break up your playbook into reusable components, which can be referenced throughout to make the applications or tasks become more modularized and decoupled.&#x20;

When using conditionals in Ansible Roles, you can enforce logical conditionals on the playbook level as well as within the role’s tasks, improving flexibility.&#x20;

Here are three key ways to enforce Ansbile conditionals within roles.&#x20;

#### 1. Applying Ansible conditionals under roles on the playbook level

The first way is to apply conditionals under roles on the playbook level, which applies to all the tasks that are under the role. This can be used when we want to point our playbook to deploy to ‘all’ host machines but want certain roles to apply to specific machine inventory groups in the [Ansible inventory file](https://spacelift.io/blog/ansible-inventory).&#x20;

To achieve this goal, we can use the following setup: The Apache role is deployed only to the webservers group, and Postgresql is deployed only to the databases group in the inventory file. This is only run under the roles option, making it suitable for your role-based playbooks.&#x20;

```yaml
- hosts: all
  roles:
    - role: apache
      when: "'webservers' in group_names"
    - role: postgresql
      when: "'databases' in group_names"
```

#### 2. Applying Ansible conditionals to import roles under tasks on the playbook level

The second way is to apply conditionals to import roles under tasks on the playbook level. This method gives you the flexibility to use task-level features in your roles, such as loops, tagging, etc. You can also mix roles with other tasks in your playbooks, which can be helpful in certain scenarios.&#x20;

For example, this conditional import role allows us to loop through each application variable in apps and use tags to import the proper role that way. This allows us to determine which environment to assign our application to on the variable level and just have the playbook loop through it:

```yaml
- hosts: all
  vars:
    environment: staging
    apps:
      - name: app1
        deploy_in: ['dev', 'staging']
      - name: app2
        deploy_in: ['staging', 'production']
      - name: app3
        deploy_in: ['dev']
  tasks:
    - name: Deploy apps for each environment
      import_role:
        name: "{{ item.name }}_deployment"
      loop: "{{ apps }}"
      when: environment in item.deploy_in
      tags: 
        - deploy
```

#### 3. Applying conditionals to the tasks in roles from the playbook level

The third approach lets you apply conditionals to the tasks in the roles themselves from the playbook level. This is the only way that enables you to skip or select specific role tasks in our role.&#x20;

Here, we are using the include\_role feature in our playbook and adding the when statement under it to specify the conditional. It is useful for complex roles where only specific tasks need to be executed under certain conditions instead of the entire role.

In this example, we are configuring a web server, but specific tasks under the role should only run for the hosts that meet the criteria (based on environment and inventory group name).

Role:&#x20;

```yaml
---
- name: Install HTTP server
  apt:
    name: apache2
    state: present
  when: "'web' in inv_groups"

- name: Configure HTTP server for production
  template:
    src: production.conf.j2
    dest: /etc/apache2/sites-available/sample.conf
  when: environment == 'production'

- name: Configure HTTP server for staging
  template:
    src: staging.conf.j2
    dest: /etc/apache2/sites-available/sample.conf
  when: environment == 'staging'
```

Playbook:

```yaml
- hosts: all
  vars:
    environment: "{{ lookup('env', 'ENVIRONMENT') }}"
  tasks:
    - name: Dynamically include web server configuration role
      include_role:
        name: web_server_configuration
      when: "'web' in inv_groups"
```

This setup ensures the web server is not deployed to any machine outside the web inventory group and the application is deployed to the proper environment. Maximizing flexibility and control allows you to write specific roles that can be included dynamically in various playbooks across different environments.&#x20;

### Ansible when condition with multiple conditions

#### Using the `when` condition with logical AND operator

The AND logical operator is very helpful when you want to create _precise control flows_ within your Ansible playbook and ensure multiple conditionals are true for that task, role, or block to run. It can also be used when handling _complex logic_ because it allows you to place different types of checks under one when statement.&#x20;

In the following example, we are using the AND operator with the Ansible `when` conditional to ensure that this task only runs on production machines that are running _CentOS_ because `yum` will not work for other distros:

```bash
- hosts: all
  tasks:
    - name: Deploy updates to production servers
      yum:
        name: '*'
        state: latest
      when: ansible_facts['distribution'] == "CentOS" and inventory_hostname in groups['production']
```

You can also use the AND operator in a single line instead of writing out ‘and’ whenever conditionals become lengthy.

```yaml
- hosts: all
  tasks:
    - name: Check Tomcat version
      shell: tomcat9 version | grep 'Server number'
      register: tomcat_version
      changed_when: false

    - name: Update Tomcat on older versions during weekends
      apt:
        name: tomcat9
        state: latest
      when: 
        - "'9.0.82' in tomcat_version.stdout"
        - ansible_date_time.weekday in ['Saturday', 'Sunday']
```

#### Using `when` condition with logical OR operator

The OR operator allows one or other conditional in the `when` statement to be true for that task to run. It also reduces complexity in a similar way to the AND operator, because you can use one playbook for different operations.&#x20;

In the following example, we want to ensure any host with a distribution of Debian or Ubuntu, will use ‘apt’, and any host with a distribution of CentOS or RedHat will use `yum` to install Tomcat.&#x20;

```yaml
- hosts: all
  tasks:
    - name: Install Tomcat on Debian or Ubuntu
      apt:
        name: tomcat9
        state: present
      when: ansible_facts['distribution'] == "Debian" or ansible_facts['distribution'] == "Ubuntu"

    - name: Install Tomcat on CentOS or RHEL
      yum:
        name: tomcat
        state: present
      when: ansible_facts['distribution'] == "CentOS" or ansible_facts['distribution'] == "RedHat"
```

Here is another example of using both AND/OR logical operators in the Ansible `when` condition to check the logs to send out email notifications when certain variable status outputs are detected and if the email\_enabled option is set to true:

```yaml
- hosts: all
  vars:
    email_enabled: true
  tasks:
    - name: Check for critical errors in logs
      shell: grep "CRITICAL ERROR" /var/log/myapp.log
      register: log_check
      ignore_errors: True

    - name: Send alert email for errors
      mail:
        to: user@domain.com
        subject: 'Critical: Error Detected'
        body: 'A critical error has occurred on {{ inventory_hostname }}.'
      when: 
        - (log_check.rc == 0 or server_status == 'critical') and email_enabled  
```

#### Using `when` condition with logical NOT operator

The logical NOT operator specifies certain tasks that should only execute when a specific condition is NOT true. It helps define the _opposite conditionals_ to make your playbooks more intuitive and easily exclude hosts, variables, and states.&#x20;

In the following example, we are using the NOT operator to ensure the mounting directory is created only if the variable mount\_point\_stat does NOT exist:

```yaml
- hosts: all
  tasks:
    - name: Check if mount point directory exists
      stat:
        path: "{{ mount_point }}"
      register: mount_point_stat

    - name: Create mount point directory
      file:
        path: "{{ mount_point }}"
        state: directory
        mode: 755
      when: not mount_point_stat.stat.exists
```

You can also use the NOT operator to check if the variable or _ansible\_fact_ does not equal a specific value:&#x20;

```yaml
- hosts: all
  tasks:
    - name: Install a package using apt
      apt:
        name: curl
        state: present
      when: ansible_facts['os_family'] != "Windows"
```

The NOT operator can be helpful if you want to ensure a specific task never runs on a production environment:

```yaml
- hosts: all
  vars:
    environment: development
  tasks:
    - name: Deploy configuration files
      copy:
        src: config.conf
        dest: /etc/app/config.conf
      when: environment != "production"
```
