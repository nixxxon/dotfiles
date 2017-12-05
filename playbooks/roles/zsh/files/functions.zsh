drc() {
	echo "\nRemoving docker containers\n";
	for i in $(docker ps -aq); do docker rm -f $i; done
}

dri() {
	echo "\nRemoving docker images\n";
	for i in $(docker images -q); do docker rmi $i; done
}
