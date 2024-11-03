# Ansible Configuration - Default Inventory File

Default Location:

<figure><img src="https://miro.medium.com/v2/resize:fit:436/1*6H4Sl--353W4TjEuE880Fg.png" alt="" height="63" width="436"><figcaption></figcaption></figure>

An Ansible Configuration file is divided into Several Sections,

<figure><img src="https://miro.medium.com/v2/resize:fit:507/1*SyQ5QQNju32tkcudLh_cPg.png" alt="" height="534" width="507"><figcaption></figcaption></figure>

1. \[Default]

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*X85BcY4SfTa7gjFGVszI_Q.png" alt="" height="336" width="700"><figcaption></figcaption></figure>

You can specify the location to this configuration file through an environment variable & set it to the path to the new config file.this time when playbook is run.\
Ansible picks up that file instead of the default configuration file.

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*NUdqVtFfCFrXryeSPWELKQ.png" alt="" height="34" width="700"><figcaption></figcaption></figure>

another way:specifying the path in an environment variable by creating the config file in the playbooks directory or from the default location.

— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —

1\)what if you have all of them configured & diffrent values for diffrent parameters in each of them ? which one does it consider? and what order does ansible pick the configuration file in?\
Ans) The first priority is always to the parameters configured in file specfied through an “**Environment Variable**”

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*NSBBlnruVcwC6zFlBaxwMg.png" alt="" height="394" width="700"><figcaption></figcaption></figure>

Any values configured in the file overrides the values configured in all other files followed by the “Ansible CFG” File in the current directory from which the anisble playbooks are run, followed by the “.Ansible”CFG File in the user’s home directory.

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*ySvYtUkGRM9f9ZTFza9mRA.png" alt="" height="394" width="700"><figcaption></figcaption></figure>

Yes ,that’s one place that we didn’t mention earlier. and lastly, the default ansible configuration file at /etc/ansible/ansible.cfg ,Remember these files don’t have to have all values.you only need to override the parameter you want to override.

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*uu1thJn8eT0kyoA7CqzzQQ.png" alt="" height="339" width="700"><figcaption></figcaption></figure>

Default values for other parameters will be automatically picked from the next config file in priority chain.

— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -

So let us now look at the values within these files themselves-> say for a instances ,i developed a set of new playbooks for my storage environment& i have decided to go with ansible configuration parameters defined in the “Default Configuration File”. SO i don’t have to make a copy of it into my playbooks directory.when i execute ansible from my storage directory, it first look if there is an “Ansible CFG File(or) /etc/ansible/ansible.cfg” available there,if noot it’s going to use the one in default location.But i realized that there is this one paramter that i need to change,just one for gathering facts . iwant to turnoff it .So i don’t really want to copy the entire “Ansible CFG “File to make that one change

What i could do is override that single parameters using an”Environment variable”

You can set an environment variable before executing the ansible playbook to change that behavior.

So how do you figure out what the environment variable should be?

For most option in configuration file.you can figure out that corresponding environment variable by changing the whole parameter to “UPPERCASE & PREFIXING ANSIBLE UNDERSCORE(\_) to it”like this .

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*YWB_Q09TM4s9nAKjGa9FIQ.png" alt="" height="89" width="700"><figcaption></figcaption></figure>

In this case ,gathering is the parameter,so it would be Ansible Gathering in “UPPERCASE,” =>But you must check documentation as well to confirm that’s the right one.

You could use the “Ansible CFG Command “ to view that information,& of course ,on a LINUX Shell,USe Export to set the “Environment Variable”.

Now Remember, any value set through an environment variable like this takes the ‘“highest precedence’”.all other values specfied in any configuration file are ignored if a corresponding environment variable is set with a diffrent value.

— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -

There are diffrent ways to pass environment variables in.\
1\)you could simply specify it in a key equals value format right before executing the playbook file like this.But remember,

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*rqoa6xr8r3pAHKUiftfmhQ.png" alt="" height="49" width="700"><figcaption></figcaption></figure>

this setting is only applicable to this “single playbook” execution ,the single command

2\)if you want to persist thatthroughout your shell session,

<figure><img src="https://miro.medium.com/v2/resize:fit:641/1*5jivg7Mbipps_VZo6uqT5Q.png" alt="" height="144" width="641"><figcaption></figcaption></figure>

you could use the export command & set the environment variable shell wide until you exit from your shell. this setting will be active.

3\) if you want to make the change persistent across differnt shells across diffrent users running this playbook on diffrent systems,then the best approach is to create a local copy of the configuration file in the playbook s directory & update the parameter in it.

<figure><img src="https://miro.medium.com/v2/resize:fit:678/1*YtT-OGRdfVkqprdm1TlYHg.png" alt="" height="227" width="678"><figcaption></figcaption></figure>

that way you can even check in the configuration file into your code repository.

— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -

So How do you find out what the diffrent configuration options are, what the corresponding environment variables are & what they mean?

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*VE9GW1OdzFVrAGyeRXwH7A.png" alt="" height="103" width="700"><figcaption></figcaption></figure>

To check which config file currently active

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*ap5GfxYJFTXJ3GD56rKsMg.png" alt="" height="112" width="700"><figcaption></figcaption></figure>

what if you’re not sure which setting have been picked up by ansible?

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*Tm4ScDHUTi5IU3DARLsvkA.png" alt="" height="64" width="700"><figcaption></figcaption></figure>
