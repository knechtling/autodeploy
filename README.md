# autodeploy

prerequisites on ansible host
=============================
* ansible
* ansible-galaxy collection install kewlfft.aur


prerequisites on target
=======================
* openssh
* python
* git


testing with molecule
=====================

To run all tests:
```bash
molecule test
```

To test individual roles without modifying the inventory, you can use Molecule CLI tags:
```bash
molecule converge -s default -- --tags swap    # only swap role
molecule converge -s default -- --tags user    # only user role
molecule converge -s default -- --tags ssh     # only ssh role
```

No special code is needed in the playbook or scenario files to support this functionality. The tags correspond to the role names and can be used with any Molecule command that supports passing additional arguments to Ansible.


Debian (dwl desktop)
====================

`debian.yml` sets up dwl, slstatus and the dotfiles on Debian 13 (trixie)
for the user running it. Debian package names and other overrides live in
`vars/debian.yml`.

```bash
ansible-playbook debian.yml -K
ansible-playbook debian.yml -K --tags dwl    # only rebuild dwl/slstatus
```

Not in the Debian archive and not handled: waylock, wallust, walker and
elephant (install by hand into /usr/local/bin). The user, ssh and emptty
roles are Arch-only; Debian keeps its own user and display manager.
