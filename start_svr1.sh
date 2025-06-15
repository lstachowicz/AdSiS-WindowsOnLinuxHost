#!/bin/bash

# Variables
MEMORY=2048  # Memory in MB
CPUS=2        # Number of CPU cores
DISK_IMAGE="svr1.qcow2"  # Path to the QCOW2 disk image
WINDOWS_ISO="17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"  # Windows Server 2019 ISO
VIRTIO_ISO="virtio-win.iso"  # VirtIO drivers ISO
BRIDGE="br0"  # Bridge interface

DISK_IMAGE_1="svr1-disk1.qcow2"  # Path to the QCOW2 disk image
DISK_IMAGE_2="svr1-disk2.qcow2"  # Path to the QCOW2 disk image
DISK_IMAGE_3="svr1-disk3.qcow2"  # Path to the QCOW2 disk image
DISK_IMAGE_4="svr1-disk4.qcow2"  # Path to the QCOW2 disk image
DISK_IMAGE_5="svr1-disk5.qcow2"  # Path to the QCOW2 disk image
DISK_IMAGE_6="svr1-disk6.qcow2"  # Path to the QCOW2 disk image
DISK_IMAGE_7="svr1-disk7.qcow2"  # Path to the QCOW2 disk image
DISK_IMAGE_8="svr1-disk8.qcow2"  # Path to the QCOW2 disk image
DISK_IMAGE_9="svr1-disk9.qcow2"  # Path to the QCOW2 disk image

# Start the Windows Server 2019 VM
qemu-system-x86_64 \
  -m $MEMORY \
  -smp cores=$CPUS \
  -M q35 \
  -enable-kvm \
  -cpu host \
  -drive file=$DISK_IMAGE,if=virtio \
  -drive file=$DISK_IMAGE_1,if=virtio \
  -drive file=$DISK_IMAGE_2,if=virtio \
  -drive file=$DISK_IMAGE_3,if=virtio \
  -drive file=$DISK_IMAGE_4,if=virtio \
  -drive file=$DISK_IMAGE_5,if=virtio \
  -drive file=$DISK_IMAGE_6,if=virtio \
  -vga virtio \
  -netdev bridge,id=net0,br=$BRIDGE \
  -device virtio-net-pci,netdev=net0,mac=52:54:01:12:34:56 \
  -name "SVR1_Windows_Server_2019"

  # if you want to use Windows Server 2019 ISO as a CD-ROM, add the following line:
  # -drive file=$VIRTIO_ISO,index=3,media=cdrom \
