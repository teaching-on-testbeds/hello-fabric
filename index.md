# Hello, FABRIC

In this tutorial, you will learn how to use FABRIC to run experiments in computer networks or cloud computing. It should take you about 60-90 minutes of *active* time to work through this tutorial.

> **Note** This process has multiple "human in the loop" approval stages - you'll need to wait for FABRIC staff to approve your account, and then again for your your instructor or research advisor to add you to their project. Be prepared to start the tutorial, wait for this approval, and then continue.

FABRIC is a "virtual lab" for experiments on networking, cloud computing, and distributed systems. It allows experimenters to set up real (not simulated!) hosts and links at FABRIC sites located around the United States. Experimenters can then log in to the hosts associated with their experiment and install software, run applications, and collect measurements.

Before you can run lab experiments on FABRIC, you will need to set up an account. Once you have completed the steps on this page, you will have an account that you can use for future experiments. This experiment will also demonstrate the process of "reserving" resources on a FABRIC site, logging in to a host on FABRIC, retrieving a file (such as data from an experiment) from a FABRIC host, and deleting your reserved resources to free them for other users.

## Set up your account on FABRIC

Now that you have the software you need, you are ready to set up an account on FABRIC.

### Exercise - Create an account

First, go to <https://portal.fabric-testbed.net/>. If it is your first time visiting this website, click "OK" on the bottom to accept cookies from this website. Then, click the "Sign Up" button in the top right corner.

Read the instructions on the following page, then click "Proceed".

On the following page, use the drop-down menu in the "Select an Identity Provider" box - change the setting from ORCID to your university affiliation. (If your university is not listed there, your instructor or research advisor can provide further instruction on how to log in.)

Once you have made your selection, click "Log On". You will be directed to log in using your university credentials. Then, you'll be prompted to begin setting up your FABRIC account:

![Start setting up your FABRIC account.](images/fabric-step-1.png)

Click "Begin" to continue. Next, you will be prompted to select/confirm your institution, and then you will have the opportunity to confirm or modify your personal information (name, etc.). Click "Submit" when you are ready to continue.

Within 10-15 minutes, you will receive an email in order to confirm your email address. The email will include a link (redacted in this screenshot):

![Click on the link (redacted in this screenshot) to confirm your email.](images/fabric-confirm-email.png)

