# Installation & Configuration of Ansible

To start using Ansible, you will need to install it on a control node, this could be your laptop for example. From this control node, Ansible will connect and manage other machines and orchestrate different tasks.

#### Installation Requirements

Your control node can be any machine with Python 3.8 or newer, but Windows is not supported. Windows under a [Windows Subsystem for Linux (WSL) distribution](https://docs.microsoft.com/en-us/windows/wsl/about). Windows without WSL is not natively supported as a control node; see [Matt Davis’ blog post](http://blog.rolpdog.com/2020/03/why-no-ansible-controller-for-windows.html) for more information

For the managed nodes, Ansible needs to communicate with them over SSH and SFTP (this can also be switched to SCP via the ansible.cfg file) or WinRM for Windows hosts. The managed nodes also need Python 2 (version 2.6 or later) or Python (version 3.5 or later) and in the case of Windows nodes PowerShell 3.0 or later and at least .NET 4.0 installed.

The exact installation procedure depends on your machine and operating system but the most common way would be to use pip.

To install pip, in case it’s not already available on your system:

```bash
$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
$ python get-pip.py --user
```

After pip is installed:

```bash
$ python -m pip install --user ansible
```

Since there are different ways to install it for every operating system you can also have a look [here](https://docs.ansible.com/ansible-core/devel/installation\_guide/intro\_installation.html#installing-ansible-on-specific-operating-systems) to find the official suggested way for your environment. Check this [guide on installing Ansible on Ubuntu, RHEL, macOS, CentOS, and Windows](https://spacelift.io/blog/how-to-install-ansible).

You can test on your terminal if it’s successfully installed by running:

```bash
$ ansible --version
```

You can also install ansible using apt

```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
ansible --version

```

