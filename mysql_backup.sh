#!/bin/bash
###################################################################
# Written by: Oscar Escamilla                                     #
# Purpose: To make a backup from mysql database instance,         #
#          you need root privileges                               #
# Input: instance, database; Output: backup_file                  #
# Date: 04.08.2015                                                #
###################################################################

# Define variables
echo `date` "BACKUP BEGIN"
export TIMESTAMP=`date +%Y%m%d%H%M%S`
export BASE=#SET_BASE_PATH
export SHELL_BASE=#SET_SHELL_PATH
export BACKUP_BASE=#SET_BACKUP_PATH
export DATABASE=$1
export DB_BACKUP=$BACKUP_BASE/$DATABASE
export USER=#CHANGE_ME!
export PASSWORD=#CHANGE_ME!
export MYSQL=`which mysql`
export MYSQLDUMP=`which mysqldump`
export PART=_

# Logging variables
echo "TIMESTAMP=$TIMESTAMP"
echo "BASE=$BASE"
echo "SHELL_BASE=$SHELL_BASE"
echo "BACKUP_BASE=$BACKUP_BASE"
echo "DB_BACKUP=$DB_BACKUP"
echo "USER=$USER"
#echo "PASSWORD=$PASSWORD"
echo "MYSQL=$MYSQL"
echo "MYSQLDUMP=$MYSQLDUMP"

##################
function if_error
##################
{
if [[ $? -ne 0 ]]; then # check return code passed to function
    print "$1" # if rc > 0 then print error msg and quit
    cd $SHELL_BASE
    echo "Deleting $DB_BACKUP..."
    rm -rf $DB_BACKUP
    echo `date` "BACKUP END"
exit $?
fi
}

##################
function backup
##################
{
    cd $DB_BACKUP
    echo "Moving to $DB_BACKUP..."
    export FILENAME=$DATABASE$PART$TIMESTAMP.sql
    echo `date` "BACKUP STARTING $DATABASE on $FILENAME"
    # execute backup
    $MYSQLDUMP -u $USER --password=$PASSWORD --databases $DATABASE > $FILENAME
    if_error # validate if error
    j=`ps -ef | grep -i mysqldump | grep -v grep | wc -l`
    while [ "$j" -ne "0" ]
    do
        sleep 5
        j=`ps -ef | grep -i mysqldump | grep -v grep| wc -l`
    done
    /bin/gzip $FILENAME # compress file

}

if [ $# -eq 0 ]; then # validate parameters
    echo "ERROR: Insufficient parameters"
else
    echo "USAGE: mysql_backup.sh database_name | $1"

    if [ -d $DB_BACKUP ]; then
        echo "The $DB_BACKUP directory exists"
    else
        echo "The $DB_BACKUP directory doesn't exist"
        mkdir -p $DB_BACKUP
        echo "$DB_BACKUP directory has been created"
    fi

    backup # call backup function
fi

echo `date` "BACKUP END"
