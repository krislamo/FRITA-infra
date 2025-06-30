# Free I.T. Athen's Infrastructure

This project is used to develop Ansible for deploying and maintaining websites
and services operated by Free I.T. Athens (FRITA).

- Requires GNU Make, Ansible, and Vagrant on the host

## Quick Start

1. Clone this project
2. Run `make` to provision a Rocky 9 base box
3. Go to
   - [Traefik Dashboard](https://traefik.local.freeitathens.org:9443/dashboard/#/)
   - [WordPress](https://www.local.freeitathens.org)
   - [Nextcloud](https://cloud.local.freeitathens.org)
   - [Mediawiki](https://wiki.local.freeitathens.org)
4. Click through the HTTPS security warning

## Production

1. Clone [production-env](https://github.com/freeitathens/production-env/) to
   `./environments`

   ```
   mkdir -p environments
   git clone git@github.com:freeitathens/production-env.git ./environments
   ```

2. Run `./scripts/vault-key.sh` from the root of the project to obtain the
   Ansible Vault password
3. Enter the Bitwarden Master Password
4. Run `ansible-playbook` against the production servers, e.g.,

   ```
   ansible-playbook -u root -i environments/production --vault-pass-file ./.ansible_vault webserver.yml --diff --check
   ```

5. Delete the `.ansible_vault` file when you are done

### Using Ansible Vault to add or rotate values

Do not submit ciphertext into Ansible Vault with the indention formatting.<br />
To submit, press `CTRL+d` twice.

- Decrypt Ansible Vault values

  ```
  ansible-vault decrypt --vault-pass-file .ansible_vault
  ```

- Encrypt new Ansible Vault values

  ```
  ansible-vault encrypt --vault-pass-file .ansible_vault
  ```

  - e.g.,
    `pwgen -s 100 1 | ansible-vault encrypt --vault-pass-file .ansible_vault`

## Authors

- **Kris Lamoureux** - _Project Founder_ -
  [@krislamo](https://github.com/krislamo)

## Copyrights and Licenses

Copyright (C) 2019, 2020, 2022, 2023, 2025 Free I.T. Athens

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