Click on the link to continue setting up your account. (This email is automated, so if you don't see it in your inbox or spam folder, you may not have completed your account submission.)

To continue, you'll need to click "Accept":

!["Accept" to continue setting up your account.](images/fabric-accept.png)

### Exercise - Join a project

At this stage, you have an account on FABRIC, but your account is not yet a part of any project. To use FABRIC, you need to be a part of a project that has been approved by the FABRIC staff, under the supervision of a project lead who supervises your use of FABRIC.

If you click on the "Projects" tab in the FABRIC portal dashboard (while logged in to your FABRIC account), you'll see a list of projects that you belong to. For now, you won't be part of any project! You will need to let your instructor or research advisor know that you have created your FABRIC account, and tell them the email address associated with your FABRIC account. Once they have added you to their project, you'll see it listed on that page, and you can continue with the next step.

### Exercise - Open this notebook in Jupyter

Once you are part of a FABRIC project, you can reserve resources on FABRIC and access them over SSH! We'll use FABRIC's Jupyter environment for this.

Log on to the [FABRIC Portal](https://portal.fabric-testbed.net/), then click on the "JupyterHub" menu option. You may be prompted to log in again.

To continue working on this tutorial, you'll want to get the rest in "notebook" form.

In the Jupyter environment, select File \> New \> Terminal and in this terminal, run

    git clone https://github.com/teaching-on-testbeds/hello-fabric

Then, in the file browser on the left side, open the `hello-fabric` directory and then double-click on the `hello_fabric.ipynb` notebook to open it.

If you are prompted about a choice of kernel, you can accept the Python3 kernel.

Then, you can continue this tutorial by executing the cells in the notebook directly in this Jupyter environment.

### Exercise: Configure your Jupyter environment

You should now be inside the Jupyter environment in FABRIC. Before you use this environment for the first time, you'll want to create some configuration files that tell it who you are, what project you belong to, and what key it should use to access your resource on FABRIC.

First, we will need to generate some keys! On FABRIC, we access the resources (hosts, switches, routers) in our experiment by connecting to a server known as a "bastion" over an SSH connection, and then connecting from the "bastion" to the device that we want to use. Both "hops" will be over SSH, a secure protocol for remote login, and both hops will use an SSH *key* for authentication. Using SSH key authentication to connect to a remote system is a more secure alternative to logging in with an account password.

SSH key authentication uses a pair of separate keys (i.e., a key pair): one "private" key, which you keep a secret, and the other "public". A key pair has a special property: any message that is encrypted with your private key can only be decrypted with your public key, and any message that is encrypted with your public key can only be decrypted with your private key.

This property can be exploited for authenticating login to a remote machine. First, the public key is uploaded to a specific location on the remote machine. Then, when you want to log in to the machine:

1.  You use a special argument with your SSH command to let your SSH application know that you are going to use a key, and the location of your private key. If the private key is protected by a passphrase, you may be prompted to enter the passphrase (this is not a password for the remote machine, though).
2.  The machine you are logging in to will ask your SSH client to "prove" that it owns the (secret) private key that matches an authorized public key. To do this, the machine will send a random message to you.
3.  Your SSH client will encrypt the random message with the private key and send it back to the remote machine.
4.  The remote machine will decrypt the message with your public key. If the decrypted message matches the message it sent you, it has "proof" that you are in possession of the private key for that key pair, and will grant you access (without using an account password on the remote machine.)

(Of course, this relies on you keeping your private key a secret.)

To access resources in our FABRIC experiments, we will use a "bastion key" to authenticate on the "hop" to the "bastion", and then a "slice key" to authenticate on the hop from the "bastion" to the FABRIC resource. In this exercise, we'll prepare both of those keys, then tell the FABRIC Jupyter environment where to find them and how to use them.

First, we will use the FABRIC Portal to generate the bastion key. In the [FABRIC Portal](https://portal.fabric-testbed.net/), log in and then click on "User Profile" in the menu bar at the top. Then, click "My SSH Keys" and "Manage SSH Keys".

![](images/fabric-manage-ssh-keys.png)

Scroll down to the "Generate SSH Key Pair" section. Set the "Name" to `fabric_bastion_key` and the "Key Type" to **bastion**, exactly as shown here. You can write anything you want in the "Description" field.

![](images/fabric-gen-bastion.png)

Then, click "Generate Key Pair".

A small pop-up will show the following message:

![](images/fabric-key-popup.png)

Click on the "Download" button next to "Private Key" and click on the "Download" button next to "Public Key" to download *both* parts of your new SSH key pair.

Find the two files, "fabric_bastion_key" and "fabric_bastion_key.pub" in your browser's regular download folder. You will need these keys - make sure to save them in a safe place!

Now, switch back to your Jupyter environment. In the sidebar on the left side of this environment is a file browser. You will see a directory named `fabric_config` there - double-click on it to navigate to this directory.

![](images/jup-fabconfig-dir.png)

You will see that the part of the interface that shows your current position in the filesystem (highlighted in blue in the image below) changes to reflect that you are inside the `fabric_config` directory. Then, click on the upload button (highlighted in green).

![](images/jup-upload-keys.png)

Upload the two files, "fabric_bastion_key" and "fabric_bastion_key.pub", to this directory in the Jupyter environment.

You're almost ready to finish configuring your Jupyter environment now! But first, you need to find two pieces of information from the FABRIC Portal.

**Your bastion username**: In the FABRIC Portal, click on "User Profile" and then "My SSH Keys". Find the "Bastion login" (shown highlighted in the image below) and make a note of it - you can click on the small icon right next to it to copy it, then paste it somewhere else.

![](images/fabric-bastion-username.png)

**Your project ID**: In the FABRIC Portal, click on "User Profile" and then "My Roles and Projects". Scroll down and find the "Project ID", then copy it.

![](images/fab-project-id.png)

Now you are ready! In the following cell, fill in your bastion username and project ID instead of the `...`:

``` python
%env FABRIC_BASTION_USERNAME ...
%env FABRIC_PROJECT_ID ...
```

We'll keep all of our FABRIC configuration files at the default locations, specified in the next cell:

``` python
!mkdir -p /home/fabric/work/fabric_config
%env FABRIC_BASTION_PRIVATE_KEY_LOCATION /home/fabric/work/fabric_config/fabric_bastion_key
%env FABRIC_BASTION_SSH_CONFIG_FILE /home/fabric/work/fabric_config/ssh_config
%env FABRIC_RC_FILE /home/fabric/work/fabric_config/fabric_rc
%env FABRIC_TOKEN_FILE /home/fabric/.tokens.json
%env FABRIC_SLICE_PRIVATE_KEY_FILE /home/fabric/work/fabric_config/slice_key
%env FABRIC_SLICE_PUBLIC_KEY_FILE /home/fabric/work/fabric_config/slice_key.pub
```

Now, we'll generate a new "slice key" pair. (This is used on the "hop" from the bastion, to our FABRIC resources.)

Note that this cell will appear to prompt you for a response (whether or not to overwrite the existing key pair), but a response will be sent automatically - you don't have to do anything.

``` python
!ssh-keygen -t rsa -b 3072 -f $FABRIC_SLICE_PRIVATE_KEY_FILE -q -N "" <<< y
```

and we'll make sure the file permissions are set correctly on both private keys:

``` python
%%bash
chmod 600 ${FABRIC_BASTION_PRIVATE_KEY_LOCATION}
chmod 600 ${FABRIC_SLICE_PRIVATE_KEY_FILE}
```

The following cell creates the `fabric_rc` configuration file using the values specified above. In the future, when we use FABRIC, we will load our configuration from this file.

``` python
%%bash
cat <<EOF > ${FABRIC_RC_FILE}
export FABRIC_CREDMGR_HOST=cm.fabric-testbed.net
export FABRIC_ORCHESTRATOR_HOST=orchestrator.fabric-testbed.net

export FABRIC_PROJECT_ID=${FABRIC_PROJECT_ID}
export FABRIC_TOKEN_LOCATION=${FABRIC_TOKEN_FILE}

export FABRIC_BASTION_HOST=bastion.fabric-testbed.net
export FABRIC_BASTION_USERNAME=${FABRIC_BASTION_USERNAME}

export FABRIC_BASTION_KEY_LOCATION=${FABRIC_BASTION_PRIVATE_KEY_LOCATION}
#export FABRIC_BASTION_KEY_PASSPHRASE=

export FABRIC_SLICE_PRIVATE_KEY_FILE=${FABRIC_SLICE_PRIVATE_KEY_FILE}
export FABRIC_SLICE_PUBLIC_KEY_FILE=${FABRIC_SLICE_PUBLIC_KEY_FILE} 
#export FABRIC_SLICE_PRIVATE_KEY_PASSPHRASE=

export FABRIC_LOG_FILE=${HOME}/fablib.log
export FABRIC_LOG_LEVEL=INFO 

export FABRIC_AVOID=''

export FABRIC_SSH_COMMAND_LINE="ssh -i {{ _self_.private_ssh_key_file }} -F ${HOME}/work/fabric_config/ssh_config {{ _self_.username }}@{{ _self_.management_ip }}"
EOF
```

Finally, we also create an SSH configuration file, which we'll use in the future to access our FABRIC resources using SSH.

``` python
%%bash
cat <<EOF > ${FABRIC_BASTION_SSH_CONFIG_FILE}
UserKnownHostsFile /dev/null
StrictHostKeyChecking no
ServerAliveInterval 120 

Host bastion.fabric-testbed.net
     User ${FABRIC_BASTION_USERNAME}
     ForwardAgent yes
     Hostname %h
     IdentityFile ${FABRIC_BASTION_PRIVATE_KEY_LOCATION}
     IdentitiesOnly yes

Host * !bastion.fabric-testbed.net
     ProxyJump ${FABRIC_BASTION_USERNAME}@bastion.fabric-testbed.net:22
EOF
```

### Exercise: reserve resources

In this exercise, we will reserve resources on FABRIC: two hosts on two different network segments, connected by a router.

Now that you have configured your Jupyter environment on FABRIC, you can load it from the configuration file at the beginning of each experiment! Check the output of the following cell, and make sure it reflects your configuration (e.g. correct bastion hostname, etc.).

``` python
from fabrictestbed_extensions.fablib.fablib import FablibManager as fablib_manager
fablib = fablib_manager() 
conf = fablib.show_config()
```

``` python
!chmod 600 {fablib.get_bastion_key_filename()}
!chmod 600 {fablib.get_default_slice_private_key_file()}
```

``` python
import os
slice_name="hello-fabric_" + os.getenv('NB_USER')
```

``` python
try:
    slice = fablib.get_slice(slice_name)
    print("You already have a slice by this name!")
    print("If you previously reserved resources, skip to the 'log in to resources' section.")
except:
    print("You don't have a slice named %s yet." % slice_name)
    print("Continue to the next step to make one.")
    slice = fablib.new_slice(name=slice_name)
```

Next, we'll select a random FABRIC site for our experiment. We'll make sure to get one that has sufficient capacity for the experiment we're going to run.

Once we find a suitable site, we'll print details about available resources at this site.

``` python
exp_requires = {'core': 3*2, 'nic': 4}
while True:
    site_name = fablib.get_random_site()
    if ( (fablib.resources.get_core_available(site_name) > 1.2*exp_requires['core']) and
        (fablib.resources.get_component_available(site_name, 'SharedNIC-ConnectX-6') > 1.2**exp_requires['nic']) ):
        break

fablib.show_site(site_name)
```

Next, we'll request the hosts and network links that we need at that site! For this experiment, we will need three virtual machines connected by two Ethernet links in a line topology, so we'll add that to our slice.

``` python
# this cell sets up the hosts and router
node_names = ["romeo", "router", "juliet"]
for n in node_names:
    slice.add_node(name=n, site=site_name, cores=2, ram=4, disk=10, image='default_ubuntu_20')
```

``` python
# this cell sets up the network links
nets = [
    {"name": "net0",   "nodes": ["romeo", "router"]},
    {"name": "net1",  "nodes": ["router", "juliet"]}
]
for n in nets:
    ifaces = [slice.get_node(node).add_component(model="NIC_Basic", name=n["name"]).get_interfaces()[0] for node in n['nodes'] ]
    slice.add_l2network(name=n["name"], type='L2Bridge', interfaces=ifaces)
```

The following cell submits our request to the FABRIC site. The output of this cell will update automatically as the status of our request changes.

-   While it is being prepared, the "State" of the slice will appear as "Configuring".
-   When it is ready, the "State" of the slice will change to "StableOK".

``` python
slice.submit()
```

Even after the slice is fully configured, it may not be immediately ready for us to log in. The following cell will return when the hosts in the slice are ready for us to use.

``` python
slice.wait_ssh(progress=True)
```

### Exercise: Configure resources

Next, we need to configure our resources - assign IP addresses to network interfaces, enable forwarding on the router, and install any necessary software.

First, we'll configure IP addresses:

``` python
from ipaddress import ip_address, IPv4Address, IPv4Network

if_conf = {
    "romeo-net0-p1":   {"addr": "10.0.0.2", "subnet": "10.0.0.0/24"},
    "router-net0-p1":  {"addr": "10.0.0.1", "subnet": "10.0.0.0/24"},
    "router-net1-p1":  {"addr": "10.0.1.1", "subnet": "10.0.1.0/24"},
    "juliet-net1-p1":  {"addr": "10.0.1.2", "subnet": "10.0.1.0/24"}
}

for iface in slice.get_interfaces():
    if_name = iface.get_name()
    iface.ip_addr_add(addr=if_conf[if_name]['addr'], subnet=IPv4Network(if_conf[if_name]['subnet']))
```

And, we'll enable IP forwarding on the router:

``` python
for n in ['router']:
    slice.get_node(name=n).execute("sudo sysctl -w net.ipv4.ip_forward=1")
```

Let's make sure that all of the network interfaces are brought up:

``` python
for iface in slice.get_interfaces():
    iface.ip_link_up()
```

Then, we'll add routes so that romeo knows how to reach juliet, and vice versa.

``` python
rt_conf = [
    {"name": "romeo",   "addr": "10.0.1.0/24", "gw": "10.0.0.1"},
    {"name": "juliet",  "addr": "10.0.0.0/24", "gw": "10.0.1.1"}
]
for rt in rt_conf:
    slice.get_node(name=rt['name']).ip_route_add(subnet=IPv4Network(rt['addr']), gateway=rt['gw'])
```

Finally, we'll install some software. For this experiment, we will need to install the `net-tools` package (which provides the `ifconfig` command).

``` python
for n in ['romeo', 'router', 'juliet']:
    slice.get_node(name=n).execute("sudo apt update; sudo apt -y install net-tools", quiet=True)
```

### Exercise: Log in to resources

Now, we are finally ready to log in to our resources over SSH! Run the following cells, and observe the table output - you will see an SSH command for each of the nodes in your topology.

``` python
import pandas as pd
pd.set_option('display.max_colwidth', None)
ssh_str = 'ssh -i ' + slice.get_slice_private_key_file() + \
    ' -J ' + fablib.get_bastion_username() + '@' + fablib.get_bastion_public_addr() + \
    ' -F /home/fabric/work/fabric_config/ssh_config '
slice_info = [{'Name': n.get_name(), 'SSH command': ssh_str + n.get_username() + '@' + str(n.get_management_ip())} for n in slice.get_nodes()]
pd.DataFrame(slice_info).set_index('Name')
```

Now, you can open an SSH session on any of the nodes as follows:

-   in Jupyter, from the menu bar, use File \> New \> Terminal to open a new terminal.
-   copy an SSH command from the table, and paste it into the terminal. (Note that each SSH command is a single line, even if the display wraps the text to a second line! When you copy and paste it, paste it all together.)

You can repeat this process (open several terminals) to start a session on each host and the router. Each terminal session will have a tab in the Jupyter environment, so that you can easily switch between them.

Try typing

    echo "Hello from:"
    hostname

in the terminal shell *on one of your FABRIC hosts*, and observe the output.

Note that you can also use the FABRIC library to directly execute commands on the FABRIC hosts, like this:

``` python
slice.get_node("romeo").execute("echo 'Hello from:'; hostname")
```

### Exercise: Transfer files from a FABRIC host

In future experiments, we'll often want to save the results of an experiment to a file on a FABRIC host, then transfer it to our own laptop for further inspection and analysis. In this exercise, we will learn how to do that!

As described above, open an SSH session to the "romeo" host in your topology. On this host, run the following command:

    ping -c 10 10.0.1.2 | tee ping.txt

This will:

-   send a sequence of "ICMP echo" messages to the "juliet" host, which will trigger a response from "juliet"
-   save the results - which includes the round trip delay from the time when the request is sent from "romeo", to the time that the response from "juliet" is received - to a file `ping.txt`. (The results will also be displayed in the terminal output.)

Now, in this notebook, run

``` python
slice.get_node("romeo").download_file("/home/fabric/work/ping.txt", "/home/ubuntu/ping.txt")
```

In the Jupyter environment, click on the folder icon in the file browser on the left to make sure that you are located in your "Jupyter home" directory.

![](images/jup-fab-home-dir.png)

Then, you should see the `ping.txt` file appear in the Jupyter file browser on the left. You can now download this file from the Jupyter environment to your own laptop.

### Exercise: Extend your slice

By default, your resources will be reserved for you for one day - then, they will be deleted automatically to free them for other users.

If you don't plan to finish an experiment in one day, you can extend your slice. The following cell extends your reservation for 3 days.

``` python
from datetime import datetime
from datetime import timezone
from datetime import timedelta

# Set end date to 3 days from now
end_date = (datetime.now(timezone.utc) + timedelta(days=3)).strftime("%Y-%m-%d %H:%M:%S %z")
slice.renew(end_date)
```

Confirm the new end time of your slice in the output of the following cell:

``` python
slice.update()
_ = slice.show()
```

You can extend your slice again anytime before these 3 days have elapsed, if you need more time.

### Exercise: Delete your slice resources

By default, your resources will be reserved for you for one day - then, they will be deleted automatically to free them for other users.

If you finish your experiment early, you can delete your slice! The following cell deletes all the resources in your slice, freeing them for other experimenters.

``` python
slice.delete()
```

``` python
# slice should end up in "Dead" state
# re-run this cell until you see it in "Dead" state
slice.update()
_ = slice.show()
```

<hr>

<small>Questions about this material? Contact Fraida Fund</small>

<hr>

<small>This material is based upon work supported by the National Science Foundation under Grant No. 2231984.</small>
<small>Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.</small>

