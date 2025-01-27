# Apply updates and cleanup Apt cache

apt-get update ; apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y clean
# apt-get install docker.io -y

# Disable swap - generally recommended for K8s, but otherwise enable it for other workloads
echo "Disabling Swap"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Reset the machine-id value. This has known to cause issues with DHCP
#
echo "Reset Machine-ID"
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Reset any existing cloud-init state
#
echo "Reset Cloud-Init"
rm /etc/cloud/cloud.cfg.d/*.cfg
cloud-init clean -s -l

# Do not notify the DHCP server to release leases on graceful shutdown
/usr/bin/sed -i '/\[DHCPv4\]/a SendRelease=false' /etc/systemd/networkd.conf
