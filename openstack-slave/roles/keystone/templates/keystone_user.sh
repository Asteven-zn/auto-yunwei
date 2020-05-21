echo "export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://{{ api_ip }}:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
">/root/admin-openstack
source /root/admin-openstack

openstack domain create --description "An Example Domain" example
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password=demo demo
openstack role create user
openstack role add --project demo --user demo user

openstack user create --domain default --password=glance glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://{{ api_ip }}:9292
openstack endpoint create --region RegionOne image internal http://{{ api_ip }}:9292
openstack endpoint create --region RegionOne image admin http://{{ api_ip }}:9292

openstack user create --domain default --password=nova nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://{{ api_ip }}:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://{{ api_ip }}:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://{{ api_ip }}:8774/v2.1

openstack user create --domain default --password=placement placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://{{ api_ip }}:8778
openstack endpoint create --region RegionOne placement internal http://{{ api_ip }}:8778
openstack endpoint create --region RegionOne placement admin http://{{ api_ip }}:8778

openstack user create --domain default --password=neutron neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://{{ api_ip }}:9696
openstack endpoint create --region RegionOne network internal http://{{ api_ip }}:9696
openstack endpoint create --region RegionOne network admin http://{{ api_ip }}:9696

openstack user create --domain default --password=cinder cinder
openstack role add --project service --user cinder admin
openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3
openstack endpoint create --region RegionOne volumev2 public http://{{ api_ip }}:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://{{ api_ip }}:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://{{ api_ip }}:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 public http://{{ api_ip }}:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 internal http://{{ api_ip }}:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 admin http://{{ api_ip }}:8776/v3/%\(project_id\)s
