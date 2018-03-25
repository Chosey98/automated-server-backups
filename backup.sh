#!/bin/bash
###################################
#
# Automated server backups
#
###################################

# what to backup
# backup folders
backup_files="/var/www/my-website.de /var/www/wordpress /etc"

# backup databases
backup_databases="mywebsite wordpress"

# where to backup
dest="/mnt/backup"

# create backup folder if not exist
mkdir -p $dest

# create archive filenames
day=$(date +%y-%m-%d)
hostname=$(hostname -s)
archive_file="$hostname-$day.tar"
mysql_file="$hostname-mysql-$day.tar"

# print start status message
echo "Backing up $backup_files to $dest/$archive_file ..."
echo "Backing up $backup_databases to $dest/$mysql_file ..."
date
echo
echo "================================================================"
echo
echo "Download database backup with $ scp backup@185.102.93.107:backups/$mysql_file ."
echo
echo "Unpack files with $ tar -xvzf $mysql_file"
echo
echo "Download the full backup with with $ scp backup@185.102.93.107:backups/$archive_file ."
echo
echo "Unpack files with $ tar -xvzf $archive_file"
echo 
echo "================================================================="
echo ""

# backup the files using tar.
tar czvfP $dest/$archive_file $backup_files

# database backup 
mysqldump --user root --routines --triggers --single-transaction --databases $backup_databases > "$dest/sql_dump.sql"
tar czfP $dest/$mysql_file "$dest/sql_dump.sql" && rm $dest/sql_dump.sql

# print end status message
echo
echo "Backup SUCCESS"
date

# long listing of files in $dest to check file sizes
ls -lh $dest