require 'spec_helper'

describe command('docker pull hello-world') do
  its(:exit_status) { should eq 0 }
end

describe command('docker run --rm hello-world') do
  its(:stdout) { should match /Hello from Docker!/ }
  its(:exit_status) { should eq 0 }
end
