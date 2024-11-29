#!/bin/bash
. ~/.bash_profile
source ${commonConfigurationFile} 2>/dev/null

dbPassword=$(java -jar  ${pass_dypt} spring.datasource.password)

conn="mysql -h${dbIp} -P${dbPort} -u${dbUsername} -p${dbPassword} ${appdbName}"

`${conn} <<EOFMYSQL

CREATE TABLE issue (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_type VARCHAR(255),
    user_id VARCHAR(255),
    raised_by VARCHAR(255),
    resolved_by VARCHAR(255),
    ticket_id VARCHAR(36),
    mobile_number VARCHAR(255),
    email VARCHAR(255),
    category VARCHAR(255),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    redmine_issue_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    subject VARCHAR(255),
    status VARCHAR(255),
    feedback TEXT,
    rating VARCHAR(255),
    reference_id VARCHAR(255),
    is_private BOOLEAN,
    document_type VARCHAR(255),
    address TEXT,
    province VARCHAR(255),
    district VARCHAR(255),
    commune VARCHAR(255)
);

EOFMYSQL`



echo "tables creation completed."




echo "                                             *
                                                  ***
                                                 *****
                                                  ***
                                                   *                           "
echo "********************Thank You DB Process is completed now *****************"
