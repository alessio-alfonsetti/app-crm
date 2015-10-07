#!/bin/bash

# For now, we're not pulling FAKE from NuGet. I discovered some missing functionality in 
# FAKE's XMLHelper. In our build.fsx, we take the google maps api key that gets passed 
# to this bash script, and we modify an XML file in the Android project to contain that key.
# See the pull request here: 
# After that pull request is approved:
#     1) Remove the ~/automation/fake/tools/FAKE directory from the repo.
#     2) Change the line at the top of buils.fsx to reference "packages/FAKE/tools/FakeLib.dll" instead of "tools/FAKE/FakeLib.dll".
#     3) Uncomment the following lines, which will make FAKE start pulling from NuGet again, and (hopefully) my improvements to FAKE's XMLHelper.

#if [ ! -f packages/FAKE/tools/FAKE.exe ]; then
#  mono tools/NuGet/NuGet.exe install FAKE -OutputDirectory packages -ExcludeVersion
#fi

if [ $# -eq 0 ]; then
  echo "You must at least provide a build target name."
  echo "Example: './build.sh [your buid target name]'"
  exit 1
else
  if [ $# -eq 1 ]; then # Assuming the build target is for iOS, and requires no additional parameters. Using this for an Android build will fail, because we require two more parameters for that. See below.
    mono tools/FAKE/FAKE.exe build.fsx $1 
  else # Assuming the build target is for Android. Check to make sure both additional parameters are present.
    if [ $# -ne 3 ]; then
      echo "You must provide two additional arguments: 1) your android keystore password and 2) your Google Maps For Android v2 API key."
	    echo "If you're using arguments in addition to the build target name arguments, it assumed you are attempting an Android build."
	    echo "This particular Android app build requires both an android keystore password and a Google Maps For Android v2 API key."
	    echo "Example: './build.sh [your buid target name] [your keystore password] [your Google Maps For Android v2 API key]'."
	    exit 1
    else
      # use for our android build, which requires the keystore password for signing the app, and the Google Maps API key because this app uses Maps.
      mono tools/FAKE/FAKE.exe build.fsx $1 android_keystore_password=$2 google_maps_for_android_v2_api_key=$3
	  fi
  fi
fi


