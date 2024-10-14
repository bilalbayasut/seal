# Ansible ad-hoc Commands

An Ansible ad hoc command uses the _/usr/bin/ansible_ command-line tool to automate a single task on one or more managed nodes. ad hoc commands are quick and easy, but they are not reusable. So why learn about ad hoc commands? ad hoc commands demonstrate the simplicity and power of Ansible.

### [Why use ad hoc commands](https://docs.ansible.com/ansible/latest/command\_guide/intro\_adhoc.html#id4)

ad hoc commands are great for tasks you repeat rarely. For example, if you want to power off all the machines in your lab for Christmas vacation, you could execute a quick one-liner in Ansible without writing a playbook. An ad hoc command looks like this:

```
$ ansible [pattern] -m [module] -a "[module options]"
```

The `-a` option accepts options either through the `key=value` syntax or a JSON string starting with `{` and ending with `}` for more complex option structure. You can learn more about [patterns](https://docs.ansible.com/ansible/latest/inventory\_guide/intro\_patterns.html#intro-patterns) and [modules](https://docs.ansible.com/ansible/latest/plugins/module.html#module-plugins) on other pages.

### [Use cases for ad hoc tasks](https://docs.ansible.com/ansible/latest/command\_guide/intro\_adhoc.html#id5)

ad hoc tasks can be used to reboot servers, copy files, manage packages and users, and much more. You can use any Ansible module in an ad hoc task. ad hoc tasks, like playbooks, use a declarative model, calculating and executing the actions required to reach a specified final state. They achieve a form of idempotence by checking the current state before they begin and doing nothing unless the current state is different from the specified final state.

#### [Rebooting servers](https://docs.ansible.com/ansible/latest/command\_guide/intro\_adhoc.html#id6)

The default module for the `ansible` command-line utility is the [ansible.builtin.command module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command\_module.html#command-module). You can use an ad hoc task to call the command module and reboot all web servers in Atlanta, 10 at a time. Before Ansible can do this, you must have all servers in Atlanta listed in a group called \[atlanta] in your inventory, and you must have working SSH credentials for each machine in that group. To reboot all the servers in the \[atlanta] group:

```
$ ansible atlanta -a "/sbin/reboot"
```

By default, Ansible uses only five simultaneous processes. If you have more hosts than the value set for the fork count, it can increase the time it takes for Ansible to communicate with the hosts. To reboot the \[atlanta] servers with 10 parallel forks:

```
$ ansible atlanta -a "/sbin/reboot" -f 10
```

/usr/bin/ansible will default to running from your user account. To connect as a different user:

```
$ ansible atlanta -a "/sbin/reboot" -f 10 -u username
```

Rebooting probably requires privilege escalation. You can connect to the server as `username` and run the command as the `root` user by using the [become](https://docs.ansible.com/ansible/latest/playbook\_guide/playbooks\_privilege\_escalation.html#become) keyword:

```
$ ansible atlanta -a "/sbin/reboot" -f 10 -u username --become [--ask-become-pass]
```

If you add `--ask-become-pass` or `-K`, Ansible prompts you for the password to use for privilege escalation (sudo/su/pfexec/doas/etc).

Note
