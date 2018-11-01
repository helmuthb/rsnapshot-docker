rsnapshot in Docker
===================

This Docker image allows you to run a (continuous) rsnapshot backup.
The logic is to perform a local backup from either a local folder or a remote server.

It allows the following customization:


Volumes
-------

Using the volume `/backup` you provide the target folder for the backups.
This is mandatory, otherwise backups are done into the ephemeral container disk space.

Using the volume `/data` you can provide the data which shall be backed up.
This is necessary for performing backups from a local folder and can be ignored for remote backups.

File Mounts
-----------

The Docker image also expects a few file mounts. They are optional.

Using the volume `/ssh-id` you can provide at runtime an SSH ID.
This is necessary for performing backups from a remote server and can be ignored for local backups.

Using the volume `/backup.cfg` you can add more backup steps.
The content is a list of `backup` statements (or other statements from the `rsnapshot` configuration file).


Environment
-----------

**BACKUP_NAME**
This is the name of the backup source you are backing up. Default is `localhost` and it will be used as the name of the subfolder in the `/backup` volume.

**BACKUP_SOURCE**
This is the name of the backup source you are backing up. Default is `/data` which matches the name of the expected volume for local backups; for remote server backups the syntax should be `user@server:/folder`.

**BACKUP_OPTS**
This allows you to add further `rsnapshot` options to the backup. The default value is `one_fs=1` which will make the backup not cross over filesystems.

**BACKUP_SSH_ARGS**
This allows you to provide additional values for `ssh_args`. One example could be providing a non-standard port with `-p 222`.

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

Example
-------

Perform local backup of `/etc`, into `/srv/backup`, naming it `etc-folder`:
```
docker run -d -v /etc:/data -v /srv/backup:/backup \
           -e BACKUP_NAME=etc-folder helmuthb/rsnapshot 
```

Perform remote backup of a remote server `example.com`, filesystem `/home` into `/src/backup`, naming it `remote`:
```
docker run -d -v $HOME/.ssh/id_rsa:/ssh-id \
           -v /srv/backup:/backup \
           -e BACKUP_NAME=remote \
           -e BACKUP_SOURCE=root@example.com \
           helmuthb/rsnapshot
```

Add a local configuration file `backup.cfg` with more backups:
```
backup		/etc	etc-folder/
backup		/boot	boot-folder/
backup		/home	home-folder/
```
```
docker run -d -v backup.cfg:/backup.cfg -v /srv/backup:/backup \
           -e BACKUP_NAME=root -e BACKUP_SOURCE=/ helmuthb/rsnapshot
```
