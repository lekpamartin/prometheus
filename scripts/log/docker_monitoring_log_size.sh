#!/bin/sh
#Version 0.1

PUSHGATEWAY_URL="http://LOGIN:PASSWORD@HOSTNAME:PORT/metrics/job/purge"

DOCKER_DIR="/var/docker"
SIZE="+500M"

PWD=`dirname $0`
TMP="$PWD/docker_monitoring_log_size.lock"

cd $DOCKER_DIR

CONTAINER=`find containers/*/*-json.log -type f -size $SIZE`

for i in $CONTAINER; do
	CONTAINER_ID=`echo $i | cut -d '/' -f2`
	CONTAINER_NAME=`docker inspect $CONTAINER_ID | grep -m 1 Name | cut -d '"' -f4 | cut -d '/' -f2`
	CONTAINER_SIZE=`ls -l $i | cut -d ' ' -f5`
	echo "docker_container_purge{instance=\"log\",container_name=\"${CONTAINER_NAME}\"} $CONTAINER_SIZE" >> $TMP

done

cat $TMP | curl --data-binary @- $PUSHGATEWAY_URL
rm -f $TMP
