#!/bin/bash
firstFile="$1"
secondFile="$2"
algorithm="sha256sum"

while true; do
    option1="1. Calculate control sum of selected file"
    option2="2. Compare two files"
    option3="3. Calculate control sum of entered text"
    option4="4. Compare file and text"
    option5="5. Choose comparing algorithm: $algorithm"

    menu=("$option1" "$option2" "$option3" "$option4" "$option5")

    input=$(zenity --list --column=Menu "${menu[@]}" --width 400 --height 400)
    case $input in

    $option1)
        firstFile=$(zenity --file-selection --title "File to compare" --text "Choose a file to compare" --width 200)

        fileSum=$($algorithm "$firstFile" | cut -d " " -f 1)

        resultInfo="Control sum:\n$fileSum"
        zenity --info --title "Result" --text "$resultInfo"
        ;;

    $option2)

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
                firstSum=$($algorithm "$firstFile" | cut -d " " -f 1)
                secondSum=$($algorithm "$secondFile" | cut -d " " -f 1)

                if [ "$firstSum" = "$secondSum" ]; then

                    resultInfo="Files are the same\nControl sum:\n$firstSum"
                else
                    resultInfo="Files are not the same\nFirst control sum:\n$firstSum\nSecond control sum:\n$secondSum"

                    logEntry="$(date)   $algorithm   $firstFile: $firstSum   $secondFile: $secondSum"
                    echo $logEntry>>log.txt
                fi

                zenity --info --title "Result" --text "$resultInfo"

                ;;

            *)
                break
                ;;
            esac

        done
        ;;

    $option3)
        text=$(zenity --entry --width 400 --height 300 --title "Calculate sum from text")
        echo "$text" >tempSum.txt

        textSum=$($algorithm tempSum.txt | cut -d " " -f 1)
        resultInfo="Control sum of $text:\n$textSum"
        zenity --info --title "Result" --text "$resultInfo"
        rm tempSum.txt
        ;;

    $option4)

        while true; do

            textFileMenu=(
                "1. File: $firstFile"
                "2. Text: $text"
                "3. Compare"
                "4. Main menu"
            )

            textFileInput=$(zenity --list --column=Menu "${textFileMenu[@]}" --width 400 --height 400)
            case $textFileInput in

            "1. File: $firstFile")
                firstFile=$(zenity --file-selection --title "File to compare" --text "Choose a file to compare" --width 200)
                ;;

            "2. Text: $text")
                text=$(zenity --entry --width 400 --height 300 --title "Calculate sum from text")
                echo "$text" >tempSum.txt

                ;;

            "3. Compare")
                if [[ -z $firstFile ]] || [[ -z $text ]]; then
                    zenity --warning --title "File or text missing" --text "Please choose file and enter text to compare" --width 200
                    continue
                fi
                firstSum=$($algorithm "$firstFile" | cut -d " " -f 1)
                textSum=$($algorithm tempSum.txt | cut -d " " -f 1)

                if [ "$firstSum" = "$textSum" ]; then

                    resultInfo="File and entered text are the same\nControl sum:\n$firstSum"
                else
                    resultInfo="File and entered text are not the same\nFirst control sum:\n$firstSum\nSecond control sum:\n$textSum"

                    logEntry="$(date)   $algorithm   $firstFile: $firstSum   $text: $textSum"
                    echo $logEntry>>log.txt
                fi

                zenity --info --title "Result" --text "$resultInfo"
                rm tempSum.txt
                ;;

            *)
                break
                ;;
            esac

        done

        ;;

    $option5)
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
