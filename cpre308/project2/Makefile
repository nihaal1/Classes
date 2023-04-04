everything: appserver Project2Test
	gcc -o everything appserver Project2Test

appserver: server.c
	gcc -o appserver server.c -lpthread 

Project2Test: Project2Test_v2.c
	gcc -o Project2Test Project2Test_v2.c -lpthread 

clean:
	rm everything appserver Project2Test
