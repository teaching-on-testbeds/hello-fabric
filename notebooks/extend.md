
::: {.cell .markdown}
### Exercise: Extend your slice

By default, your resources will be reserved for you for one day - then, they will be deleted automatically to free them for other users.

If you don't plan to finish an experiment in one day, you can extend your slice. The following cell extends your reservation for 3 days.
:::

::: {.cell .code}
```python
from datetime import datetime
from datetime import timezone
from datetime import timedelta

# Set end date to 3 days from now
end_date = (datetime.now(timezone.utc) + timedelta(days=3)).strftime("%Y-%m-%d %H:%M:%S %z")
slice.renew(end_date)
```
:::



::: {.cell .markdown}
Confirm the new end time of your slice in the output of the following cell:
:::


::: {.cell .code}
```python
slice.update()
_ = slice.show()
```
:::


::: {.cell .markdown}
You can extend your slice again anytime before these 3 days have elapsed, if you need more time.
:::
