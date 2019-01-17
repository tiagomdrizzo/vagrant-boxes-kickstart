#!/bin/bash
#set -x

# Remove previously generated images.
#
#rm -f box.img rhel7.box rhel7-vagrant.x86_64.qcow2

# Step 1 - Create qemu qcow2 disk image.
#
qemu-img create -f qcow2 -o compat=0.10 rhel7-vagrant.x86_64.qcow2 20G && chmod -v 777 *.qcow2

# Step 2 - Use an ISO image or a repository tree to create a basic guest
#          installation using virt-install and kickstart.
#
# Using a remote repository
#TREE=http://example.com/released/RHEL-7/7.6/Server/x86_64/os/
# Using an ISO image
TREE=~/iso/rhel-server-7.6-x86_64-dvd.iso
gstNAME="rhel7-vagrant.x86_64"
gstDISK="rhel7-vagrant.x86_64.qcow2"
gstMEM="1024"
gstCPU="1"
hypVIRTYPE="kvm"
gstKSTART="rhel7-kickvagrant.x86_64.ks"

virt-install --connect=qemu:///system \
    --network=bridge:virbr0 \
    --initrd-inject=./$gstKSTART \
    --extra-args="ks=file:/$gstKSTART no_timer_check console=tty0 console=ttyS0,115200 net.ifnames=0 biosdevname=0" \
    --name=$gstNAME \
    --disk ./$gstDISK,size=20,bus=virtio \
    --memory $gstMEM \
    --vcpus $gstCPU \
    --check-cpu \
    --virt-type $hypVIRTYPE \
    --hvm \
    --location $TREE \
    --nographics --noreboot #--debug

# Step 3 - Make the virtual machine disk image sparse a.k.a. thin-provisioned.
#          This means that free space within the disk image can be converted
#          back to free space on the host. The virtual machine must be shut
#          down before you use this command, and disk images must not be
#          edited concurrently.
#
LIBGUESTFS_BACKEND=direct virt-sparsify --compress -o compat=0.10 --tmp ./tmp/ rhel7-vagrant.x86_64.qcow2 box.img

# Step 4 - Archive and compress metadata.json, Vagrantfile, and the qcow2
#          image files together.
#
tar cvzf rhel7.box ./metadata.json ./Vagrantfile ./box.img

# Step 5 - Add the generated box to you cache.
#          Default directory: ~/.vagrant.d/boxes/
#
vagrant box add --name rhel7 rhel7.box --force
