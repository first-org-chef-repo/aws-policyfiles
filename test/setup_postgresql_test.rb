
# InSpec test for recipe postgresql_setup::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

case os.family
when 'redhat' || 'centos'
  describe service('postgresql-12') do
    it { should be_running }
    it { should be_enabled }
  end
when 'debian' || 'ubuntu'
  describe service('postgresql') do
    it { should be_running }
    it { should be_enabled }
  end
end
