
::: {.cell .markdown}
### Exercise: Log in to resources

Now, we are finally ready to log in to our resources over SSH! Run the following cells, and observe the table output - you will see an SSH command for each of the nodes in your topology.

:::



::: {.cell .code}
```python
import pandas as pd
pd.set_option('display.max_colwidth', None)
ssh_str = 'ssh -i ' + slice.get_slice_private_key_file() + \
    ' -J ' + fablib.get_bastion_username() + '@' + fablib.get_bastion_public_addr() + \
    ' -F /home/fabric/work/fabric_config/ssh_config '
slice_info = [{'Name': n.get_name(), 'SSH command': ssh_str + n.get_username() + '@' + str(n.get_management_ip())} for n in slice.get_nodes()]
pd.DataFrame(slice_info).set_index('Name')
```
:::

::: {.cell .markdown}
Now, you can open an SSH session on any of the nodes as follows:

* in Jupyter, from the menu bar, use File > New > Terminal to open a new terminal.
* copy an SSH command from the table, and paste it into the terminal. (Note that each SSH command is a single line, even if the display wraps the text to a second line! When you copy and paste it, paste it all together.)

:::


::: {.cell .markdown}

You can repeat this process (open several terminals) to start a session on each host and the router. Each terminal session will have a tab in the Jupyter environment, so that you can easily switch between them.

:::


::: {.cell .markdown}

Try typing

```
echo "Hello from:"
hostname
```

in the terminal shell *on one of your FABRIC hosts*, and observe the output.

:::

::: {.cell .markdown}

Note that you can also use the FABRIC library to directly execute commands on the FABRIC hosts, like this:

:::


::: {.cell .code}
```python
slice.get_node("romeo").execute("echo 'Hello from:'; hostname")
```
:::