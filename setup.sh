#!/bin/bash

# This shell script is used to setup up a mahara checkout to be ready for
# RPM packaging.

# function for gathering some basic information
function getdata {
	echo "Enter the name of the project [0-9a-zA-Z_-]: "
	read project

	echo "Enter the full name of the package maintainer (e.g. John Doe): "
	read name

	echo "Enter the email of the package maintainer: "
	read email
}

# function that lets you verify the entered data
function verify {
	echo ""
	echo "project name: $project"
	echo "package maintainer: $name"
	echo "package maintainer email: $email"
	echo "Is this information correct? [Y/n]: "
	read answ

	case $answ in
		N|n)
			getdata
			verify
		;;

		Y|y)
		;;

		*)
			echo "please answer with 'y' or 'n'"
			verify
		;;
	esac
}

getdata
verify

# create the project specific makefile
sed -e "s#__PKGNAME__#$project#" rpm/Makefile.in > Makefile

# create an inital changelog
echo "* `date '+%a %b %d %Y'` $name <$email> v0.1
  - initial package" > changelog

# print out some help text
echo "
In your project directory you should now have a Makefile and a changelog
file. Please verify both files and adapt the changelog if necessary then
commit both files to version control.
The changelog contains an initial entry. Make sure the all future entries
have the same format. In the changelog you should only note the differences
to the previous package. It will be added to the RPM package.
"
