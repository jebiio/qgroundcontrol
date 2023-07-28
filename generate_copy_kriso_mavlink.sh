#! /usr/bin/env bash
cur_dir=$(pwd)

rm -rf ~/mavlink_header
mkdir -p ~/mavlink_header

cd ~/mavlink_header

git clone https://github.com/jebiio/mavlink
cd mavlink
git checkout kriso_qgc42
git submodule update --init --recursive

python3 -m pymavlink.tools.mavgen --lang=C --wire-protocol=2.0 --output=out ./message_definitions/v1.0/ardupilotmega.xml

cp -rf ~/mavlink_header/mavlink/out/*  ${cur_dir}/libs/mavlink/include/mavlink/v2.0/
cd ~/mavlink_header/mavlink/out

cd ${cur_dir}
# ~/mavlink_header/mavlink/out 폴더에 생성
