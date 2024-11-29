#!/bin/bash
#set -x

#take back up of existing release
tar -xzvf support_module_1.0.0.tar.gz >>api_redmine_1.0.0_untar_log.txt
mkdir -p ${APP_HOME}/api_service/api_redmine
mkdir -p ${LOG_HOME}/api_service/api_redmine


mv support_module_1.0.0/api_redmine_1.0.0.jar ${RELEASE_HOME}/binary/
mv support_module_1.0.0/*  ${APP_HOME}/api_service/api_redmine/

cd ${APP_HOME}/api_service/api_redmine
ln -sf ${RELEASE_HOME}/binary/api_redmine_1.0.0.jar api_redmine.jar
ln -sf ${RELEASE_HOME}/global_config/log4j2.xml log4j2.xml

chmod +x *.sh


echo "++++++++++++Application Installation completed+++++++++++"
