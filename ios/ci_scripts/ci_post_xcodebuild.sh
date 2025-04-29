#!/bin/sh
set -e

if [[ -n $CI_ARCHIVE_PATH ]];
then
    cd ..
    $CI_PRIMARY_REPOSITORY_PATH/ios/Pods/FirebaseCrashlytics/upload-symbols -gsp $CI_PRIMARY_REPOSITORY_PATH/ios/Runner/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
else
    echo "CI_ARCHIVE_PATH is not set. Skipping dSYM upload to FirebaseCrashlytics."
fi