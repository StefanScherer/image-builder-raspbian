require 'spec_helper'

describe package('cloud-init') do
  it { should be_installed }
end

describe package('occi') do
  it { should_not be_installed }
end

describe package('device-init') do
  it { should_not be_installed }
end

describe file('/boot/user-data') do
  it { should be_file }
  its(:content) { should match /hostname: / }
end

describe file('/boot/meta-data') do
  it { should be_file }
end
