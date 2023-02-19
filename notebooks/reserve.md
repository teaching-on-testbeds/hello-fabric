
::: {.cell .markdown}
### Exercise: reserve resources

In this exercise, we will reserve resources on FABRIC: two hosts on two different network segments, connected by a router.

:::

::: {.cell .markdown}


Now that you have configured your Jupyter environment on FABRIC, you can load it from the configuration file at the beginning of each experiment! Check the output of the following cell, and make sure it reflects your configuration (e.g. correct bastion hostname, etc.).
:::


::: {.cell .code}
```python
from fabrictestbed_extensions.fablib.fablib import FablibManager as fablib_manager
fablib = fablib_manager() 
conf = fablib.show_config()
```
:::


::: {.cell .code}
```python
!chmod 600 {fablib.get_bastion_key_filename()}
!chmod 600 {fablib.get_default_slice_private_key_file()}
```
:::


::: {.cell .code}
```python
import os
slice_name="hello-fabric_" + os.getenv('NB_USER')
```
:::



::: {.cell .code}
```python
try:
    slice = fablib.get_slice(slice_name)
    print("You already have a slice by this name!")
    print("If you previously reserved resources, skip to the 'log in to resources' section.")
except:
    print("You don't have a slice named %s yet." % slice_name)
    print("Continue to the next step to make one.")
    slice = fablib.new_slice(name=slice_name)
```
:::



::: {.cell .markdown}
Next, we'll select a random FABRIC site for our experiment. We'll make sure to get one that has sufficient capacity for the experiment we're going to run.

Once we find a suitable site, we'll print details about available resources at this site.
:::



::: {.cell .code}
```python
exp_requires = {'core': 3*2, 'nic': 4}
while True:
    site_name = fablib.get_random_site()
    if ( (fablib.resources.get_core_available(site_name) > 1.2*exp_requires['core']) and
        (fablib.resources.get_component_available(site_name, 'SharedNIC-ConnectX-6') > 1.2**exp_requires['nic']) ):
        break

fablib.show_site(site_name)
```
:::


::: {.cell .markdown}
Next, we'll request the hosts and network links that we need at that site! For this experiment, we will need three virtual machines connected by two Ethernet links in a line topology, so we'll add that to our slice.
:::




::: {.cell .code}
```python
# this cell sets up the hosts and router
node_names = ["romeo", "router", "juliet"]
for n in node_names:
    slice.add_node(name=n, site=site_name, cores=2, ram=4, disk=10, image='default_ubuntu_20')
```
:::



::: {.cell .code}
```python
# this cell sets up the network links
nets = [
    {"name": "net0",   "nodes": ["romeo", "router"]},
    {"name": "net1",  "nodes": ["router", "juliet"]}
]
for n in nets:
    ifaces = [slice.get_node(node).add_component(model="NIC_Basic", name=n["name"]).get_interfaces()[0] for node in n['nodes'] ]
    slice.add_l2network(name=n["name"], type='L2Bridge', interfaces=ifaces)
```
:::



::: {.cell .markdown}
The following cell submits our request to the FABRIC site. The output of this cell will update automatically as the status of our request changes. 

* While it is being prepared, the "State" of the slice will appear as "Configuring". 
* When it is ready, the "State" of the slice will change to "StableOK".
:::



::: {.cell .code}
```python
slice.submit()
```
:::



::: {.cell .markdown}
Even after the slice is fully configured, it may not be immediately ready for us to log in. The following cell will return when the hosts in the slice are ready for us to use.
:::


::: {.cell .code}
```python
slice.wait_ssh(progress=True)
```
:::

