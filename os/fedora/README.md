# Fedora

This document contains infomation related to using Fedora Workstation in conjunction with the contents of this repository.

## Using `git` Provided by a Nix Flake

If you see the following error...

```
/etc/crypto-policies/back-ends/openssh.config: line 3: Bad configuration option: gssapikexalgorithms
/etc/crypto-policies/back-ends/openssh.config: terminating, 1 bad configuration options
```

...then you may need to create a new `openssh.config` file that removes the relevant line.
You may want to copy the existing config with a name like `openssh.config.bak` first if it is a symlink to another file.

The line will start with the following:

```
GSSAPIKexAlgorithms
```

After that change, you may see the following error:

```
/etc/ssh/ssh_config.d/50-redhat.conf line 7: Unsupported option "gssapiauthentication"
```

We will need to do something similar to before.
Find the affected file and create a backup if it is a symlink, like before.
In either the existing file or the new one, comment out the following line:

```
GSSAPIAuthentication yes
```

With those two file changes, you should be able to use `git` provided by flakes without issue.
