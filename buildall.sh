#!/usr/bin/env bash

pushd cogl
./build.sh
popd
pushd clutter
./build.sh
popd
pushd clutter-gtk
./build.sh
popd

