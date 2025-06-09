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

# Optionally allow more verbosity in Ansible
VAGRANT_ANSIBLE_VERBOSE=ENV["VAGRANT_ANSIBLE_VERBOSE"] || false

Vagrant.configure("2") do |config|
  config.vm.box = "rockylinux/9"
  config.vm.hostname = "fritadev"
  config.vm.disk :disk, size: "100GB", primary: true
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
    libvirt.machine_virtual_size = 100
  end

  # Set VirtualBox settings
  config.vm.provider "virtualbox" do |vbox|
    vbox.cpus = 2
    vbox.memory = 4096
  end

  # Expand XFS rootfs
  config.vm.provision "shell", inline: <<-SHELL
    set -xe
    df -h /
    dnf install -y cloud-utils-growpart
    PART="$(findmnt -n -o SOURCE /)"
    DISK="$(lsblk -n -o PKNAME "$PART")"
    NUM="$(lsblk -n -o KNAME "$PART" | sed 's/.*[^0-9]//')"
    growpart "/dev/$DISK" "$NUM" && \
    xfs_growfs /
    df -h /
  SHELL

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ENV['ANSIBLE_ROLES_PATH'] = File.dirname(__FILE__) + "/roles"
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "dev/" + PLAYBOOK + ".yml"
    ansible.verbose = VAGRANT_ANSIBLE_VERBOSE
  end
end
