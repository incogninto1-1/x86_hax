all:
	mkdir obj out
	nasm -f elf32 src/entry.S -o obj/entry.o
	ld -m elf_i386 -T linker.ld obj/entry.o -o out/ghost.elf

clean:
	rm -rf obj out

send:
	git add .
	git commit -m "message sent automatically"
	git push
