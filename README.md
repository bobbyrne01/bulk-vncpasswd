bulk-vncpasswd
==============

Set VNC password for a list of systems

## Dependancies
- [`sshpass`](http://sourceforge.net/projects/sshpass/) installed on host
- [`Expect`](http://expect.sourceforge.net/) installed on targets
- *nix OS on targets

## Usage

    user@system:~$ git clone https://github.com/bobbyrne01/bulk-vncpasswd.git
    user@system:~$ pwd
    /home/rob/git/bulk-vncpasswd
    user@system:~$ ./run.sh targets/servers.lst passw0rd
    
Or

    user@system:~$ python run.py targets/servers.lst passw0rd
