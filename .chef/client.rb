# node_name "node01-web"
chef_license 'accept'
chef_server_url 'https://chef-automate.creationline.com/organizations/first-org'
policy_group 'aws'
policy_name 'web-server'
log_location STDOUT
validation_key '/etc/chef/first-org-validator.pem'
trusted_certs_dir '/etc/chef/trusted_certs'
