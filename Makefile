build/nimirc: main.nim lib/**/*.nim
	nim compile -o:build/nimirc main.nim

install: build/nimirc
	cp build/nimirc /usr/local/bin/nimirc
