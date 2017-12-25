require 'spec_helper'

describe command('docker swarm init') do
  its(:stdout) { should match /docker swarm join --token SWMTKN/ }
  its(:exit_status) { should eq 0 }
end

describe command('docker pull stefanscherer/whoami') do
  its(:exit_status) { should eq 0 }
end

describe command('docker service create --detach=false --name whoami -p 8080:8080 stefanscherer/whoami') do
  its(:stdout) { should match /Service converged/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl http://localhost:8080') do
  its(:stdout) { should match /I'm .* running on linux\/arm/ }
  its(:exit_status) { should eq 0 }
end
