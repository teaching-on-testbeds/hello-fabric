

::: {.cell .markdown}
### Exercise: Transfer files from a FABRIC host

In future experiments, we'll often want to save the results of an experiment to a file on a FABRIC host, then transfer it to our own laptop for further inspection and analysis. In this exercise, we will learn how to do that!

:::


::: {.cell .markdown}

As described above, open an SSH session to the "romeo" host in your topology. On this host, run the following command:

```
ping -c 10 10.0.1.2 | tee ping.txt
```

This will:

* send a sequence of "ICMP echo" messages to the "juliet" host, which will trigger a response from "juliet"
* save the results - which includes the round trip delay from the time when the request is sent from "romeo", to the time that the response from "juliet" is received - to a file `ping.txt`. (The results will also be displayed in the terminal output.) 

:::

::: {.cell .markdown}

Now, in this notebook, run

:::

::: {.cell .code}
```python
slice.get_node("romeo").download_file("/home/fabric/work/ping.txt", "/home/ubuntu/ping.txt")
```
:::

::: {.cell .markdown}

You should see the `ping.txt` file appear in the Jupyter file browser on the left. You can now download this file from the Jupyter environment to your own laptop.

:::

