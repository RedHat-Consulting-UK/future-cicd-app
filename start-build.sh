#!/usr/bin/env bash

git clone https://github.com/redhat-cop/spring-rest.git
pushd spring-rest

mvn -B clean install -DskipTests=true

ls target/*
rm -rf oc-build && mkdir -p oc-build/deployments
for t in $(echo "jar;war;ear" | tr ";" "\\n"); do
  cp -rfv ./target/*.$t oc-build/deployments/ 2> /dev/null || echo "No $t files"
done

oc start-build basic-spring -n my-project --from-file=$(pwd)/oc-build/deployments/shift-rest-1.0.0-SNAPSHOT.jar --wait

popd
rm -rf spring-rest
