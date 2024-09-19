# Gateway Firewall
A bunch of tools and resources for gateway hardening


# Linux Country Firewall
This is just a simple ipset firewall that blocks RU, CN, and KP.

Zone files come from the free provider ipdeny.com.

When testing, a lot of chinese sites still were not blocked.

It is better to have some form of country blocking than none at all, especially if you have no business to visit websites there.

## Install Linux Country Firewall
### Debian Ubunut Mint
Install ipset in debian/ubuntu/mint -
```
apt install ipset
```
Create the ipset names -
```
ipset create list-ipv4 hash:net family inet
ipset create list-ipv6 hash:net family inet6
```
Load and activate the country firewall for this session -
```
sudo bash harden-firewall.sh
```
### Open WRT
Kernel ipset package cannot be installed via opkg.
We must use the builtin firewall's ipset.
SSH into your router.
Download the below files to your router.
```
cd /etc/luci-uploads
wget https://github.com/ed-roof-maker/gateway-firewall/raw/refs/heads/main/firewall/dist/dropcidr4.txt
wget https://github.com/ed-roof-maker/gateway-firewall/raw/refs/heads/main/firewall/dist/dropcidr6.txt
```
Navigate to LuCI > Network > Firewall > IP Sets
Use the gui to configure the firewall to point ipsets to the /etc/luci-uploads/dropcidr4.txt and dropcidr6.txt files.
Now modify the firewall to drop based on the loaded ipset.

## Install Linux Unbound DNS Block List







