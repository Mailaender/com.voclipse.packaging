#
# Copyright (c) 2014 vogella GmbH, Hamburg Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.
#

Name: voclipse
Version: 4.4M5
Release: 0
Summary: Vogella Development Environment a.k.a. Voclipse
License: EPL-1.0
Url: http://voclipse.com
Group: Development/Tools/IDE
Packager: Matthias Mailänder <matthias.mailaender@vogella.com>
Requires: java
Prefix: /usr
Source0: com.vogella.vde.luna.product-linux.gtk.x86_64.zip
Source1: com.vogella.vde.luna.product-linux.gtk.x86.zip
Source2: voclipse.png
Source3: voclipse.desktop
BuildRoot: /tmp/voclipse

%description
A pre-configured Java IDE based on the award winning Eclipse project.
Includes all the tools needed to develop and debug: Java and Plug-in
Development Tooling, Git and Maven support, including source and
developer documentation.

%prep
%ifarch i586
%setup -q -c %{name}-32bit
%endif
%ifarch x86_64
%setup -a 1 -q -c %{name}-64bit
%endif

%build

%install
rm -rf %{buildroot}

mkdir -p %{buildroot}/opt/voclipse
cp -r * %{buildroot}/opt/voclipse

mkdir -p %{buildroot}%{_bindir}
ln -s /opt/%{name}/voclipse %{buildroot}%{_bindir}/voclipse

mkdir -p %{buildroot}%{_datadir}/icons/hicolor/64x64/apps/
cp %{S:2} %{buildroot}%{_datadir}/icons/hicolor/64x64/apps/

mkdir -p %{buildroot}%{_datadir}/applications/
cp %{S:3} %{buildroot}%{_datadir}/applications/

%post
update-desktop-database

%postun
update-desktop-database

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
/usr/bin/voclipse
/opt/voclipse
/usr/share/applications/voclipse.desktop
/usr/share/icons/hicolor/*/apps/*.png

%changelog
