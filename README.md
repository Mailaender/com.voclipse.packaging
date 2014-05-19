com.voclipse.packaging
======================

Installer packaging for the [voclipse](http://voclipse.com) IDE. [![Build Status](https://build.vogella.com/ci/view/voclipse/job/C-MASTER-com.voclipse.packaging/badge/icon)](https://build.vogella.com/ci/view/voclipse/job/C-MASTER-com.voclipse.packaging/)


Creating an .rpm package
------------------------

This creates an .rpm file which can be installed into RPM based Linux distributions like openSUSE, Fedora/RedHat/CentOS, etc.

Unzip the pre-built voclipse archives into `root/opt/voclipse`. Then run `rpmbuild voclipse.spec`


Creating a .deb package
-----------------------

This creates a .deb file which can be installed into DPKG based Linux distributions, like Debian and Ubuntu.

Unzip the pre-built Eclipse archives into `root/opt/voclipse`. Also calculate the size of the installed package and update the dpkg control file

```bash
PACKAGE_SIZE=`du --apparent-size -c "root/opt/voclipse" | grep "total" | awk '{print $1}'`
sed -i "s/{SIZE}/$PACKAGE_SIZE/" DEBIAN/control
```

and set the architecture

```bash
sed -i "s/{ARCH}/i386/" DEBIAN/control
```

Copy the `DEBIAN` directory into `root` and run `fakeroot dpkg-deb -b .` from there.


Creating a setup.exe for MS Windows
-----------------------------------

Unzip `com.vogella.vde.luna.product-win32.win32.x86.zip` into a directory of the same name. Afterwards run `makensis -DARCHITECTURE=x86 voclipse-setup.nsi` for a 32-bit installer. Use the ZIP file with the suffix `x86_64` and switch the `DARCHITECTURE=x86_64` for the 64-bit version.
