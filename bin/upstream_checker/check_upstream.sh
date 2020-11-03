#!/usr/bin/bash

swd="$PWD"

## update our repos
printf '%s\n' 'UPDATING REPOS'
cd ArchStrike/packages
git pull

cd "$swd"
cd al_packages
svn up

cd "$swd"
cd al_community
svn up

printf '%s\n' 'CHECKING REPOS'
cd "$swd"
ignore=$(cat ignore.txt)
upstream_core=$(ls al_packages/)
upstream_comm=$(ls al_community/)
pkgs=''

function find_package {
    pkg_name=$1
    for iggy_pkg in $ignore; do
        [[ "$pkg_name" = "$iggy_pkg" ]] && return
    done
    hit=$(printf '%s\n' "$pkg_name" | xargs -I{} find ArchStrike/packages/ -name "{}")
    if [[ -z "$hit" ]]; then
        hit=$(printf '%s\n' "$pkg_name" | xargs -I{} find ArchStrike/packages/ -name "{}-git")
        if [[ -z "$hit" ]]; then
            printf '\n'
        fi
    fi
    printf '%s\n' "$(echo "$hit" | cut -d'/' -f3)"
}

function compare_package {
    root_pkg=$1
    conf_pkg=$2
    root_dir=$3
    root_desc=$(grep 'pkgdesc' "$root_dir/$root_pkg/trunk/PKGBUILD" | sed "s/\"/'/g")
    conf_desc=$(grep 'pkgdesc' "ArchStrike/packages/$conf_pkg/PKGBUILD" | sed "s/\"/'/g")
    if [[ "$root_desc" == "$conf_desc" ]]; then
        printf '%s\n' "|- $conf_pkg =(upstream)=> $root_pkg"
    fi
}

pkgs="CORE, EXTRA, TESTING +++"
for core_pkg in $upstream_core; do
    found=$(find_package "$core_pkg")
    if [[ -n "$found" ]]; then
        conflict=$(compare_package "$core_pkg" "$found" 'al_packages')
        if [[ -n "$conflict" ]];then
            pkgs="$pkgs\n$conflict"
        fi
    fi
done
pkgs="$pkgs\n+++"
pkgs="$pkgs\n"

pkgs="$pkgs\nCOMMUNITY +++"
for comm_pkg in $upstream_comm; do
    found=$(find_package "$comm_pkg")
    if [[ -n "$found" ]]; then
        conflict=$(compare_package "$comm_pkg" "$found" 'al_community')
        if [[ -n "$conflict" ]];then
            pkgs="$pkgs\n$conflict"
        fi
    fi
done
pkgs="$pkgs\n+++"

echo -e "$pkgs" > new_upstream.txt

if [[ -n "$pkgs" ]]; then
    old_hash=$(md5sum upstream.txt | cut -d' ' -f1)
    new_hash=$(md5sum new_upstream.txt | cut -d' ' -f1)
    if [[ "$old_hash" != "$new_hash" ]]; then
        mail -s 'UPSTREAM CONFLICTS/CHANGES' team@archstrike.org < new_upstream.txt
    fi
fi

mv new_upstream.txt upstream.txt

printf '%s\n' 'DONE'
