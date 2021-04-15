control 'ユーザ確認' do
  describe user('root') do
    it { should exist }
  end
  describe user('r-goto') do
    it { should exist }
  end
end

control 'SSHデーモン確認' do
  describe service('sshd') do
    it { should be_running }
    it { should be_enabled }
  end
end

control 'タイムゾーン確認' do
  describe bash('timedatectl status | grep Tokyo') do
    its('stdout') { should include 'Time zone: Asia/Tokyo' }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
end
