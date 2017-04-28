############################################################
#
# This script helped me twice to recover a vagrant machine
# which for some reason did not want to start up anymore.
#
############################################################

rm -rf .vagrant/machines/default/virtualbox/id.bkp
mv .vagrant/machines/default/virtualbox/id .vagrant/machines/default/virtualbox/id.bkp 2>/dev/null || true
echo "3e1cf2dc-0f80-4af6-843b-451ba04ddd9f" > .vagrant/machines/default/virtualbox/id
cp ~/.ssh/id_rsa.pub .vagrant/machines/default/virtualbox/private_key
