# Linux WAN Simulator

This project is basically a bash script that shows a menu upon login to select bandwidth, latency and packet loss. The script is designed to be run in place of a normal user login shell. 

The script uses Linux QoS `tc` commands in the background to dynamically change the characteristics of the interfaces affecting traffic flow.

### Prequisites:
- Any Linux distribution
- brutils package
- SSH server

### Setup:
1. Create a layer-2 bridge between two interfaces so that the traffic simulation is transparent to the endpoint systems. Use your distribution's documentation for instructions for confoguring Linux bridges.
  ```
  root@wansim:/# brctl show
  bridge name     bridge id               STP enabled     interfaces
  wanbr1          8000.0250011126e2       yes             eth1
                                                          eth2
   ```                                                     
2. Create a user that will be used to only run the WANsim script. Assign a password - `adduser wansimuser`, `passwd wansimuser`.
3. Copy the wansim-config.v2 file to a executable directory in the user's home directory - `/home/wansimuser/scripts/wansim-config-v2.sh`.
4. Change the permission so that only the user can execute it - `chmod 700 wansim-config.sh`
5. Change the shell parameter for the user in the `/etc/password` file to the name of the script.
  ```
  ...:/home/wanconfig/wansim-config-v2.sh
  ```
6. Add the user can be added to the `wheel` group.
7. Test by logging in via SSH with the created user - `ssh wansim@[IP address or hostname]`. Script will run in place of a shell.
```
          >>>> WANSIM CONFIGURATION MENU <<<<

Please choose from the following options:

1. Typical WAN                   BW: 500 kbps     DLY: ~100ms    LOSS: 0.5%
2. LFN WAN (T1) (HSTCP/MXTCP)    BW: 1.5 mbps     DLY: ~10ms     LOSS: 1%
3. Satellite WAN (SCPS)          BW: 2 mbps       DLY: ~500ms    LOSS: 2%
4. Typical LAN                   BW: 100 mbps     DLY: < ~5ms    LOSS: 0%

S. Show Currect Settings
C. Custom Bandwidth and Latency - Choose your own!
D. Defaults  - Revert All WAN Networks to Original Settings
Q. Quit menu and close console window

Enter choice [1,2,3,4,s,c,d,q]
```
8. Enjoy!
