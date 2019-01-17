# Creating Vagrant Boxes using Kickstart

## Description

Quick n'dirty script to create vagrant boxes using RHEL/CentOS 7 ISO/Repository and kickstart.

## Requisites

- Tested with Fedora 29 (should work on other versions)
- Vagrant 2.1.2
- libvirt (virt-install and qemu-img)

## Install

~~~
# dnf install @virtualization libvirt-devel vagrant vagrant-libvirt vagrant-libvirt-doc
~~~

## Oddities

- For some reason RHEL/CentOS 7.5 doesn't like vagrant, no boot image found when deploying the box in libvirt.
- The exact same process works for RHEL/CentOS 7.6.
