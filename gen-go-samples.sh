#!/bin/bash

set -e

if [ -z $GOOGLEAPIS ]; then
	echo 'add this line to ~/.bashrc'
	echo 'export GOOGLEAPIS=$HOME/code/googleapis'
fi

if [ -z $COMMON_PROTO ]; then
	echo 'add this line to ~/.bashrc'
	echo 'export COMMON_PROTO=$HOME/code/api-common-protos'
fi

if [ -z $WORKSPACE ]; then
	echo 'add this line to ~/.bashrc'
	echo 'export WORKSPACE=$HOME/code/workspace'
fi

mkdir -p $WORKSPACE/go-output
rm -rf $WORKSPACE/go-output/*

samples_arr=()
find_result=(`find "$GOOGLEAPIS/google/cloud/$1/$2/samples" -maxdepth 1 -name "*.yaml"`)
for i in "${find_result[@]}"
do
	samples_arr+=('--sample')
	samples_arr+=($i)
done

gen-go-sample \
  --clientpkg "cloud.google.com/go/$1/api$2;$1" \
  --gapic "$GOOGLEAPIS/google/cloud/$1/$2/$1_gapic.legacy.yaml" \
  --o $WORKSPACE/go-output \
  "${samples_arr[@]}" \
  --desc <(protoc -o /dev/stdout --include_imports -I "$COMMON_PROTO" -I "$GOOGLEAPIS" "$GOOGLEAPIS/google/cloud/$1/$2"/*.proto)
