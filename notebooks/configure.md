
::: {.cell .markdown}
### Exercise: Configure resources

Next, we need to configure our resources - assign IP addresses to network interfaces, enable forwarding on the router, and install any necessary software.

:::


<!--
::: {.cell .code}
```python
# read in FABRIC config - in case you pause and pick this up later
from fabrictestbed_extensions.fablib.fablib import FablibManager as fablib_manager
fablib = fablib_manager() 
!chmod 600 /home/fabric/work/fabric_config/fabric_bastion_key
!chmod 600 /home/fabric/work/fabric_config/slice_key

import os
slice_name="hello-fabric_" + os.getenv('NB_USER')

# update information about the slice
slice = fablib.get_slice(name=slice_name)
```
:::
-->

::: {.cell .markdown}
First, we'll configure IP addresses:
:::


::: {.cell .code}
```python
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
:::


::: {.cell .markdown}
Then, we'll add routes so that romeo knows how to reach juliet, and vice versa.
:::


::: {.cell .code}
```python
rt_conf = [
    {"name": "romeo",   "addr": "10.0.1.0/24", "gw": "10.0.0.1"},
    {"name": "juliet",  "addr": "10.0.0.0/24", "gw": "10.0.1.1"}
]
for rt in rt_conf:
    slice.get_node(name=rt['name']).ip_route_add(subnet=IPv4Network(rt['addr']), gateway=rt['gw'])
```
:::


::: {.cell .markdown}
And, we'll enable IP forwarding on the router:
:::


::: {.cell .code}
```python
for n in ['router']:
    slice.get_node(name=n).execute("sudo sysctl -w net.ipv4.ip_forward=1")
```
:::


::: {.cell .markdown}
Let's make sure that all of the network interfaces are brought up:
:::


::: {.cell .code}
```python
for iface in slice.get_interfaces():
    iface.ip_link_up()
```
:::


::: {.cell .markdown}
Finally, we'll install some software. For this experiment, we will need to install the `net-tools` package (which provides the `ifconfig` command).
:::


::: {.cell .code}
```python
for n in ['romeo', 'router', 'juliet']:
    slice.get_node(name=n).execute("sudo apt update; sudo apt -y install net-tools", quite=True)
```
:::
