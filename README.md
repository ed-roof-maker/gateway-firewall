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

The ipset fw4 config located here /etc/config/firewall and should look like below -
```
config ipset                                             
        option name 'dropcidr4'                          
        option comment 'IPv4 country blocks RU CN KP'    
        option family 'ipv4'                             
        option loadfile '/etc/luci-uploads/dropcidr4.txt'
        list match 'dest_net'                            
        option storage 'list'                            
                                                         
config ipset                                             
        option name 'dropcidr6'                          
        option comment 'IPv6 country blocks RU CN KP'    
        option family 'ipv6'                             
        option loadfile '/etc/luci-uploads/dropcidr6.txt'
        list match 'dest_net'                            
        option storage 'list' 
```

The fw4 zone drop settings are located here /etc/config/firewall and should look like below -
```
config rule                                              
        option ipset 'dropcidr4'                         
        option target 'DROP'                             
        option name 'Drop-Country-IPv4'                  
        option family 'ipv4'                             
        option dest 'wan'                                
        option src '*'                                   
                                                         
config rule                                              
        option ipset 'dropcidr6'                         
        option target 'DROP'                             
        option name 'Drop-Country-IPv6'                  
        option family 'ipv6'                             
        option dest 'wan'                                
        option src '*'                                   
```
## Test the Firewall
### Tests that Work for Russia
https://cbr.ru/eng/
https://yandex.com/
### Tests that Work for China
https://www.qq.com/
https://www.sohu.com/
https://www.boc.cn/en/index.html
### Tests that Fail for China
https://www.baidu.com/
https://www.tmall.com/
### Tests that Work for North Korea
N/A

## Install Linux DNS Block List
A block list suitable for residential networks.
Includes openphish and phish tank domains.
### Generate Block Lists
Configure your whitelists.
```
vim whitelist
```

Update anti phishing dbs
```
cd db_openphish
wget https://openphish.com/feed.txt
cd db_phishtank
wget http://data.phishtank.com/data/online-valid.csv
```

Generate hosts file -
```
bash gen-hosts.sh
```

Generate unbound hosts files -
```
bash gen-unbound-hosts.sh
```
### Install in Linux Hosts
```
cp -f dist/hosts /etc/
```
### Install in Windows Hosts
```
%SystemRoot%\system32\drivers\etc\hosts
```

### Install in MACOS
```
cp -f dist/hosts /private/etc
```

### Install in Open WRT DNS Masq
```
cd /etc
wget https://github.com/ed-roof-maker/gateway-firewall/raw/refs/heads/main/dns/dist/hosts
```

Restart the dnsmasq service.


