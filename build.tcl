#!/usr/bin/tclsh

set arch "x86_64"
set base "naviserver-4.99.18"
set fileurl "https://sourceforge.net/projects/naviserver/files/naviserver/4.99.18/naviserver-4.99.18.tar.gz"

set var [list wget $fileurl -O $base.tar.gz]
exec >@stdout 2>@stderr {*}$var

if {[file exists build]} {
    file delete -force build
}

file mkdir build/BUILD build/RPMS build/SOURCES build/SPECS build/SRPMS
file copy -force $base.tar.gz build/SOURCES
file copy -force naviserver_lib.conf build/SOURCES
file copy -force naviserver.service build/SOURCES

set buildit [list rpmbuild --target $arch --define "_topdir [pwd]/build" -bb naviserver.spec]
exec >@stdout 2>@stderr {*}$buildit

# Remove our source code
file delete $base.tar.gz
