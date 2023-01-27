all: index.html hello_fabric.ipynb

clean:
	rm index.html hello_fabric.ipynb

index.html: index.md notebooks/*.md
	pandoc --self-contained  --resource-path=images/  \
		-i index.md notebooks/configure_jupyter.md \
		notebooks/reserve.md notebooks/configure.md notebooks/login.md \
		--metadata title="Hello, FABRIC" -o index.html


hello_fabric.ipynb: notebooks/*.md
	pandoc --resource-path=images/ --self-contained --wrap=none \
		-i notebooks/title.md notebooks/configure_jupyter.md \
		notebooks/reserve.md notebooks/configure.md notebooks/login.md \
		-o hello_fabric.ipynb

