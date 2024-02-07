echo "Copy public key..."

#mkdir /home/vagrant/.ssh
#mkdir /root/.ssh
cat /vagrant_keys/key.pub >> /home/vagrant/.ssh/authorized_keys
cat /vagrant_keys/key.pub >> /root/.ssh/authorized_keys

echo "*** Copying keys..."
cp /vagrant_keys/key.pub ~/.ssh/id_rsa.pub
cp /vagrant_keys/key ~/.ssh/id_rsa

cp /vagrant_keys/key.pub /home/vagrant/.ssh/id_rsa.pub
cp /vagrant_keys/key /home/vagrant/.ssh/id_rsa

chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/id*
chmod 644 /home/vagrant/.ssh/*.pub

chown -R root:root /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/id*
chmod 644 /root/.ssh/*.pub

echo "*** End copying keys..."