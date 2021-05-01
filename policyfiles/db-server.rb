# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

name 'db-server'
default_source :chef_server, 'https://chef-automate.creationline.com/organizations/first-org'
run_list 'node_setup::default', 'postgresql_setup::default'
cookbook 'node_setup', '1.0.0'
cookbook 'postgresql_setup', '1.0.0'

##########
# Attributes
##########

# Specify CCR interval and splay
override['chef_client']['interval'] = 1800 # 24H
override['chef_client']['splay'] = 0

# Specify Policy name & Policy group
override['node_setup']['policy_name'] = 'db-server'
override['node_setup']['policy_group'] = 'aws'

# Specify chef-client version
override['node_setup']['chef_client']['version'] = '17.0.242'
override['node_setup']['chef_client']['channel'] = 'stable'

# Disable Slack Notification that's set only for the initial CCR
override['chef_client']['handler']['slack']['enabled'] = false
# Specify node Time Zone
override['node_setup']['timezone'] = 'Asia/Tokyo'
