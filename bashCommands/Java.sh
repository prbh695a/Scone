
docker pull sconecuratedimages/apps:8-jdk-alpine
docker run --privileged --device=/dev/isgx -it sconecuratedimages/apps:8-jdk-alpine
cat > HelloWorld.java << EOF
public class HelloWorld {

    public static void main(String[] args) {
        System.out.println("Hello World");
    }

}
EOF
javac HelloWorld.java
java HelloWorld
SCONE_VERSION=1 SCONE_LOG=7 java HelloWorld
SCONE_LOG=7 SCONE_HEAP=12G java HelloWorld