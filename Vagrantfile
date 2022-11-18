# vi: set ft=ruby :

# Set PLAYBOOK shell var for ./dev/playbook.yml
PLAYBOOK=ENV["PLAYBOOK"]
if !PLAYBOOK
  if File.exist?('.playbook')
    PLAYBOOK = IO.read('.playbook').split("\n")[0]
  end

  if !PLAYBOOK || PLAYBOOK.empty?
    PLAYBOOK = "webserver"
  end
else
  File.write(".playbook", PLAYBOOK)
end

# Debian 11
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.network "private_network", type: "dhcp"

  # Machine Name
  config.vm.define :frita do |frita| #
  end

  # Disable Machine Name Prefix
  config.vm.provider :libvirt do |libvirt|
    libvirt.default_prefix = ""
  end

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ENV['ANSIBLE_ROLES_PATH'] = File.dirname(__FILE__) + "/roles"
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "dev/" + PLAYBOOK + ".yml"
  end

end
