while getopts "v:" opt; do
  case $opt in
    v)
       version=$OPTARG;;
    *)  exit 1;;
    \?) exit 1;;
  esac
done

if [ -z "$version" ]
then
  echo "Unspecified fantom version"
  exit 1
fi

fruntime="fantom-$version"
fruntimezip="$fruntime.zip"

if [ -f $fruntimezip ];
then
  rm $fruntimezip
fi                 

echo "Downloading fantom $version..."
curl -o $fruntimezip "http://fan.googlecode.com/files/$fruntimezip"

echo "Installing fantom runtime artifact..."
sed 's/{VERSION}/'$version'/g' poms/runtime-pom.xml > runtime-pom.xml
mvn install:install-file -Dfile=$fruntimezip -Dpackaging=zip -DpomFile=runtime-pom.xml
rm "runtime-pom.xml"

unzip -q $fruntimezip

for pod in $fruntime/lib/fan/*.pod
do
  unzip -q $pod -d pod
  sed 's/{VERSION}/'$version'/g' poms/pod-pom.xml > pod-pom.xml 
  echo "Installing $pod..."
  while read line
  do
    if [[ $line = pod.name=* ]]
      then
        sed 's/{ID}/'${line:9:${#line}}'/g' pod-pom.xml > pod-pom.xml~ && mv "pod-pom.xml~" "pod-pom.xml"
      fi
    if [[ $line = pod.summary=* ]]
      then
        sed "s/{SUMMARY}/${line:12:${#line}}/g" pod-pom.xml > pod-pom.xml~ && mv "pod-pom.xml~" "pod-pom.xml"
      fi
  done < pod/meta.props 
  rm -rf pod
  mvn install:install-file -Dfile="$pod" -DpomFile=pod-pom.xml
  rm pod-pom.xml 
done
rm $fruntimezip
rm -rf $fdir
