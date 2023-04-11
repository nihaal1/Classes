all: bsdump bytedump fat12ls

bsdump: bsdump-template.c
	gcc -o bsdump bsdump-template.c

bytedump: bytedump.c
	gcc -o bytedump bytedump.c

fat12ls: fat12ls-template.c
	gcc -o fat12ls fat12ls-template.c

clean:
	rm bsdump bytedump fat12ls