# Networking

## Components
- Two or more computers/devices
- Cable links between the computers
- A network interface card(NIC)
- Switches
- Routers
- Software called operating system (OS)

## OSI Model - Open System Interconnection
It has 7 layes
| Layer | Name | Purpose |
| ------|------|---------| 
| 1. | Pysical | To transmit bits over a medium; to provide mechanical and electrical specifications |
| 2. | Data Link | To organize the bits into frames; to provide hop-to-hop delivery |
| 3. | Network | To move packets from source to destination; to provide internetworking |
| 4. | Transport | To provide reliable process to process message delivery and error recovery |
| 5. | Session | To estabalish, manage, and terminate sessions |
| 6. | Presentation | To translate, encrypt, and compress data |
| 7. | Application | To allow access to network resources |

| OSI Model | DOD Model | Protocols | Devices/Apps |
|-----------|-----------|-----------|-----------|
| Layers 5, 6,7 | Application | DNS, DHCP, NTP, SNMP, HTTPS, FTP, SSH, TELNET, HTTP, POP3 | Web server, Mail server, Browser, mail client |
| Layer 4 | host-to-host | tcp, udp | Gateway |
| Layer 3 | internet | ip, icmp, igmp | router, firewall, layer 3 switch |
| Layer 2 | Network access | arp (mac), rarp | bridge layer 2 switch |
| Layer 1 | Network access | ethernet, token ring | hub |

## Classification

### By geography
- LAN
- WAN
- MAN - Metropolitaan Area network
- CAN - Campush area network
- PAT - Personal access network

## Protocols & Port Numbers

| TCP - Transmission Control Protocol | UDP - User Datagram Protocol |
|-------------------------------------|------------------------------|
| Reliable protocol                   | Unreliable protocol          |
| Connection oriented                 | Connectionless               |
| Performs three ways handshake       | Much faster than UDP         |
| Provision for error detection and retransmission | No acknowledgement waits |
| Most application uses TCP for reliable and guaranteed transmission | Suitable for application where speed matter than reliability |
| FTP, HTTP, HTTPS                    | DNS, DHCP. ARP, RARP         |

### Port Numbers
| Protocol | Service Name | UDP and TCP port number included |
|----------|--------------|----------------------------------|
| DNS      | Domain Service name | UDP - 53, TCP - 53        |
| HTTP     | Web                 | TCP - 80                  |
| HTTPS    | Secure Web (SSL)    | TCP - 443                 |
| SMTP     | Simple mail server  | TCP - 25                  |
| POP      | Post Office protocol | TCP - 109, 110           |
| SNMP     | Simple network management protocol | TCP & UDP - 161, 162 |
| TELNET   | Telnet terminal   | TCP - 23                      |
| FTP      | File Transfer protocol | TCP - 20, 21             |
| SSH      | secure shell terminal  |           TCP - 22     |
|AFP IP    | Apple File Protocol/IP | TCP - 447, 548           |

### Other Services
| Service Name | Use | Port Number |
|----------|--------------|----------------------------------|
| MySQL      | database | 3306        |
| Tomcat    | Host Java based web applications     | 8080      |
| Nginx     | Web server, loadbalancer | 80  |
| RabbitMQ  | Queue broker        | 5672    |
| Memcache  | Cache              | 11211   |


## DNS & DHCP

DNS (Domain Name System) translates human-friendly domain names (like google.com) into computer-readable IP addresses, acting as the internet's phonebook, while DHCP (Dynamic Host Configuration Protocol) automatically assigns IP addresses and network settings (like subnet mask) to devices, simplifying network administration. DNS handles name resolution (e.g., www.example.com -> 192.0.2.1), whereas DHCP manages dynamic IP allocation, allowing devices to join a network easily without manual configuration

## Networking Commands

| Command | Use |
|---------|-----|
| ifconfig, ip addr show | Show all active network interfaces | 
| ping 192.168.1.8 | send icmp packet | 
| tracerout www.google.com | Shows all (Router or hops) it will take to reach google server |
| netstat -antp | Show all the TCP open port in the current machine |
| nmap 80 | show open port |
| dig www.google.com, nslookup | Show if DNS resolution is working |
| Route | show gateway |
| mtr www.google.com |  like traceroute |