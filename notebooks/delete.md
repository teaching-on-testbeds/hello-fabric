
::: {.cell .markdown}
### Exercise: Delete your slice resources

By default, your resources will be reserved for you for one day - then, they will be deleted automatically to free them for other users.

If you finish your experiment early, you can delete your slice! The following cell deletes all the resources in your slice, freeing them for other experimenters.

:::


::: {.cell .code}
```python
slice.delete()
```
:::


::: {.cell .code}
```python
# slice should end up in "Dead" state
# re-run this cell until you see it in "Dead" state
slice.update()
_ = slice.show()
```
:::