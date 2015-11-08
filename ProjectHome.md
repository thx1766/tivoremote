# Who needs a remote? #

Series 3 TiVos, and TiVoHDs, [now](http://www.tivocommunity.com/tivo-vb/showthread.php?t=392385) have an open tcp port for sending remote control commands.  This program puts a user interface on top of that, allowing you to control your TiVo with your iPhone or iPod Touch.

(Unfortunately, this cannot control volume, or turn a television on/off.  Maybe with an IP addressable IR/RF blaster, or if the television itself was on the network this would work.)

# Now Playing #
In version 0.20, TiVoRemote can download the Now Playing data from the TiVo.  With this data, you can browse the available programs, and start playing them automatically.  (The Media Access Key needs to be entered to download data.  The **group** and **sort** settings must match the TiVo's settings to correctly play the show.)

# TiVo Detection #
TiVoRemote version 0.15 has the ability to automatically detect TiVos on your network (this is accomplished by listening for the UDP broadcast packet that TiVos send out about every 60 seconds).  On the settings screen there is a new **Detected TiVos** section.  It lists every TiVo that has been detected on the network (it does not currently filter for TiVoHD, or Series 3 TiVos).

# Installation #
To install, add `http://tivoremote.googlecode.com/svn/www/repo.xml` to your Installer.app sources.  TiVoRemote is in the Toys category.

# Jailbroken 2.0 Installation #
Add "`deb http://tivoremote.googlecode.com/svn/www/ ./`" to your `/etc/apt/sources.list`, and install with Cydia.

![http://tivoremote.googlecode.com/svn/www/images/screen_shot.png](http://tivoremote.googlecode.com/svn/www/images/screen_shot.png)
![http://tivoremote.googlecode.com/svn/www/images/num_shot.png](http://tivoremote.googlecode.com/svn/www/images/num_shot.png)
![http://tivoremote.googlecode.com/svn/www/images/now_playing.png](http://tivoremote.googlecode.com/svn/www/images/now_playing.png)