#!/bin/bash
# using set -e to stop the script if any error occcur:
set -e

############# CONFIGURATION #############

# Import configuration file:
source config.txt

# Store current date on a variable:
CURRENT_DATE=$(date +%Y%m%d_%H%M%S)

############# BACKUP DIRECTORY CONFIG #############

# Store the backup folder directory:
MARIADBDUMP_DIR="$BACKUP_DIR/$CURRENT_DATE/MariaDB_Dump/"
CONFFILES_DIR="$BACKUP_DIR/$CURRENT_DATE/Conf_Files/"

############# SQL DATABASE CONFIG #############

SQL_FILENAME="dbdump_$CURRENT_DATE"

############# STARTING SCRIPT #############

echo "############# RUNNING BFRO BACKUP PROCEDURE #############"

# Test if the bfro server is running:
if pgrep -x "map-server" > /dev/null; then
    echo "Error: The server is currently running! Stop the server before proceeding with the backup!"
    exit 1
fi

echo "The server is not running. Starting backup process..."
sleep 0.5

# Entering backup directory:
cd "$BACKUP_DIR"
echo "Found backup directory!"
sleep 0.5

# Creating folder with current date and time:
mkdir "$CURRENT_DATE"

# Creating the backup folders:
echo "Creating backup folders!"
mkdir "$MARIADBDUMP_DIR" "$CONFFILES_DIR"
sleep 0.5

# Running the MariaDB dump:
echo "Running the SQL dump into a file!"
# mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$MARIADBDUMP_DIR/$SQL_FILENAME"
sleep 0.5

# Copying the conf/import folder to the destination
echo "Copying the conf/import folder!"
cp -r "$CONF_IMPORT_SRC" "$CONFFILES_DIR"
sleep 0.5

# Compacting the backup:
echo "Compacting the current date backup:"
cd "$BACKUP_DIR"
tar -czvf "$CURRENT_DATE.tar.gz" "$CURRENT_DATE"
sleep 0.5

# Cleaning files:
echo "Cleaning the temp files!"
rm -r $CURRENT_DATE

echo "############# FINISHED BFRO BACKUP PROCEDURE #############"
