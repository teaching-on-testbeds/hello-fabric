all: index.md hello_fabric.ipynb

clean:
	rm index.md hello_fabric.ipynb

index.md: prepare.md notebooks/*.md
	pandoc --resource-path=images/ --wrap=none \
		-i prepare.md notebooks/configure_jupyter.md \
		notebooks/reserve.md notebooks/configure.md notebooks/login.md \
		--metadata title="Hello, FABRIC" -o index.tmp.md
	grep -v '^:::' index.tmp.md > index.md
	rm index.tmp.md

hello_fabric.ipynb: notebooks/*.md
	pandoc --resource-path=../ --wrap=none \
		-i notebooks/title.md notebooks/configure_jupyter.md \
		notebooks/reserve.md notebooks/configure.md notebooks/login.md \
		-o hello_fabric.ipynb

