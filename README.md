# Gateway Firewall
A bunch of tools and resources for gateway hardening


# Linux Country Firewall
This is just a simple ipset firewall that blocks RU, CN, and KP.

Zone files come from the free provider ipdeny.com.

When testing, a lot of chinese sites still were not blocked.

It is better to have some form of country blocking than none at all.

## Install Linux Country Firewall
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
sudo bash harden-firewall.sh


Kernel ipset package cannot be installed via opkg.
We must use the builtin firewall's ipset.
Navigate to LuCI > Network > Firewall > IP Sets
Use the gui to configure the firewall to point ipsets to the location of dropcidr4.txt and dropcidr6.txt files.







