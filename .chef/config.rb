current_dir = File.dirname(__FILE__)
  user = 'r-goto'
  node_name                user
  client_key               "/home/r-goto/r-goto.pem"
  chef_server_url          "https://chef-automate.creationline.com/organizations/first-org"
  cookbook_path            ["#{current_dir}/../cookbooks"]
  cookbook_copyright       "First Org Cookbooks"
  cookbook_license         "Apache-2.0"
  cookbook_email           "cookbooks@first.org"
  chef_license             'accept'

  # Amazon AWS
  knife[:aws_access_key_id] = ENV['AWS_ACCESS_KEY_ID']
  knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
  knife[:region] = "ap-northeast-3"
