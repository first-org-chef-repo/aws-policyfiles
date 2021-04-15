# InSpec test for recipe nginx_setup::install-nginx

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
end

describe port(80) do
  it { should be_listening }
end

describe command('curl -s localhost') do
  its('stdout') { should match /Welcome/ }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end
