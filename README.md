# ArchStrike Package Updates
To keep packages up-to-date, `pkgupdates` automates a `GET` request to the upstream url, matching the version regex given a valid response, and comparing the upstream version to the ArchStrike repository.    

## Dependencies
```sh
git clone git@github.com:ArchStrike/archversion-envconfig-git.git
cd archversion-envconfig-git/
alias build='arch-nspawn ${CHROOT}/root pacman -Syu; makechrootpkg -c -r ${CHROOT} -- -i'
build
sudo pacman -U archversion-envconfig-git-*-any.pkg.tar.zst
sudo pacman -S curl git pacman sqlite tar python-gitpython python-systemd
```
By installing `archversion-envconfig-git`, the dependency `pyalpm` is satisfied for `bin/pkgupdates-maintenace`.

## Maintenance Basics
The file `archversion.conf` defines a upstream URL, version regex, and a Python expression for each package. The file `develversion.conf` defines the vcs package list. After updating `archversion.conf` or `develversion.conf` for a package, verify your changes work as expected.
```
pkgupdates-sync -cdn +pkgname
``` 
For `pkgupdates-sync`, the `-x` option will display more examples of how to do custom version checks. The script `bin/cron-pkgupdates` will function better as a cron job than the underlying `pkgupdates`.    

The `pkgupdates` script calls both `pkgupdates-sync` and `pkgupdates-maintenance`. To bucket missing packages by URL response code, run `pkgupdates-maintenance --resolve`.
