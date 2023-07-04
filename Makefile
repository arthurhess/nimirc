build/nimirc: main.nim
	nim compile -o:build/nimirc main.nim

install: build/nimirc
	cp build/nimirc /usr/local/bin/nimirc
