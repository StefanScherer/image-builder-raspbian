require 'spec_helper'

describe file('/usr/local/bin/docker-compose') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe command('docker-compose --version') do
  its(:stdout) { should match /1.19.0/m }
  its(:exit_status) { should eq 0 }
end
