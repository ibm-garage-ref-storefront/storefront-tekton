#!/bin/bash
source ~/config

echo "building images"
export HERE=${PWD}
echo "Working from $HERE"

echo "Select a target image registry"
echo

# PS3 is an environment variable
# that sets the menu prompt
PS3="Choose a number: "

# The select command creates the menu
select CHOICE in quay ocp  Quit
do
    case $CHOICE in
        "quay")
            export TARGET=QUAY
            break
            ;;
        "ocp")
            export TARGET=OCP
            break
            ;;
        "Quit")
            exit
            ;;
        *)  echo "Invalid Choice";;
    esac
done    

echo "TARGET=$TARGET"

bash $HERE/scripts/catalog/build.sh $TARGET
bash $HERE/scripts/customers/build.sh $TARGET
bash $HERE/scripts/inventory/build.sh $TARGET
bash $HERE/scripts/orders/build.sh $TARGET
bash $HERE/scripts/web/build.sh $TARGET
bash $HERE/scripts/auth/build.sh $TARGET