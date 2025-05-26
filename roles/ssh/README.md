<!-- DOCSIBLE START -->

# 📃 Role overview

## ssh




Description: Not available.

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 26/05/2025 |














### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Set authorized keys | ansible.posix.authorized_key | False |
| Ensure root has a .ssh directory | ansible.builtin.file | False |
| Set root authorized keys | ansible.posix.authorized_key | False |
| Ensure PubkeyAuthentication is enabled | ansible.builtin.lineinfile | False |









#### Dependencies

No dependencies specified.
<!-- DOCSIBLE END -->
