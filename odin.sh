#!/bin/bash

function display_help() {
echo ""
echo ""
echo ░█████╗░██████╗░██╗███╗░░██╗██████╗░
echo ██╔══██╗██╔══██╗██║████╗░██║╚════██╗
echo ██║░░██║██║░░██║██║██╔██╗██║░█████╔╝
echo ██║░░██║██║░░██║██║██║╚████║░╚═══██╗
echo ╚█████╔╝██████╔╝██║██║░╚███║██████╔╝
echo ░╚════╝░╚═════╝░╚═╝╚═╝░░╚══╝╚═════╝░

  echo "Usage: ./odin.sh [recovery.img]"
  echo "Options:"
  echo "  -h            shows this screen"
  echo "  -v            prints version"
}

function display_version() {
  echo "Odin CLI v1(made by 0xyf77, thank you Android Platform Tools for adb and fastboot)"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h)
      display_help
      exit 0
      ;;
    -v)
      display_version
      exit 0
      ;;
    *)
      if [[ -f "$1" ]]; then
        file="$1"
        break
      else
        echo "[e] no file selected"
        exit 1
      fi
      ;;
  esac
  shift
done

is_a_b=false
if adb shell getprop ro.boot.slot_suffix | grep "_b" >/dev/null; then
  is_a_b=true
fi

function main() {
  adb reboot bootloader

  if $is_a_b; then
    fastboot boot "$file"
    echo "Please manually install the recovery ramdisk from the custom recovery menu when the device boots."
  else
    fastboot flash recovery "$file"
    fastboot reboot
  fi
}

main

