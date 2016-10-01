#!/bin/sh

DIR="/deployments"

erb ${DIR}/karaf/build/etc/users.properties.erb > ${DIR}/karaf/etc/users.properties
erb ${DIR}/karaf/build/etc/org.ops4j.pax.logging.cfg.erb > ${DIR}/karaf/etc/org.ops4j.pax.logging.cfg
cp -f ${DIR}/karaf/build/bin/setenv ${DIR}/karaf/bin/setenv

DIR=${DEPLOY_DIR:-${DIR}/karaf/deploy}

cd ${DIR}/fabric8/etc

for i in * ; do
  if [[ ${i: -4} == ".erb" ]]; then
    erb $i > ${DIR}/karaf/etc/${i%.*}
  else
    cp $i ${DIR}/karaf/etc/$i
  fi
done

echo "Copying offline repo"
cp -rf $DIR/fabric8/repository/* ${DIR}/karaf/system/
echo "Checking for kars in $DIR/kars"
if [ -d $DIR ]; then
  for i in $DIR/*.kar; do
     file=$(basename $i)
     echo "Linking $i --> ${DIR}/karaf/deploy/$file"
     ln -s $i ${DIR}/karaf/deploy/$file
  done
fi

# send log output to stdout
sed -i 's/^\(.*rootLogger.*\), *out *,/\1, stdout,/' ${DIR}/karaf/etc/org.ops4j.pax.logging.cfg

# Launch Karaf using S2I script
exec /usr/local/s2i/run
