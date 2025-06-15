sudo apt install bridge-utils  # Install bridge utilities if not already installed

# Create the bridge
sudo ip link add name br0 type bridge
sudo ip addr add 172.16.0.1/16 dev br0  # Assign the gateway IP to the bridge
sudo ip link set br0 up

sudo iptables -t nat -A POSTROUTING -s 172.16.0.0/16 ! -o br0 -j MASQUERADE

sudo mkdir -p /etc/qemu
echo "allow br0" | sudo tee /etc/qemu/bridge.conf
sudo chmod u+s /usr/lib/qemu/qemu-bridge-helper

# Some drivers may not be installed by default
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso

qemu-img create -f qcow2 dc1.qcow2 50G
qemu-img create -f qcow2 svr1.qcow2 50G
qemu-img create -f qcow2 svr2.qcow2 50G
qemu-img create -f qcow2 svr3.qcow2 50G
qemu-img create -f qcow2 cl1.qcow2 50G
qemu-img create -f qcow2 svr1-disk1.qcow2 20G
qemu-img create -f qcow2 svr1-disk2.qcow2 20G
qemu-img create -f qcow2 svr1-disk3.qcow2 20G
qemu-img create -f qcow2 svr1-disk4.qcow2 20G
qemu-img create -f qcow2 svr1-disk5.qcow2 20G
qemu-img create -f qcow2 svr1-disk6.qcow2 20G
qemu-img create -f qcow2 svr1-disk7.qcow2 20G
qemu-img create -f qcow2 svr1-disk8.qcow2 20G
qemu-img create -f qcow2 svr1-disk9.qcow2 20G

ls -lh dc1.qcow2
# -rw-r--r-- 1 user user 196K May 5 10:00 dc1.qcow2