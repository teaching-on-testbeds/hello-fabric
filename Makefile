all: index.md hello_fabric.ipynb

clean:
	rm index.md hello_fabric.ipynb

index.md: prepare.md notebooks/*.md
	pandoc --resource-path=images/ --wrap=none \
		-i prepare.md notebooks/configure_jupyter.md \
		notebooks/reserve.md notebooks/configure.md notebooks/login.md \
		notebooks/transfer.md notebooks/extend.md notebooks/delete.md \
		notebooks/footer.md \
		--metadata title="Hello, FABRIC" -o index.tmp.md
	grep -v '^:::' index.tmp.md > index.md
	rm index.tmp.md

hello_fabric.ipynb: notebooks/*.md
	pandoc --resource-path=../ --embed-resources --standalone --wrap=none \
		-i notebooks/title.md notebooks/configure_jupyter.md \
		notebooks/reserve.md notebooks/configure.md notebooks/login.md \
		notebooks/transfer.md notebooks/extend.md notebooks/delete.md \
		-o hello_fabric.ipynb
		sed -i 's/attachment://g' hello_fabric.ipynb
