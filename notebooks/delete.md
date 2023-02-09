
::: {.cell .markdown}
### Exercise: Delete your slice resources

By default, your resources will be reserved for you for one day - then, they will be deleted automatically to free them for other users.

If you finish your experiment early, you can delete your slice! The following cell deletes all the resources in your slice, freeing them for other experimenters.

:::



<!-- 
::: {.cell .code}
```python
# read in FABRIC config - in case you pick this up later
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

::: {.cell .code}
```python
slice.delete()
```
:::


::: {.cell .code}
```python
slice.show()
```
:::