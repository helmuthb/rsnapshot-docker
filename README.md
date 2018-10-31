rsnapshot in Docker
===================

This Docker image allows you to run a (continuous) rsnapshot backup.
The logic is to perform a local backup from either a local folder or a remote server.

It allows the following customization:

Volumes
-------

Using the volume `/backup` you provide the target folder for the backups.
This is mandatory, otherwise backups are done into the ephemeral container disk space.

Using the volume `/ssh-id` you can provide at runtime an SSH ID.
This is necessary for performing backups from a remote server and can be ignored for local backups.

Using the volume `/data` you can provide the data which shall be backed up.
This is necessary for performing backups from a local folder and can be ignored for remote backups.

Environment
-----------

**BACKUP_NAME**
This is the name of the backup source you are backing up. Default is `localhost` and it will be used as the name of the subfolder in the `/backup` volume.

**BACKUP_SOURCE**
This is the name of the backup source you are backing up. Default is `/data` which matches the name of the expected volume for local backups; for remote server backups the syntax should be `user@server:/folder`.

**BACKUP_OPTS**
This allows you to add further `rsnapshot` options to the backup. The default value is `one_fs=1` which will make the backup not cross over filesystems.

**BACKUP_HOURLY**
This specifies the number of hourly backups to keep. The default value is `0` which means no hourly backups are performed.

**BACKUP_DAILY**
This specifies the number of daily backups to keep. The default value is `3`.

**BACKUP_WEEKLY**
This specifies the number of weekly backups to keep. The default value is `3`.

**BACKUP_MONTHLY**
This specifies the number of monthly backups to keep. The default value is `3`.

**BACKUP_YEARLY**
This specifies the number of yearly backups to keep. The default value is `3`.
