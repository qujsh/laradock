# laradock

## 安装
1. yum install -y git   需要有git
2. git clone https://github.com/qujsh/laradock.git  做clone处理
3. cp .env.example .env  然后里面该调整调整
4. cp install-compose.sh{.bak,} init-compose.sh{.bak,} 
5. sh ./install-compose.sh    执行 docker程序安装，由于docker源可能会非常慢，所以，如果慢了，建议调整这儿的DOCKER_CE，DOCKER_CE_CLI，CONTAINERD_IO，REGISTRY_MIRROR 参数
6. sh ./init-compose.sh       做docker-compose 的开机自启动处理，之后最好先打开调整下，否则可能会有docker pull动作，非常的慢

## shell 介绍
install-compose.sh 做自动安装docker程序动作
init-compose.sh 做自动添加 docker-compose 为开机启动项

## 文件注意
.env, init-compose.sh 需要注意文件的存储路径，可以记得调整下

## docker images 介绍
docker源 主要是原laradock镜像 各个程序做安装成功后的 镜像提交


