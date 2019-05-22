# Instructions
1. By server on Digital Ocean with Ubuntu
2. Install L2TP+IPSec server with `wget https://git.io/vpnsetup -O vpnsetup.sh && sudo sh vpnsetup.sh`
3. Configure Mikrotik as described [тута](https://mr-allen.com/mikrotik/incremental-rkn-bypass) or [здеся](https://medium.com/@Croozy/mikrotik-%D0%B8-%D1%80%D0%BE%D1%81%D0%BA%D0%BE%D0%BC%D0%BD%D0%B0%D0%B4%D0%B7%D0%BE%D1%80-%D1%8D%D1%84%D1%84%D0%B5%D0%BA%D1%82%D0%B8%D0%B2%D0%BD%D1%8B%D0%B9-%D0%B8-%D0%B0%D0%B2%D1%82%D0%BE%D0%BC%D0%B0%D1%82%D0%B8%D0%B7%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D1%8B%D0%B9-%D0%BE%D0%B1%D1%85%D0%BE%D0%B4-%D0%BE%D1%88%D0%B8%D0%B1%D0%BE%D1%87%D0%BD%D1%8B%D1%85-%D0%B1%D0%BB%D0%BE%D0%BA%D0%B8%D1%80%D0%BE%D0%B2%D0%BE%D0%BA-b58647f7d314) in the VPN, NAT and scripting parts
4. Add rules for l2tp, IPsec and vpn interface BEFORE fasttrack rule 
```
 3    ;;; l2tp
      chain=input action=accept protocol=udp in-interface=pppoe-out1 dst-port=1701 log=no 
      log-prefix="" 

 4    ;;; ipsec
      chain=input action=accept protocol=udp in-interface=pppoe-out1 dst-port=500,4500 
      log=no log-prefix="" 

 5    chain=input action=accept protocol=ipsec-ah in-interface=pppoe-out1 log=no 
      log-prefix="" 

 6    chain=input action=accept protocol=ipsec-esp in-interface=pppoe-out1 log=no 
      log-prefix="" 

 7    chain=forward action=accept in-interface=l2tp-out-vpn log=no log-prefix="" 

 8    chain=forward action=accept out-interface=l2tp-out-vpn log=no log-prefix="" 

 9    ;;; defconf: fasttrack
      chain=forward action=fasttrack-connection connection-state=established,related log=no 
      log-prefix="" 
```
Because speed tested with iperf3 without rules 7 and 8 is
```
[ ID] Interval           Transfer     Bandwidth       Retr
[  5]   0.00-10.06  sec  44.0 KBytes  35.8 Kbits/sec   18             sender
[  5]   0.00-10.06  sec  6.88 KBytes  5.60 Kbits/sec                  receiver

```
and with rules 7 and 8
```
[ ID] Interval           Transfer     Bandwidth       Retr
[  5]   0.00-10.08  sec  22.5 MBytes  18.7 Mbits/sec    0             sender
[  5]   0.00-10.08  sec  22.2 MBytes  18.5 Mbits/sec                  receiver

```
Tested on
```
        board-name: hAP ac
             model: RouterBOARD 962UiGS-5HacT2HnT
     firmware-type: qca9550L
  factory-firmware: 3.41
  current-firmware: 6.44.1
  upgrade-firmware: 6.44.3
```

5. Add to cron [update-rkn.sh](update-rkn.sh) script on the server in Digital Ocean
6. Install and configure nginx/apache on the server in Digital Ocean
