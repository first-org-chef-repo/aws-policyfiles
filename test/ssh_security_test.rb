control 'ディレクトリ 所有者、グループ、権限の確認' do
  describe file('/etc/ssh') do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into os.darwin? ? 'wheel' : 'root' }
    it { should be_executable }
    it { should be_readable.by('owner') }
    it { should be_readable.by('group') }
    it { should be_readable.by('other') }
    it { should be_writable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should_not be_writable.by('other') }
  end
end

control '設定ファイル 所有者、グループ、権限の確認' do
  describe file('/etc/ssh/sshd_config') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into os.darwin? ? 'wheel' : 'root' }
    it { should_not be_executable }
    it { should be_readable.by('owner') }
    it { should_not be_readable.by('group') }
    it { should_not be_readable.by('other') }
    it { should be_writable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should_not be_writable.by('other') }
  end
end

control 'rootログイン無効化' do
  describe sshd_config do
    its('PermitRootLogin') { should match(/no/) }
  end
end

control 'ポート番号指定' do
  describe sshd_config do
    its('Port') { should eq('22') }
  end
end

control 'プロトコル' do
  describe sshd_config do
    its('Protocol') { should eq('2') }
  end
end

control 'ログレベル' do
  describe sshd_config do
    its('LogLevel') { should eq('VERBOSE') }
  end
end

control '最大認証トライ回数' do
  describe sshd_config do
    its('MaxAuthTries') { should eq('1') }
  end
end

control '最大同時接続数' do
  describe sshd_config do
    its('MaxSessions') { should eq('1') }
  end
end

control '鍵認証ログインの有効化' do
  describe sshd_config do
    its('PubkeyAuthentication') { should eq('yes') }
  end
end

control '脆弱なログインの無効化' do
  describe sshd_config do
    its('HostbasedAuthentication') { should eq('no') }
  end
end

control 'パスワード認証ログインの無効化' do
  describe sshd_config do
    its('PasswordAuthentication') { should eq('no') }
  end
end

control '空パスワードログインの無効化' do
  describe sshd_config do
    its('PermitEmptyPasswords') { should eq('no') }
  end
end

control 'ケルベロス認証の無効化' do
  describe sshd_config do
    its('KerberosAuthentication') { should eq('no') }
  end
end

control 'X11転送の無効化' do
  describe sshd_config do
    its('X11Forwarding') { should eq('no') }
  end
end

control 'ログインバナーの無効化' do
  impact 1.0
  title 'Server: Banner'
  desc 'Specifies a banner file to serve before authentication succeeds'
  describe sshd_config do
    its('Banner') { should eq('none') }
  end
end
