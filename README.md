## Installation steps

First install `packer` and `VirtualBox`; Once complete you can then
use the following steps to automatically build the recent version of R
with solaris 10

```sh
git clone git@github.com:r-hub/solarischeck
cd solarischeck/packer
# Edit solaris10.json to point to the downloaded images
packer build solaris10.json
## If errors use this command
packer fix solaris10.json > solaris10-2.json
packer build solaris10-2.json

cd build
tar xvf solaris10-x86_64.box
```

At this point, I import the application.

I also adjust the settings to have:
 - A different name
 - More memory
 - My home directory as a permanent mount point
 - Port forwarding of ssh to 3022 as described in the rhub documentation
 
I can then start the system and then login to the solaris system using:

```sh
ssh -p 3022 -oKexAlgorithms=+diffie-hellman-group1-sha1 rhub@127.0.0.1 -o forwardx11=yes 
```

The password is "solaris" without the quotes; Once you have
successfully logged in once, you can use the bash script
`solaris10.sh` to log in again.

## Dependencies

Using administrator privilages with `sudo -s` run the `install.sh` 

Once the solaris machine has booted up, run the `./install.sh` script in this directory.

This:
- Installs the dependencies listed in r-hub
- Installs from source `libgit2`, required for `devtools`
- Installs fro source `udunits`, required for `units`

This should be enough to compile/run `RxODE`/`nlmixr` on solaris; Many
packages require the `gmake` instead of the solaris `make` command.
To work around this issue, before you start R you can call the
command:

```sh
export PATH=/bint:${PATH}
R
```

This simply has a symbolic link that uses `make` as `gmake`
