# Copyright (C) 2019  Free I.T. Athens
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Debian Stable box
  config.vm.box = "debian/stretch64"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Machine Name
  config.vm.define :frita do |frita| #
  end

  # Disable Machine Name Prefix
  config.vm.provider :libvirt do |libvirt|
    libvirt.default_prefix = ""
  end

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "site.yml"
  end

  # Display IP below
  config.vm.provision "shell" do |s|
    s.inline =  "
      ip a | grep 192.168 |
      awk '{
        print substr($2, 1, index($2,\"/\") - 1);
      }'
    "
  end

end
