#!/bin/sh

Model=$1

# config some static var
source ./config.sh

# unlock keychain
security unlock-keychain

# define PACKAGENAME
PACKAGE_NAME=i-anjuke_${Version}'Ver'`date "+%Y%m%d"`'.a.ipa'

# output static var
echo "Version:"${Version}
echo "ProjectFileName:"${ProjectFileName}
echo "XCWorkSpaceName:"${ProjectFileName}
echo "ProjectName:"${ProjectName}
echo "SignIdentity:"${SignIdentity}
echo "ProvisioningProfileForDailyBuild:"${ProvisoningProfileForDailybuild}
echo "AnjukeBuildPath"${AnjukebuildPath}


die()
{
echo $*
echo "__EOF__"
rm -rf $PACKAGE_NAME
rm -rf ./Payload/
exit 1
}

# pull Repo 
#for component in ${dependences[@]}
#do
#    echo ${component}
#    repoName=`echo ${component}|awk -F':' '{print $1}'`
#    repoCommit=`echo ${component}|awk -F':' '{print $2}'`
#    echo 'RepoName:'${repoName}
#    echo 'RepoCommit:'${repoCommit}
#    cd ../${repoName}/
#    git checkout ${repoCommit}
#    git pull origin ${repoCommit}
#    cd -
#done

# switch xcode
xcode-select -switch /Applications/Xcode5.app/Contents/Developer/

xcodebuild -workspace ${ProjectFileName} -scheme ${Schema} -configuration $1 CODE_SIGN_IDENTITY="${SignIdentityForDailyBuild}" PROVISIONING_PROFILE="${ProvisoningProfileForDailybuild}" OBJROOT=${AnjukebuildPath} SYMROOT=${AnjukebuildPath} clean

echo "40%" > ../progress.log

xcodebuild -workspace ${ProjectFileName} -scheme ${Schema} -configuration $1 CODE_SIGN_IDENTITY="${SignIdentityForDailyBuild}" PROVISIONING_PROFILE="${ProvisoningProfileForDailybuild}" OBJROOT=${AnjukebuildPath} SYMROOT=${AnjukebuildPath} || die "Build Failed!"

echo "80%" > ../progress.log

mkdir Payload
cp -r ${AnjukebuildPath}/$1-iphoneos/${Schema}.app ./Payload

zip -r $PACKAGE_NAME ./Payload

echo "90%" > ../progress.log

echo "scp $PACKAGE_NAME mobile@ios.dev.anjuke.com:${RemotePackagePath}"
scp $PACKAGE_NAME ${RemotePackagePath}
rm -rf $PACKAGE_NAME
rm -rf ./Payload/

echo "100%" > ../progress.log

echo "__EOF__"
