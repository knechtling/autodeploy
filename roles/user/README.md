<!-- DOCSIBLE START -->

# 📃 Role overview

## user




Description: Not available.

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 26/05/2025 |














### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Create the user | ansible.builtin.user | False |
| Allow wheel group to use sudo | ansible.builtin.copy | False |
| Allow passwordless sudo for specific commands | ansible.builtin.copy | False |
| Set default visudo editor to nvim | ansible.builtin.copy | False |
| Ensure /etc/sysctl.d exists | ansible.builtin.file | False |
| Allow unrestricted dmesg access | ansible.builtin.copy | False |









#### Dependencies

No dependencies specified.
<!-- DOCSIBLE END -->
