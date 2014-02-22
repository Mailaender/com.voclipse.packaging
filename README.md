com.voclipse.packaging
======================

Linux packaging for the [voclipse](http://voclipse.com) IDE. [![Build Status](https://build.vogella.com/ci/view/voclipse/job/C-MASTER-com.voclipse.packaging/badge/icon)](https://build.vogella.com/ci/view/voclipse/job/C-MASTER-com.voclipse.packaging/)

RPM
---

Unzip the pre-built voclipse archives into `root/opt/voclipse`. Then run `rpmbuild voclipse.spec`

DEB
---
Unzip the pre-built Eclipse archives into `root/opt/voclipse`. Also calculate the size of the installed package and update the dpkg control file.

```bash
PACKAGE_SIZE=`du --apparent-size -c "root/opt/voclipse" | grep "total" | awk '{print $1}'`
sed -i "s/{SIZE}/$PACKAGE_SIZE/" DEBIAN/control
```

Copy the `DEBIAN` directory into `root` and run `fakeroot dpkg-deb -b .` from there.