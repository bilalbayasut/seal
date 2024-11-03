---
cover: >-
  https://images.unsplash.com/photo-1578357078586-491adf1aa5ba?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
coverY: 0
---

# Privilege Escalation

Just as with regular commands that you execute on a terminal, some tasks will require special privileges in order for Ansible to execute them successfully on your remote nodes.

It is important to understand how privilege escalation works in Ansible so that you’re able to execute your tasks with appropriate permissions. By default, tasks will run as the connecting user - this might be either **root** or any regular user with SSH access to the remote nodes in an inventory file.

To run a command with extended permissions, such as a command that requires `sudo`, you’ll need to include a `become` directive set to `yes` in your play. This can be done either as a global setting valid to all tasks in that play, or as an individual instruction applied per task. Depending on how your `sudo` user is set up within the remote nodes, you may also need to provide the user’s `sudo` password. The following example updates the `apt` cache, a task that requires **root** permissions.

Create a new file called `playbook-07.yml` in your `ansible-practice` directory:

```
nano ~/ansible-practice/playbook-07.yml
```

Then add the following lines to the new playbook file:

\~/ansible-practice/playbook-07.yml

```
---
- hosts: all
  become: yes
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
```

Save and close the file when you’re done.

To run this playbook, you’ll need to include the `-K` option within the `ansible-playbook` command. This will make Ansible prompt you for the `sudo` password for the specified user.

```
ansible-playbook -i inventory playbook-07.yml -u sammy -K
```

You can also change which user you want to switch to while executing a task or play. To do that, set the `become_user` directive to the name of the remote user you want to switch to. This is useful when you have several tasks in a playbook that rely on `sudo`, but also a few tasks that should run as your regular user.

The following example defines that all tasks in this play will be executed with `sudo` by default. This is set at the play level, right after the `hosts` definition. The first task creates a file on `/tmp` using `root` privileges, since that is the default `became_user` value. The last task, however, defines its own `become_user`.

Create a new file called `playbook-08.yml` in your `ansible-practice` directory:

```
nano ~/ansible-practice/playbook-08.yml
```

Add the following content to the new playbook file:

\~/ansible-practice/playbook-08.yml

```
---
- hosts: all
  become: yes
  vars:
    user: "{{ ansible_env.USER }}"
  tasks:
    - name: Create root file
      file:
        path: /tmp/my_file_root
        state: touch

    - name: Create user file
      become_user: "{{ user }}"
      file:
        path: /tmp/my_file_{{ user }}
        state: touch

```

Save and close the file when you’re finished.

The `ansible_env.USER` fact contains the username of the connecting user, which can be defined at execution time when running the `ansible-playbook` command with the `-u` option. Throughout this guide, we’re connecting as `sammy`:

```
ansible-playbook -i inventory playbook-08.yml -u sammy -K
```

```
OutputBECOME password: 

PLAY [all] **********************************************************************************************

TASK [Gathering Facts] **********************************************************************************
ok: [203.0.113.10]

TASK [Create root file] *********************************************************************************
changed: [203.0.113.10]

TASK [Create user file] *********************************************************************************
changed: [203.0.113.10]

PLAY RECAP **********************************************************************************************
203.0.113.10           : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

When the playbook is finished running, you can log onto the remote node(s) to verify that two new files were created on `/tmp`, each with different ownership information:

```
ssh sammy@203.0.113.10
```

```
ls -la /tmp/my_file*
```

```
Output-rw-r--r-- 1 root  root 0 Apr 14 13:19 /tmp/my_file_root
-rw-r--r-- 1 sammy sudo 0 Apr 14 12:07 /tmp/my_file_sammy
```
