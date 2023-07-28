#! /usr/bin/env bash
cur_dir=$(pwd)

rm -rf ~/qgc_build_temp
mkdir -p ~/qgc_build_temp
cd ~/qgc_build_temp

git clone -b fix_gst_glib2_68 https://github.com/patrickelectric/gst-plugins-good
echo "Copy gst-plugins-good to qgroundcontrol/libs/qmlglsink/gst-plugins-good"
cp -rf ~/qgc_build_temp/gst-plugins-good/* ${cur_dir}/libs/qmlglsink/gst-plugins-good/

cd ${cur_dir}