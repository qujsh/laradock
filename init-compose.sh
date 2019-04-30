#!/bin/sh
#description: create init compose.sh


if [ $USER != "root" ]; then
	echo "please use root account"
	exit
fi

tee /etc/init.d/compose <<-'EOF'
#!/bin/sh
#chkconfig: 2345 80 90
#description: docker-compose init start

ENV=/www/laradock/.env
ENV_TMP=/tmp/.env
PATH_YML=/www/laradock/docker-compose.yml

for var in `cat $ENV | grep -v ^#`;do
    export $var >> $ENV_TMP
done

source $ENV_TMP && \
/usr/local/bin/docker-compose -f $PATH_YML up -d nginx mysql redis workspace laravel-echo-server

EOF

chmod +x /etc/init.d/compose
chkconfig compose on