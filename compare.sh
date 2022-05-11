#!/bin/bash
fileToCompare=""
result=""

while true; do
    menu=("1. Choose file to compare"
        "2. Compare"
        "3. Quit")

    state=("File to compare:  $fileToCompare")

    input=$(zenity --list --column=Menu "${menu[@]}" --text "$state" --width 400 --height 400)
    case $input in
    "1. Choose file to compare")
        fileToCompare=$(zenity --file-selection --title "File name" --text "Choose a file to compare" --width 200)
        ;;

    "2. Compare")
        result=$(sha256sum "$fileToCompare")
        zenity --info --title "Result" --text "sha256sum:\n $result"
        ;;
    *)
        break
        ;;

    esac
done
