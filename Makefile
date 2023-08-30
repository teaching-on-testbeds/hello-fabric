all: index.md hello_fabric.ipynb 

clean:
	rm index.md hello_fabric.ipynb 

index.md: prepare.md footer.md notebooks/*.md
	pandoc --resource-path=images/ --wrap=none \
		-i prepare.md notebooks/configure_jupyter.md \
		notebooks/reserve.md  \
		fabric-snippets/fab-config.md \
		notebooks/define-config.md \
		fabric-snippets/reserve-resources.md \
		fabric-snippets/configure-resources.md \
		fabric-snippets/draw-topo-detailed-labels.md \
		fabric-snippets/log-in.md \
		notebooks/transfer.md notebooks/extend.md \
		fabric-snippets/delete-slice.md \
		--metadata title="Hello, FABRIC" -o index.tmp.md
	grep -v '^:::' index.tmp.md > index.md
	rm index.tmp.md
	cat footer.md >> index.md


hello_fabric.ipynb: notebooks/*.md fabric-snippets/*.md
	pandoc --resource-path=../ --embed-resources --standalone --wrap=none \
		-i notebooks/title.md notebooks/configure_jupyter.md \
		notebooks/reserve.md  \
		fabric-snippets/fab-config.md \
		notebooks/define-config.md \
		fabric-snippets/reserve-resources.md \
		fabric-snippets/configure-resources.md \
		fabric-snippets/draw-topo-detailed-labels.md \
		fabric-snippets/log-in.md \
		notebooks/transfer.md notebooks/extend.md \
		fabric-snippets/delete-slice.md \
		-o hello_fabric.ipynb
		sed -i 's/attachment://g' hello_fabric.ipynb

