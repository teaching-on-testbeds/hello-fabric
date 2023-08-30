
::: {.cell .markdown}
## Reserve resources

In this exercise, we will reserve and use resources on FABRIC: two hosts on two different network segments, connected by a router. (Both the hosts and the router will be realized as Linux virtual machines.)

This involves several steps - 

* **Configure environment**: Now that you have configured your Jupyter environment on FABRIC, you can load it from the configuration file at the beginning of each experiment! Check the output of the following cell, and make sure it reflects your configuration (e.g. correct bastion hostname, etc.).
* **Define configuration for this experiment**: Next, you will define the configuration of the experiment, with all of the properties of the virtual machines, network interfaces, and networks that you will request from the FABRIC infrastructure. 
* **Reserve resources**: At this stage, you are ready to reserve resources! You will construct a "slice" following the configuration you defined, and then submit it to FABRIC to build out on the physical infrastructure.
* **Configure resources**: Also following the configuration you defined, you will configure network interfaces on the resources, install software, or do other configuration tasks that are necessary for your experiment.
* **Draw the network topology**: We can visualize the network topology, including the names, MAC addresses, and IP addresses of each network interface, directly in this notebook.
* **Log in to resources**: Finally, you will get the SSH login details for each of the nodes in your topology.


:::