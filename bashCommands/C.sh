 docker pull sconecuratedimages/crosscompilers docker run --device=/dev/isgx -it sconecuratedimages/crosscompilers $ scone gcc --help Usage: x86_64-linux-musl-gcc [options] file... Options: ... cat > fib.c << EOF #include <stdio.h> #include <stdlib.h>  int main(int argc, char** argv) {    int n=0, first = 0, second = 1, next = 0, c;     if (argc > 1)         n=atoi(argv[1]);    printf("fib(%d)= 1",n);    for ( c = 1 ; c < n ; c++ ) {         next = first + second;         first = second;         second = next;         printf(", %d",next);    }    printf("\n"); } EOF scone gcc fib.c -o fib SCONE_VERSION=1 ./fib 23