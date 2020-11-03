# ArchStrike Package Updates
To keep packages up-to-date, `pkgupdates` automates a `GET` request to the upstream url, matching the version regex given a valid response, and comparing the upstream version to the ArchStrike repository.    

## Maintenance Basics
The file `archversion.conf` defines a upstream URL, version regex, and a Python expression for each package. The file `develversion.conf` defines the vcs package list. After updating `archversion.conf` or `develversion.conf` for a package, verify your changes work as expected.
```
./pkgupdates -cdn +pkgname
``` 
For `pkgupdates`, the `-x` option will display more examples of how to do custom version checks. The script `bin/cron-pkgupdates` will function better as a cron job than the underlying `pkgupdates`.
