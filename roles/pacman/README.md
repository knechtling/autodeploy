<!-- DOCSIBLE START -->

# 📃 Role overview

## pacman




Description: Not available.

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 26/05/2025 |














### Tasks


#### File: tasks/configure-pacman.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Update_system | community.general.pacman | False |
| Enable pacman colourised output and verbose package lists | ansible.builtin.replace | False |
| Enable repositories | ansible.builtin.replace | True |
| Ignore 'modified' group | ansible.builtin.replace | False |
| Create the `aur_builder` user | ansible.builtin.user | False |
| Allow the `aur_builder` user to run `sudo pacman` without a password | ansible.builtin.lineinfile | False |

#### File: tasks/install-packages.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Get list of installed packages | ansible.builtin.command | False |
| Determine missing packages | ansible.builtin.set_fact | False |
| Show missing packages | ansible.builtin.debug | True |
| Install only missing packages | community.general.pacman | True |
| Install yay | kewlfft.aur.aur | False |
| Install aur packages | kewlfft.aur.aur | False |

#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Configure pacman | ansible.builtin.include_tasks | False |
| Install packages | ansible.builtin.include_tasks | False |









#### Dependencies

No dependencies specified.
<!-- DOCSIBLE END -->
