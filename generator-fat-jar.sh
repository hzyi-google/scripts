#!/bin/bash

pushd .
  cd ~/code/gapic-generator
  ./gradlew fatJar
popd