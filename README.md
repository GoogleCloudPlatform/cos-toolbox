# Toolbox Docker Container for Container-Optimized OS

Note: This is not an official Google product.

## Overview

This is a Docker image used by the
[CoreOS Toolbox](https://github.com/coreos/toolbox) script on [Container-Optimized
OS](https://cloud.google.com/container-optimized-os/). This image comes
pre-installed with common debugging tools that are not pre-installed on the host.

The official toolbox container is available at `gcr.io/google-containers/toolbox`.
Current tag: `20190312-00`

Starting with tag `20190312-00`, COS toolbox includes a tool called
`cos-kernel` to make it easy to fetch kernel headers, source, and
toolchain for COS releases.  For example, the following command fetches
kernel headers, source, and toolchain for the instance it's running on:

```bash
my-cos-instance ~ $ toolbox
root@my-cos-instance:~# cos-kernel fetch
```

By default, `cos-kernel` uses `$HOME` as its install directory but this
can be changed via the `--instdir` option.  `cos-kernel` copies the
files it fetches in the `fetched-files` directory and extracts them into
`cos-kernel-headers`, `cos-kernel-src`, and `cos-toolchain`.

```bash
root@my-cos-instance:~# ls -l
drwxr-xr-x 4 root root  4096 Mar 12 14:43 cos-kernel-headers
drwxr-xr-x 4 root root  4096 Mar 12 14:44 cos-kernel-src
drwxr-xr-x 4 root root  4096 Mar 12 14:43 cos-toolchain
drwxr-xr-x 4 root root  4096 Mar 12 14:40 fetched-files
````
The following command fetches kernel headers, source, and toolchain for
release `11636.0.0` and builds the kernel:

```bash
root@my-cos-instance:~# cos-kernel build 11636.0.0
```

To see the list of available subcommands and their options, type:

```bash
root@my-cos-instance:~# cos-kernel help
```

For detailed documentation on how this is used, see
https://cloud.google.com/container-optimized-os/docs/how-to/toolbox.
