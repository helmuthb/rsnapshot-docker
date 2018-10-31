#! /bin/sh

# Entry point for rsnapshot backup
# This will create the config file (using environment variables),
# a crontab, and start cron

# First part of rsnapshot config
cat > /etc/rsnapshot.conf <<EOF
config_version 1.2
snapshot_root /backups/
no_create_root 1
cmd_cp /bin/cp
cmd_rm /bin/rm
cmd_rsync /usr/bin/rsync
cmd_ssh /usr/bin/ssh
ssh_args -i /ssh-id -o StrictHostKeychecking=no ${BACKUP_SSH_ARGS}
verbose 1
lockfile /var/run/rsnapshot.pid
backup ${BACKUP_SOURCE} ${BACKUP_NAME}/ ${BACKUP_OPTS}
EOF

# prepare crontab for root
touch /etc/crontabs/root

# Dynamic parts - depending on the retain settings
# This will also create the crontab
if [ "${BACKUP_HOURLY}" -gt 0 ]
then
  echo "retain hourly ${BACKUP_HOURLY}">> /etc/rsnapshot.conf
  echo "0 * * * * rsnapshot hourly" >> /etc/crontabs/root
fi
if [ "${BACKUP_DAILY}" -gt 0 ]
then
  echo "retain daily ${BACKUP_HOURLY}">> /etc/rsnapshot.conf
  echo "50 0 * * * rsnapshot daily" >> /etc/crontabs/root
fi
if [ "${BACKUP_WEEKLY}" -gt 0 ]
then
  echo "retain weekly ${BACKUP_WEEKLY}">> /etc/rsnapshot.conf
  echo "50 11 * * 0 rsnapshot weekly" >> /etc/crontabs/root
fi
if [ "${BACKUP_MONTHLY}" -gt 0 ]
then
  echo "retain monthly ${BACKUP_MONTHLY}">> /etc/rsnapshot.conf
  echo "50 12 1 * * rsnapshot monthly" >> /etc/crontabs/root
fi
if [ "${BACKUP_YEARLY}" -gt 0 ]
then
  echo "retain yearly ${BACKUP_YEARLY}">> /etc/rsnapshot.conf
  echo "50 13 1 1 * rsnapshot yearly" >> /etc/crontabs/root
fi

# start cron - we should be done!
/usr/bin/crond -f
