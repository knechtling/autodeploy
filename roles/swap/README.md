<!-- DOCSIBLE START -->

# 📃 Role overview

## swap




Description: Not available.

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 26/05/2025 |














### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Create swap subvolume | ansible.builtin.command | False |
| Ensure swap file exists | ansible.builtin.command | False |
| Set permissions on swap file | ansible.builtin.file | False |
| Run swapon on the swap file | ansible.builtin.command | True |
| Add swapfile to fstab | ansible.builtin.lineinfile | False |
| Set swappiness | ansible.posix.sysctl | False |
| Check if 'resume' hook is already in /etc/mkinitcpio.conf | ansible.builtin.shell | False |
| Insert 'resume' hook after 'filesystems' in /etc/mkinitcpio.conf | ansible.builtin.replace | True |









#### Dependencies

No dependencies specified.
<!-- DOCSIBLE END -->
