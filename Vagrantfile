# -*- mode: ruby -*-
# vi: set ft=ruby :

N = 3

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  (1..N).each do |node_id|
    config.vm.define "node#{node_id}" do |node|
      node.vm.box = "bento/centos-7.3"
      node.vm.box_check_update = false

      node.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"

        # https://github.com/chef/bento/issues/682
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
      end

      node.vm.hostname = "node#{node_id}"

      node.vm.network "private_network", ip: "192.168.96.#{50 + node_id}"

      if node_id == N
        node.vm.provision :ansible do |ansible|
          ansible.limit = "all"
          ansible.inventory_path = "vagrant"
          ansible.playbook = "site.yml"
        end
      end
    end
  end
end
