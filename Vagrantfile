# -*- mode: ruby -*-
# vi: set ft=ruby :
#

require 'yaml'

if File.exist?('vagrant_settings.yaml')
    settings = YAML.load_file 'vagrant_settings.yaml'
else
    exit 1
end

Vagrant.configure(2) do |config|
  config.hostmanager.enabled = true

  if settings['vm_provider'] == 'docker'
    config.ssh.username = "root"
  end

  settings['hosts'].each do |my_host|
    config.vm.define my_host do |saltbox|

      if settings['vm_provider'] == 'docker'
        saltbox.vm.provider "docker" do |d|
          d.build_dir = "build/"
          d.has_ssh = true
          d.create_args = ["--privileged", "-dt"]
          d.env = { "container" => "docker" }
          d.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:ro"]
        end
      end

      saltbox.vm.hostname    = "#{my_host}.example.com"
      saltbox.ssh.insert_key = false

      #
      # If you're a salt master, generate the external pillar data from
      # settings['pillar_data'][*] and set them as a external data pillar source.
      #
      $is_salt_master = (my_host == 'saltmaster') ? true : false
      $salt_seed_master = {}
      if ($is_salt_master == true)
        saltbox.vm.synced_folder ".", "/vagrant", create: true
        saltbox.vm.synced_folder "#{settings['salt']['salt_path']}", "/srv/salt", create: true
        saltbox.vm.synced_folder "#{settings['salt']['pillar_path']}", "/srv/pillar", create: true
      end

      if settings['vm_provider'] == 'docker'
        saltbox.hostmanager.ip_resolver = proc do |machine|
          result = ""
          machine.communicate.execute("/sbin/ifconfig eth0") do |type, data|
            result << data if type == :stdout
          end
          (ip = /^\s*inet .*?(\d+\.\d+\.\d+\.\d+)\s+/.match(result)) && ip[1]
        end
      end

      saltbox.vm.provision "salt" do |salt|
        salt.install_type = "stable 2016.11.5"
        salt.run_highstate = false
        salt.verbose = true
        salt.colorize = true
        salt.log_level = 'debug'
        salt.bootstrap_options = '-P -p python-gnupg -p gnupg2 -p tar'

        if ($is_salt_master == true)
          salt.bootstrap_options += ' -M -S'
          salt.install_master = true
        end
      end
    end
  end
end
