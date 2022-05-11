#!/bin/bash
fileToCompare=""
firstFile=""
secondFile=""
algorithm="sha256sum"

while true; do
    menu=("1. Calculate control sum"
        "2. Compare two files"
        "3. Choose comparing algorithm: $algorithm"
        "4. Quit"
    )

    input=$(zenity --list --column=Menu "${menu[@]}" --width 400 --height 400)
    case $input in

    "1. Calculate control sum")
        fileToCompare=$(zenity --file-selection --title "File to compare" --text "Choose a file to compare" --width 200)

        fileSum=$($algorithm "$fileToCompare")

        resultInfo="Control sum:\n$fileSum"
        zenity --info --title "Result" --text "$resultInfo"
        ;;

    "2. Compare two files")

        while true; do
            cmprMenu=(
                "1. First file: $firstFile"
                "2. Second file: $secondFile"
                "3. Compare"
                "4. Main menu"
            )

            cmprInput=$(zenity --list --column=Menu "${cmprMenu[@]}" --width 400 --height 400)
            case $cmprInput in

            "1. First file: $firstFile")
                firstFile=$(zenity --file-selection --title "File to compare" --text "Choose a file to compare" --width 200)
                ;;

            "2. Second file: $secondFile")
                secondFile=$(zenity --file-selection --title "File to compare" --text "Choose a file to compare" --width 200)
                ;;

            "3. Compare")
                if [[ -z $firstFile ]] || [[ -z $secondFile ]]; then
                    zenity --warning --title "File missing" --text "Please choose both files to compare" --width 200
                    continue
                fi
                firstSum=$($algorithm "$firstFile")
                secondSum=$($algorithm "$secondFile")

                if [ "$firstSum" = "$secondSum" ]; then

                    resultInfo="Files are the same\nControl sum:\n$firstSum"
                else
                    resultInfo="Files are not the same\nFirst control sum:\n$firstSum\nSecond control sum:\n$secondSum"

                fi

                zenity --info --title "Result" --text "$resultInfo"

                ;;

            *)
                break
                ;;
            esac

        done
        ;;

    "3. Choose comparing algorithm: $algorithm")
        algrtmMenu=(
            "1. sha256sum"
            "2. sha1sum"
            "3. sha224sum"
            "4. sha384sum"
            "5. sha512sum"
            "6. md5sum"
        )

        algrtmInput=$(zenity --list --column=Menu "${algrtmMenu[@]}" --width 400 --height 400)
        case $algrtmInput in

        "1. sha256sum")
            algorithm="sha256sum"
            ;;
        "2. sha1sum")
            algorithm="sha1sum"
            ;;
        "3. sha224sum")
            algorithm="sha224sum"
            ;;
        "4. sha384sum")
            algorithm="sha384sum"
            ;;
        "5. sha512sum")
            algorithm="sha512sum"
            ;;
        "6. md5sum")
            algorithm="md5sum"
            ;;
        *) ;;

        esac

        ;;
    *)
        break
        ;;

    esac
done
