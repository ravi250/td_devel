#!/bin/bash

##########################################################################
#    download.sh
#    Copyright (C) 2015  Andreas Wenzel (https://github.com/tdawen)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##########################################################################


#
# Download required free packages
#

ERRORPACKAGES=""

for DL in \
	http://ftp.fau.de/apache/apr/apr-1.5.2.tar.bz2 \
	http://ftp.fau.de/apache/apr/apr-util-1.5.4.tar.bz2 \
	http://curl.haxx.se/download/curl-7.40.0.tar.bz2 \
	https://www.kernel.org/pub/software/scm/git/git-2.6.1.tar.gz \
	ftp://ftp.openssl.org/source/openssl-1.0.2d.tar.gz \
	http://prdownloads.sourceforge.net/scons/scons-local-2.3.4.tar.gz \
	http://serf.googlecode.com/svn/src_releases/serf-1.3.8.tar.bz2 \
	http://www.sqlite.org/2015/sqlite-amalgamation-3080801.zip \
	http://apache.arvixe.com/subversion/subversion-1.9.2.tar.bz2
do
	if [ "${DL#https://cpan.metacpan.org}" = "${DL}" ]
	then
		wget "${DL}" -O "${DL##*/}"
	else
		wget --no-check-certificate "${DL}" -O "${DL##*/}"
	fi

	if [ $? -ne 0 ]
	then

		echo "Error downloading package $DL!"
		if [ -z "${ERRORPACKAGES}" ]
		then
			ERRORPACKAGES="${DL##*/}"
		else
			ERRORPACKAGES="${ERRORPACKAGES} ${DL##*/}"
		fi

	else
		md5sum "${DL##*/}" >> md5sum.txt
	fi

done

if [ -z "${ERRORPACKAGES}" ]
then
	echo "Successfully downloaded all packages!"
	exit 0
else
	echo "Error in downloading package(s): ${ERRORPACKAGES}"
	exit 1
fi
