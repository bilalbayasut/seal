---
cover: >-
  https://images.unsplash.com/photo-1515281239448-2abe329fe5e5?q=80&w=2093&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
coverY: 0
---

# Ansible Collections & Ansible Galaxy

Collections are a distribution format for Ansible content that can include playbooks, roles, modules, and plugins. You can install and use collections through a distribution server, such as Ansible Galaxy, or a Pulp 3 Galaxy server.

By default, `ansible-galaxy collection install` uses [https://galaxy.ansible.com](https://galaxy.ansible.com/) as the Galaxy server (as listed in the `ansible.cfg` file under [GALAXY\_SERVER](https://docs.ansible.com/ansible/latest/reference\_appendices/config.html#galaxy-server)). You do not need any further configuration. By default, Ansible installs the collection in `~/.ansible/collections` under the `ansible_collections` directory.

## Ansible Roles

Ansible Roles provide a well-defined framework and structure for setting your tasks, variables, handlers, metadata, templates, and other files. They enable us to reuse and share our Ansible code efficiently. This way, we can reference and call them in our playbooks with just a few lines of code while we can reuse the same roles over many projects without the need to duplicate our code.

### Why Roles Are Useful in Ansible

When starting with Ansible, it’s pretty common to focus on writing playbooks to automate repeating tasks quickly. As new users automate more and more tasks with playbooks and their Ansible skills mature, they reach a point where using just Ansible playbooks is limiting. Ansible Roles to the rescue!

### Ansible Role Structure

Let’s have a look at the standard role directory structure. For each role, we define a directory with the same name. Inside, files are grouped into subdirectories according to their function. A role must include _at least one of these standard directories_ and _can omit any_ that isn’t actively used.

To assist us with quickly creating a well-defined role directory structure skeleton, we can leverage the command ansible-galaxy init \<your\_role\_name>. The _ansible-galaxy_ command comes bundled with Ansible, so there is no need to install extra packages.

Create a skeleton structure for a role named _test\_role_:

<figure><img src="https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F05%2Fimage4-5.png&#x26;w=3840&#x26;q=75" alt=""><figcaption></figcaption></figure>

This command generates this directory structure:

<figure><img src="https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F05%2Fimage5-5.png&#x26;w=3840&#x26;q=75" alt=""><figcaption></figcaption></figure>

Ansible checks for main.yml files, possible variations, and relevant content in each subdirectory. It’s possible to include additional YAML files in some directories. For instance, you can group your tasks in separate YAML files according to some characteristic.

* defaults –  Includes default values for variables of the role. Here we define some sane default variables, but they have the lowest priority and are usually overridden by other methods to customize the role.
* files  – Contains static and custom files that the role uses to perform various tasks.
* handlers – A set of [handlers](https://docs.ansible.com/ansible/latest/user\_guide/playbooks\_handlers.html) that are triggered by tasks of the role.&#x20;
* meta – Includes metadata information for the role, its dependencies, the author, license, available platform, etc.
* tasks – A list of tasks to be executed by the role. This part could be considered similar to the task section of a playbook.
* templates – Contains [Jinja2](https://docs.ansible.com/ansible/latest/user\_guide/playbooks\_templating.html) template files used by tasks of the role. (Read more about [how to create an Ansible template](https://spacelift.io/blog/ansible-template).)
* tests – Includes configuration files related to role testing.
* vars – Contains variables defined for the role. These have quite a high [precedence](https://docs.ansible.com/ansible/latest/user\_guide/playbooks\_templating.html) in Ansible.

### Using Ansible Roles - Example

Once we have defined all the necessary parts of our role, it’s time to use it in plays. The classic and most obvious way is to reference a role at the play level with the roles option:

```yaml
- hosts: all
  become: true
  roles:
    - webserver
```

With this option, each _role_ defined in our playbook is executed before any other tasks defined in the play.

This is an example play to try out our new _webserver_ role. Let’s go ahead and execute this play. To follow along, you should first run the `vagrant up` command from the top directory of [this repository](https://github.com/spacelift-io-blog-posts/Blog-Technical-Content/tree/master/ansible-roles) to create our target remote host.

<figure><img src="https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F05%2Fimage3-6.png&#x26;w=3840&#x26;q=75" alt=""><figcaption></figcaption></figure>

Sweet! All the tasks have been completed successfully. Let’s also validate that we have configured our Ngnix web server correctly.

### Sharing Roles with Ansible Galaxy

[Ansible Galaxy](https://galaxy.ansible.com/) is an online open-source, public repository of Ansible content. There, we can search, download and use any shared roles and leverage the power of its community. We have already used its client, _ansible-galaxy,_ which comes bundled with Ansible and provides a framework for creating well-structured roles.

You can use Ansible Galaxy to browse for roles that fit your use case and save time by using them instead of writing everything from scratch. For each role, you can see its code repository, documentation, and even a rating from other users. Before running any role, check its code repository to ensure it’s safe and does what you expect. Here’s a blog post on [How to evaluate community Ansible roles](https://www.jeffgeerling.com/blog/2019/how-evaluate-community-ansible-roles-your-playbooks). If you are curious about Galaxy, check out its [official documentation](https://galaxy.ansible.com/docs/) page for more details.

To download and install a role from Galaxy, use the _ansible-galaxy install_ command. You can usually find the installation command necessary for the role on Galaxy. For example, look at [this role that installs a PostgreSQL server](https://galaxy.ansible.com/geerlingguy/postgresql).

Install the role with:

```bash
$ ansible-galaxy install geerlingguy.postgresql
```

Then use it in a playbook while overriding the default role variable _postgresql\_users_ to create an example user for us.

```yaml
---
- hosts: all
  become: true
  roles:
    - role: geerlingguy.postgresql
      vars:
        postgresql_users:
          - name: christina
```
