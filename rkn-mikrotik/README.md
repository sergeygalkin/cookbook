# Instructions
1. By server on Digital Ocean with Ubuntu
2. Install L2TP+IPSec server with `wget https://git.io/vpnsetup -O vpnsetup.sh && sudo sh vpnsetup.sh`
3. Configure Mikrotik as described [тута](https://mr-allen.com/mikrotik/incremental-rkn-bypass) or [здеся](https://medium.com/@Croozy/mikrotik-%D0%B8-%D1%80%D0%BE%D1%81%D0%BA%D0%BE%D0%BC%D0%BD%D0%B0%D0%B4%D0%B7%D0%BE%D1%80-%D1%8D%D1%84%D1%84%D0%B5%D0%BA%D1%82%D0%B8%D0%B2%D0%BD%D1%8B%D0%B9-%D0%B8-%D0%B0%D0%B2%D1%82%D0%BE%D0%BC%D0%B0%D1%82%D0%B8%D0%B7%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D1%8B%D0%B9-%D0%BE%D0%B1%D1%85%D0%BE%D0%B4-%D0%BE%D1%88%D0%B8%D0%B1%D0%BE%D1%87%D0%BD%D1%8B%D1%85-%D0%B1%D0%BB%D0%BE%D0%BA%D0%B8%D1%80%D0%BE%D0%B2%D0%BE%D0%BA-b58647f7d314) in the VPN and NAT part
4. Add to cron [update-rkn.sh](update-rkn.sh) script on the server in Digital Ocean
5. Install and configure nginx/apache on the server in Digital Ocean