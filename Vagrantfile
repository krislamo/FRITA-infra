# vi: set ft=ruby :

# Set PLAYBOOK shell var for ./dev/playbook.yml
playbook=ENV["PLAYBOOK"]
if !playbook
  if File.exist?('.playbook')
    playbook = IO.read('.playbook').split("\n")[0]
  end

  if !playbook || playbook.empty?
    playbook = "webserver"
  end
else
  File.write(".playbook", playbook)
end

# Optionally allow more verbosity in Ansible
VAGRANT_ANSIBLE_VERBOSE=ENV["VAGRANT_ANSIBLE_VERBOSE"] || false

Vagrant.configure("2") do |config|
  config.vm.box = "krislamo.org/rocky10"
  config.vm.hostname = "fritadev"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.network "private_network", type: "dhcp"

  # Machine Name
  config.vm.define :frita do |frita| #
  end

  # Set libvirt settings
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 2
    libvirt.memory = 4096
    libvirt.default_prefix = ""
  end

  # Set VirtualBox settings
  config.vm.provider "virtualbox" do |vbox|
    vbox.cpus = 2
    vbox.memory = 4096
  end

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ENV['ANSIBLE_ROLES_PATH'] = File.dirname(__FILE__) + "/roles"
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "dev/" + playbook + ".yml"
    ansible.verbose = VAGRANT_ANSIBLE_VERBOSE
  end
end
