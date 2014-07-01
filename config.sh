MainProjectRoot="AnjukeBroker_New"
Schema="AnjukeBroker_New"

ProvisoningProfileForDailybuild="E25111F6-465E-4F41-A369-262238C209D3"
#ProvisoningProfileForDistribute="C684A69D-0F0D-4CEC-8274-C8707AA7ED38"
#ProvisoningProfileForDistribute="63AAA575-4CB8-45A7-8A37-2904E7505450"
ProvisoningProfileForDistribute="910D6389-2B1F-460A-A29B-9479AC56078C"

SignIdentityForDailyBuild="iPhone Distribution: Ruiting Network Technology (Shanghai) Co., Ltd."
#SignIdentityForRelease="iPhone Distribution: RUITING NETWORK TECHNOLOGY(SHANGHAI)CO.,LTD."
SignIdentityForRelease="iPhone Distribution: RUITING NETWORK TECHNOLOGY(SHANGHAI)CO.,LTD (52KTBFLJDB)"

ProjectFileName=`ls ./|grep 'xcworkspace'`
ProjectName=`echo ${ProjectFileName}|awk -F'[\.]' '{print $1}'`
Version=`grep 'CFBundleVersion' -A 1 ./${ProjectName}/${MainProjectRoot}-Info.plist|grep string|awk -F'[\>\<]' '{print $3}'`

#QudaoList="A00 A01 A02 A08 A17 A18"
QudaoList="A01"

AnjukebuildPath="/tmp/anjukeb_broker_build"
if [ ! -d ${AnjukeBuidPath} ] ; then
    mkdir -p ${AnjukeBuildPath}
fi

AnjukeQudaoPath="/Users/anjuke/RUITING/i-broker/${Version}"
if [ ! -d ${AnjukeQudaoPath} ]; then
    mkdir -p ${AnjukeQudaoPath}
fi

#RemotePackagePath='mobile@ios.dev.anjuke.com:/var/www/apps/AnjukeBroker_New_Enterprice/ipa/'
RemotePackagePath='mobile@ios.dev.anjuke.com:/var/www/apps/AnjukeBroker_New/ipa/'

#denpendences
#dependences[0]='RTApiProxy:master'
#dependences[1]='RTCoreService:master'
#dependences[2]='RTNetwork:master'
#dependences[3]='UIComponents:master'
