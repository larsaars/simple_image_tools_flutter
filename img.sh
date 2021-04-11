#!/bin/sh
echo "$1" > ~/.local/share/simple_image_tools/.sitpath
~/simple_image_tools_flutter/build/linux/release/bundle/simple_image_tools
