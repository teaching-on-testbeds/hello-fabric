::: {.cell .markdown}
### Configure your Jupyter environment

You should now be inside the Jupyter environment in FABRIC. Before you use this environment for the first time, you'll want to create some configuration files that tell it who you are, what project you belong to, and what key it should use to access your resource on FABRIC.

:::


::: {.cell .markdown}

First, we will need to generate some keys! On FABRIC, we access the resources (hosts, switches, routers) in our experiment by connecting to a server known as a "bastion" over an SSH connection, and then connecting from the "bastion" to the device that we want to use. Both "hops" will be over SSH, a secure protocol for remote login, and both hops will use an SSH *key* for authentication. Using SSH key authentication to connect to a remote system is a more secure alternative to logging in with an account password.

:::


::: {.cell .markdown}


SSH key authentication uses a pair of separate keys (i.e., a key pair): one "private" key, which you keep a secret, and the other "public". A key pair has a special property: any message that is encrypted with your private key can only be decrypted with your public key, and any message that is encrypted with your public key can only be decrypted with your private key.

This property can be exploited for authenticating login to a remote machine. First, the public key is uploaded to a specific location on the remote machine. Then, when you want to log in to the machine:

1. You use a special argument with your SSH command to let your SSH application know that you are going to use a key, and the location of your private key. If the private key is protected by a passphrase, you may be prompted to enter the passphrase (this is not a password for the remote machine, though).
2. The machine you are logging in to will ask your SSH client to "prove" that it owns the (secret) private key that matches an authorized public key. To do this, the machine will send a random message to you.
3. Your SSH client will encrypt the random message with the private key and send it back to the remote machine.
4. The remote machine will decrypt the message with your public key. If the decrypted message matches the message it sent you, it has "proof" that you are in possession of the private key for that key pair, and will grant you access (without using an account password on the remote machine.)

(Of course, this relies on you keeping your private key a secret.)

:::


::: {.cell .markdown}

To access resources in our FABRIC experiments, we will use a "bastion key" to authenticate on the "hop" to the "bastion", and then a "slice key" to authenticate on the hop from the "bastion" to the FABRIC resource. In this exercise, we'll prepare both of those keys, then tell the FABRIC Jupyter environment where to find them and how to use them.
:::



::: {.cell .markdown}

First, we will use the FABRIC Portal to generate the bastion key. In the [FABRIC Portal](https://portal.fabric-testbed.net/), log in and then click on "User Profile" in the menu bar at the top. Then, click "My SSH Keys" and "Manage SSH Keys".

![](images/fabric-manage-ssh-keys.png)

:::


::: {.cell .markdown}

Click on the "Bastion" tab, then scroll down to the "Generate Bastion Key Pair" section. Set the "Name" to `fabric_bastion_key`, exactly as shown here. You can write anything you want in the "Description" field.

![](images/fabric-gen-bastion.png)

Then, click "Generate".

:::

::: {.cell .markdown}

A small pop-up will show the following message:

![](images/fabric-key-popup.png)

Click on the "Download" button next to "Private Key" and click on the "Download" button next to "Public Key" to download *both* parts of your new SSH key pair.

Find the two files, "fabric_bastion_key" and "fabric_bastion_key.pub" in your browser's regular download folder. You will need these keys - make sure to save them in a safe place!

:::


::: {.cell .markdown}
Now, switch back to your Jupyter environment. In the sidebar on the left side of this environment is a file browser. You will see a directory named `fabric_config` there - double-click on it to navigate to this directory.

![](images/jup-fabconfig-dir.png)
:::


::: {.cell .markdown}
You will see that the part of the interface that shows your current position in the filesystem (highlighted in blue in the image below) changes to reflect that you are inside the `fabric_config` directory. Then, click on the upload button (highlighted in green).

![](images/jup-upload-keys.png)

Upload the two files, "fabric_bastion_key" and "fabric_bastion_key.pub", to this directory in the Jupyter environment.

:::


::: {.cell .markdown}

You're almost ready to finish configuring your Jupyter environment now! But first, you need to find two pieces of information from the FABRIC Portal.

**Your bastion username**: In the FABRIC Portal, click on "User Profile"  and then "My SSH Keys". Find the "Bastion login" (shown highlighted in the image below) and make a note of it - you can click on the small icon right next to it to copy it, then paste it somewhere else.

![](images/fabric-bastion-username.png)

**Your project ID**: In the FABRIC Portal, click on "User Profile" and then "My Roles and Projects". Select your project, then scroll down and find the "Project ID", then copy it. 

![](images/fab-project-id.png)

:::


::: {.cell .markdown}
Now you are ready! In the following cell, fill in your bastion username and project ID instead of the `...`:
:::



::: {.cell .code}
```python
%env FABRIC_BASTION_USERNAME ...
%env FABRIC_PROJECT_ID ...
```
:::


::: {.cell .markdown}
We'll keep all of our FABRIC configuration files at the default locations, specified in the next cell:
:::

::: {.cell .code}
```python
!mkdir -p /home/fabric/work/fabric_config
%env FABRIC_BASTION_PRIVATE_KEY_LOCATION /home/fabric/work/fabric_config/fabric_bastion_key
%env FABRIC_BASTION_SSH_CONFIG_FILE /home/fabric/work/fabric_config/ssh_config
%env FABRIC_RC_FILE /home/fabric/work/fabric_config/fabric_rc
%env FABRIC_TOKEN_FILE /home/fabric/.tokens.json
%env FABRIC_SLICE_PRIVATE_KEY_FILE /home/fabric/work/fabric_config/slice_key
%env FABRIC_SLICE_PUBLIC_KEY_FILE /home/fabric/work/fabric_config/slice_key.pub
```
:::


::: {.cell .markdown}
Now, we'll generate a new "slice key" pair. (This is used on the "hop" from the bastion, to our FABRIC resources.)

Note that this cell will appear to prompt you for a response (whether or not to overwrite the existing key pair), but a response will be sent automatically - you don't have to do anything.
:::



::: {.cell .code}
```python
!ssh-keygen -t rsa -b 3072 -f $FABRIC_SLICE_PRIVATE_KEY_FILE -q -N "" <<< y
```
:::


::: {.cell .markdown}
and we'll make sure the file permissions are set correctly on both private keys:
:::


::: {.cell .code}
```python
%%bash
chmod 600 ${FABRIC_BASTION_PRIVATE_KEY_LOCATION}
chmod 600 ${FABRIC_SLICE_PRIVATE_KEY_FILE}
```
:::


::: {.cell .markdown}
The following cell creates the `fabric_rc` configuration file using the values specified above.  In the future, when we use FABRIC, we will load our configuration from this file.
:::


::: {.cell .code}
```python
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
:::


::: {.cell .markdown}
Finally, we also create an SSH configuration file, which we'll use in the future to access our FABRIC resources using SSH.
:::


::: {.cell .code}
```python
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
:::



