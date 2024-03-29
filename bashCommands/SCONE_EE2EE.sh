

$ export SCONE_MANAGER=faye

$ scone service pull sconecuratedimages/sconetainer:fss
...
fss: digest: sha256:2e76b4a0b090cc75c2e56594e20c7ec36bc1abd13e36e2f00d36e2f67b13c1d5 size: 1783
new tag: localhost:5000/sconetainer:fss

$ cat > compose.yml << EOF
version: "3.1.scone"
services:
    nginx:
        image: 127.0.0.1:5000/sconetainer:fss
        command: nginx -p /nginx -c nginx.conf
        mrenclave: 1516e3d41590cf3842282c6f037535af64336138a6b5eff7e8754e97b4c64ecb
        fspf_path: /nginx/fspf.pb
        fspf_key: 970f4925bb7b221461f3d1a3f17450aa42844539de24f5acc1b45b8c140f9467
        fspf_tag: 5930bffbd9ea2f1317e6872b032334db
        working_dir: /
        ports:
          - 8190:8080
          - 8192:8082
EOF

$ cat > ca.pem << EOF
-----BEGIN CERTIFICATE-----
MIICFzCCAb2gAwIBAgIJAOawWIYrvd1oMAoGCCqGSM49BAMCMGgxCzAJBgNVBAYT
AkRFMQ8wDQYDVQQIDAZTYXhvbnkxEDAOBgNVBAcMB0RyZXNkZW4xFDASBgNVBAoM
C3Njb250YWluIFVHMSAwHgYJKoZIhvcNAQkBFhFpbmZvQHNjb250YWluLmNvbTAe
Fw0xODA0MDYxMDIyMzdaFw0yODA0MDMxMDIyMzdaMGgxCzAJBgNVBAYTAkRFMQ8w
DQYDVQQIDAZTYXhvbnkxEDAOBgNVBAcMB0RyZXNkZW4xFDASBgNVBAoMC3Njb250
YWluIFVHMSAwHgYJKoZIhvcNAQkBFhFpbmZvQHNjb250YWluLmNvbTBZMBMGByqG
SM49AgEGCCqGSM49AwEHA0IABD9u85bK+nFdbnQVgZuR/rA9BmNmow3v4v5srS3M
YGpVmRqpNbb/QYQ9iJN854N42L9T6mGyI402tKPYyfwz3k+jUDBOMB0GA1UdDgQW
BBRhGJGv9MWohiZD3AySHz/otlxbyDAfBgNVHSMEGDAWgBRhGJGv9MWohiZD3AyS
Hz/otlxbyDAMBgNVHRMEBTADAQH/MAoGCCqGSM49BAMCA0gAMEUCIQCWkKHgeDgn
4PrHfmfjYYerxyFyGmWOKjO5UcijrPqI9wIgUyhZ2OwuyzsjTEC6ofR4fzlnrUQJ
XlkFOKY2/HqOPVE=
-----END CERTIFICATE-----
EOF

$ export IP=x.y.z.u
$ mkdir -p ~/.config
$ rm -f ~/.config/scone_cmd.conf
$ scone cas login -c ca.pem christof cas --host $IP:8081:18765

$ scone cas split compose.yml  --stack 283299

$ cat compose.yml.docker.yml
---
services: 
  nginx: 
    command: nginx
    environment: 
      SCONE_CAS_ADDR: "x.y.z.u:18765"
      SCONE_CONFIG_ID: christof/283299/nginx
      SCONE_LAS_ADDR: "172.17.0.1:18766"
    image: "127.0.0.1:5000/sconetainer:fss"
    ports: 
      - "8190:8080"
      - "8192:8082"
version: "3.1"

$ scone stack deploy --compose-file compose.yml  nginx
Creating network nginx_default
Creating service nginx_nginx

$ scone stack ls
NAME        SERVICES
nginx       1

$ scone stack ps nginx
ID                  NAME                IMAGE                            NODE                DESIRED STATE       CURRENT STATE             ERROR                       PORTS
h08r5hmeu9bt        nginx_nginx.1       127.0.0.1:5000/sconetainer:fss   dorothy             Running             Starting 19 seconds ago       

> sudo docker ps
CONTAINER ID        IMAGE                                    COMMAND                  CREATED             STATUS              PORTS                      NAMES
b01ab65e1579        127.0.0.1:5000/sconetainer:fss           "nginx"                  6 minutes ago       Up 6 minutes        8080/tcp, 8082/tcp         nginx_nginx.1.0wh80346mpmm5f3l1rc8dipix
...

> sudo docker exec -it b01ab65e1579 sh
$ ls
bin             media           proc            srv
dev             mnt             root            sys
etc             nginx           run             tmp
home            nginx-etc       sbin            usr
lib             opt             scone-test.key  var

$ cd nginx
$ ls
certificate.pem  key.pem          nginx.conf       www_root
fspf.pb          mime.types       nginx.pid
$ head -c 80 nginx.conf
]P?ɟ"4???zS????Ƶ?kjƘ?Ec?!S^!??????8j-?e;?t'?2?L????????y??˲?ߋ	

$ cd www_root
$ ls 
4K                               SCONE_TUTORIAL
GO                               aboutScone
Python                           appsecurity
...
$ head -c 80 index.html 
????V?ͪ?rhk?"k????$?	.???k?Ь?y<??٠n?+????P2?G;o_'.i?);?I??xFg[???[f?