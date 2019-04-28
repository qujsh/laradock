#!/bin/sh
#description: install docker, create user

USERNAME="qujsh"                                                                                                            #you want to create who
PASSWORD=`echo ${USERNAME} | md5sum | cut -b 4-10 | tee ~/pass`                                                             #get the md5 value as random password

if [ $USER != "root" ]; then
	echo "please use root account"
	exit
fi

#INSTALL DOCKER USE PACKAGE
NAMES="docker_ce_cli containerd_io docker_ce docker_compose"                                                                #order is important, they are interdependence
DOCKER_CE='https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.09.5-3.el7.x86_64.rpm'            #if it's too slow, you can set your own file store server
DOCKER_CE_CLI='https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-18.09.5-3.el7.x86_64.rpm'
CONTAINERD_IO='https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.5-3.1.el7.x86_64.rpm'
DOCKER_COMPOSE='https://github.com/docker/compose/releases/download/1.24.0/docker-compose-Linux-x86_64'                     #centos 64bit system docker-compose
DOWNLOAD='/root/download'                                                                                                   #download place
DOCKER_PATH='/usr/bin/docker'
DOCKER_COMPOSE_PATH='/usr/local/bin/docker-compose'
REGISTRY_MIRROR='https://registry.docker-cn.com'                                                                            #you need replace your own Mirror accelerator

if [ ! -d $DOWNLOAD ]; then
	mkdir $DOWNLOAD
fi

for name in $NAMES
do
	if [ ! -f $DOWNLOAD/$name.rpm  ]; then
		NAME=$(echo $name | tr 'a-z' 'A-Z')
		eval tmp=$(echo \$$NAME)

		cd $DOWNLOAD && wget -O $name.rpm $tmp

		if [ $? != 0 ]; then
			echo "download $name package failed"
			break
		fi
	fi
done

# remove first, and do add
yum list installed | grep docker | awk '{print $1}' | xargs yum remove -y
yum list installed | grep containerd | awk '{print $1}' | xargs yum remove -y

# set yum aliyun repos
if [ ! -f /etc/yum.repos.d/CentOS-Base.repo.backup ];then
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	yum makecache

	if [ $? != 0 ]; then
		echo 'yum repo set faild'
		exit
	fi
fi


#if [ ! -f $DOCKER_PATH ]; then
	for name in $NAMES
	do
        	if [ $name == "docker_compose"  ]; then
			cp $DOWNLOAD/$name.rpm $DOCKER_COMPOSE_PATH
			chmod +x $DOCKER_COMPOSE_PATH
                	break
	        fi

        	yum install -y $DOWNLOAD/$name.rpm
	done

	if [ $? != 0 ]; then
	        echo 'docker install failed'
		exit
	fi

	systemctl enable docker
#fi

mkdir -p /etc/docker && \
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["REGISTRY_MIRROR"]
}
EOF

sed -i "s#REGISTRY_MIRROR#$REGISTRY_MIRROR#" /etc/docker/daemon.json
systemctl daemon-reload
systemctl restart docker

#create user
useradd $USERNAME && \
        echo $PASSEORD | passwd --stdin $USERNAME

if [ $? != 0 ]; then
        echo 'add user failed'
fi

gpasswd -a ${USERNAME} docker && \
	systemctl restart docker && \
	newgrp - docker