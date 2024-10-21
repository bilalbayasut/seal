---
coverY: 0
---

# Ansible Tasks, Play & Playbook

## Difference between Ansible task, play and playbook

### **1. What is a Task in Ansible?**

**A task** is the smallest unit of work in Ansible. It represents a single action to be performed on a target host.

**Key Points:**

* **Action-Oriented:** Each task performs a specific action, such as installing a package, copying a file, or starting a service.
* **Module-Based:** Tasks utilize Ansible modules (like `yum`, `apt`, `copy`, `service`, etc.) to execute actions.
* **Sequential Execution:** Within a play, tasks are executed in the order they are defined.
* **Idempotent:** Tasks are designed to be idempotent, meaning running them multiple times won’t produce unintended side effects.

**Example Task:**

```yaml
name: Install Nginx
  apt:
    name: nginx
    state: present
```

_This task installs the Nginx web server using the `apt` module._

***

### **2. What is a Play in Ansible?**

**A play** maps a group of hosts to roles or tasks. It defines **what** should be done and **on which** hosts.

**Key Points:**

* **Targeting Hosts:** Specifies the inventory hosts or groups that the play will apply to.
* **Variables and Settings:** Can define variables, handlers, and other configurations specific to the play.
* **Multiple Plays:** Ansible playbooks can contain multiple plays, each targeting different hosts or performing different functions.
* **Role Inclusion:** Plays can include roles, which are collections of tasks, variables, files, and handlers.

**Example Play:**

```yaml
yamlCopy code- name: Configure Web Servers
  hosts: webservers
  become: yes
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Start Nginx Service
      service:
        name: nginx
        state: started
        enabled: true
```

_This play targets the `webservers` group, installs Nginx, and ensures the Nginx service is running and enabled._

***

### **3. What is a Playbook in Ansible?**

**A playbook** is a YAML file containing one or more plays. It orchestrates the automation process by defining a series of plays to be executed in sequence.

**Key Points:**

* **Collection of Plays:** Playbooks can contain multiple plays, each potentially targeting different hosts or performing different roles.
* **Complex Automation:** Facilitates complex automation workflows by combining multiple tasks and plays.
* **Reusability and Organization:** Allows for organizing tasks into roles and reusing them across different playbooks.
* **Version Control:** Playbooks can be version-controlled, shared, and maintained as code.

**Example Playbook:**

```yaml
yamlCopy code---
- name: Configure Web Servers
  hosts: webservers
  become: yes
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Start Nginx Service
      service:
        name: nginx
        state: started
        enabled: true

- name: Configure Database Servers
  hosts: dbservers
  become: yes
  tasks:
    - name: Install MySQL
      apt:
        name: mysql-server
        state: present

    - name: Start MySQL Service
      service:
        name: mysql
        state: started
        enabled: true
```

_This playbook contains two plays: one for configuring web servers and another for configuring database servers._

## Hands On: Ansible playbooks

Playbook concept is very simple: it's just a series of ansible commands (tasks), like the ones we used with the `ansible` CLI tool. These tasks are targeted at a specific set of hosts/groups.

The necessary files for this step should have appeared magically and you don't even have to type them.

### Apache example (a.k.a. Ansible's "Hello World!")

We assume we have the following inventory file (let's name it `hosts`):

```ini
[web]
host1
```

and all hosts are debian-like.

Note: remember you can (and in our exercise we do) use `ansible_host` to set the real IP of the host. You can also change the inventory and use a real hostname. In any case, use a non-critical machine to play with! In the real hosts file, we also have `ansible_user=root` to cope with potential different ansible default configurations.

Lets build a playbook that will install apache on machines in the `web` group.

```yaml
- hosts: web
  tasks:
    - name: Installs apache web server
      apt:
        pkg: apache2
        state: present
        update_cache: true
```

We just need to say what we want to do using the right ansible modules. Here, we're using the [apt](http://docs.ansible.com/apt\_module.html) module that can install debian packages. We also ask this module to update the package cache.

We also added a name for this task. While this is not necessary, it's very informative when the playbook runs, so it's highly recommended.

All in all, this was quite easy!

You can run the playbook (lets call it `apache.yml`):

```bash
ansible-playbook -i step-04/hosts -l host1 step-04/apache.yml
```

Here, `step-04/hosts` is the inventory file, `-l` limits the run only to `host1` and `apache.yml` is our playbook.

When you run the above command, you should see something like:

```bash
PLAY [web] *********************

GATHERING FACTS *********************
ok: [host1]

TASK: [Installs apache web server] *********************
changed: [host1]

PLAY RECAP *********************
host1              : ok=2    changed=1    unreachable=0    failed=0
```

Note: you might see a cow passing by if you have `cowsay` installed. You can get rid of it with `export ANSIBLE_NOCOWS="1"` if you don't like it.

Let's analyse the output one line at a time.

```
PLAY [web] *********************
```

Ansible tells us it's running the play on hosts `web`. A play is a suite of ansible instructions related to a host. If we'd have another `- hosts: blah` line in our playbook, it would show up too (but after the first play has completed).

```bash
GATHERING FACTS *********************
ok: [host1]
```

Remember when we used the `setup` module? Before each play, ansible runs it on necessary hosts to gather facts. If this is not required because you don't need any info from the host, you can just add `gather_facts: no` below the host entry (same level as `tasks:`).

```
TASK: [Installs apache web server] *********************
changed: [host1]
```

Next, the real stuff: our (first and only) task is run, and because it says `changed`, we know that it changed something on `host1`.

```
PLAY RECAP *********************
host1              : ok=2    changed=1    unreachable=0    failed=0
```

Finally, ansible outputs a recap of what happened: two tasks have been run and one of them changed something on the host (our apache task, setup module doesn't change anything).

Now let's try to run it again and see what happens:

```bash
$ ansible-playbook -i step-04/hosts -l host1 step-04/apache.yml

PLAY [web] *********************

GATHERING FACTS *********************
ok: [host1]

TASK: [Installs apache web server] *********************
ok: [host1]

PLAY RECAP *********************
host1              : ok=2    changed=0    unreachable=0    failed=0
```

Now 'changed' is '0'. This is absolutely normal and is one of the core features of ansible: the playbook will act only if there is something to do. It's called _idempotency_ and means that you can run your playbook as many times as you want, you will always end up in the same state (well, unless you do crazy things with the `shell` module of course, but this is beyond ansible's control).
