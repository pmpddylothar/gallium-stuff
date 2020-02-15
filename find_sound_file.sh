#!/bin/bash
echo "Checking your onbaord cards, please wait..."
export FINDCARD=$(cat /proc/asound/cards | grep " \[" | awk -F\[ '{print $2}' | awk -F\] '{print $1}')
cat << EOF
Found the following cards:
${FINDCARD}

EOF

echo "Searching for cards with configuration files..."
for card in ${FINDCARD};do
  export FINDFILE=$(sudo find /usr/share/alsa/ucm/ | grep HiFi | grep ${card})
  if [[ -z ${FINDFILE} ]];then
    cat << EOF
-- ${card} does not have alsa configruation"

EOF
  else
    export SPKVOL=$(cat ${FINDFILE} | grep 'Speaker Volume')
    export HDPVOL=$(cat ${FINDFILE} | grep 'Headphone Volume')
    cat << EOF
-- ${card} was found in alsa configuration
***************************************
Path to configuration file:
${FINDFILE}

Lines to Update to different value: 
${SPKVOL}
${HDPVOL}
EOF
  fi
done
