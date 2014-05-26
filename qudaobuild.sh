#!/bin/sh
source ./config.sh

echo "Version:"${Version}
echo "ProjectFileName:"${ProjectFileName}
echo "XCWorkSpaceName:"${ProjectFileName}
echo "ProjectName:"${ProjectName}
echo "SignIdentity:"${SignIdentity}
echo "ProvisioningProfileForDailyBuild:"${ProvisoningProfileForDailybuild}
echo "AnjukeBuildPath"${AnjukebuildPath}
echo "AnjukeQudaoPath"${AnjukeQudaoPath}

#security unlock-keychain


die()
{
echo $*
echo "__EOF__"
rm -rf $PACKAGE_NAME
rm -rf ./Payload/
exit 1
}

# pull Repo 
# for component in ${dependences[@]}
# do
#     echo ${component}
#     repoName=`echo ${component}|awk -F':' '{print $1}'`
#     repoCommit=`echo ${component}|awk -F':' '{print $2}'`
#     echo 'RepoName:'${repoName}
#     echo 'RepoCommit:'${repoCommit}
#     cd ../${repoName}/
#     git checkout ${repoCommit}
#     git pull origin ${repoCommit}
#     cd -
# done

PACKAGE_NAME=i-broker_${Version}'Ver'`date "+%Y%m%d"`'_A01_.a.ipa'

#xcode-select -switch /Applications/Xcode.app/Contents/Developer/

xctool -reporter pretty -workspace ${ProjectFileName} -scheme ${Schema} -configuration Release CODE_SIGN_IDENTITY="${SignIdentityForRelease}"                                                          PROVISIONING_PROFILE="${ProvisoningProfileForDistribute}"     OBJROOT=${AnjukebuildPath} SYMROOT=${AnjukebuildPath} clean

echo "40%" > ../progress.log

xctool -reporter pretty -workspace ${ProjectFileName} -scheme ${Schema} -configuration Release CODE_SIGN_IDENTITY="${SignIdentityForRelease}"                                                          PROVISIONING_PROFILE="${ProvisoningProfileForDistribute}"     OBJROOT=${AnjukebuildPath} SYMROOT=${AnjukebuildPath} || die "Build Failed!"

mkdir Payload
#cp -r ${AnjukebuildPath}/Release-iphoneos/Anjuke.app ./Payload
cp -r ${AnjukebuildPath}/Release-iphoneos/${Schema}.app ./Payload

# 先把A01的打好，保证AppStore质量
zip -r $PACKAGE_NAME ./Payload

echo "cp -rf $PACKAGE_NAME ${AnjukeQudaoPath}"
cp -rf $PACKAGE_NAME ${AnjukeQudaoPath}
rm -rf $PACKAGE_NAME
plutil -convert xml1 ./Payload/${Schema}.app/config.plist
cp ./Payload/${Schema}.app/config.plist /tmp/config.plist

packageByChannalId()
{
PACKAGE_NAME=i-broker_${Version}'Ver'`date "+%Y%m%d"`'_'$1'_.a.ipa'
echo "now zip package"${PACKAGE_NAME}
sed -e "s/A01/$1/g" /tmp/config.plist > ./Payload/${Schema}.app/config.plist 
plutil -convert binary1 ./Payload/${Schema}.app/config.plist
zip -r $PACKAGE_NAME ./Payload

echo "cp -rf $PACKAGE_NAME ${AnjukeQudaoPath}"
cp -rf $PACKAGE_NAME ${AnjukeQudaoPath}
rm -rf $PACKAGE_NAME
}

for qudaoId in  ${QudaoList} 
do
   packageByChannalId ${qudaoId}
done

rm -rf ./Payload/
