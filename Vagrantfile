# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa
  Vagrant.configure(2) do |config| 
    config.vm.box = "centos/8" 
    #config.vm.box_version = "20210210.0" 
    config.vm.provider "virtualbox" do |v| 
    v.memory = 256 
    v.cpus = 1 
  end 
  config.vm.define "lab8" do |lab8| 
    lab8.vm.network "private_network", type: "dhcp" 
    lab8.vm.hostname = "lab8"
    lab8.vm.provision "file", source: "watchlog.sh", destination: "/tmp/watchlog.sh"
    lab8.vm.provision "file", source: "watchlog", destination: "/tmp/watchlog"
    lab8.vm.provision "file", source: "spawn-fcgi.service", destination: "/tmp/spawn-fcgi.service"
    lab8.vm.provision "file", source: "httpd.service", destination: "/tmp/httpd.service"
    lab8.vm.provision "shell" , path: "script.sh"
  end 
end 
