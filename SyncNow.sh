#!/bin/bash
# Utility for dealing with Memento/Narrative Clip 
# CC-0 Ixtli Orange 2016

# if width is 0 or less than 60, make it 80
# if width is greater than 178 then make it 120

calc_whiptail_size(){
    WT_HEIGHT=20
    WT_WIDTH=$(tput cols)
    
    if [ -z "$WT_WIDTH" ] || [ "$WT_WIDTH" -lt 50 ]; then
        WT_WIDTH=60
    fi
    if [ "$WT_WIDTH" -gt 60 ]; then 
        WT_WIDTH=60
    fi

    WT_MENU_HEIGHT=$(($WT_HEIGHT-7))
}

do_about() {
    whiptail --msgbox " 
    This utility is designed to make downloading and working
    with a Narrative Clip on Linux much nicer and pretty.\
        " 20 70 1
}

do_change_if() {
    sudo ifconfig usb0 192.168.2.10 netmask 255.255.255.0 broadcast 192.168.2.255 
    sudo ifconfig usb0 | grep "inet addr:" | cut -d: -f2 | awk '{ print $1 }'
}

do_get_host_ip() {
    sudo ifconfig usb0 | grep "inet addr:" | cut -d: -f2 | awk '{ print $1 }'
}

do_get_files() {
    if [ -e ./files ]; then
        cd files
        wget ftp://192.168.2.2/mnt/storage/ --recursive -A jpg,json && mv ./192.168.2.2/mnt/storage/* ./ && rm -d *_* lost+found 192.168.2.2/mnt/storage 192.168.2.2/mnt 192.168.2.2 
        mmv "*/event_*_*_*.jpg" "#1/#2_#3.jpg"
        mmv "*/event_*_*_*.meta.json" "#1/#2_#3.meta.json"
        cd ..
    else 
    mkdir files && cd files
    wget ftp://192.168.2.2/mnt/storage/ --recursive -A jpg,json && mv ./192.168.2.2/mnt/storage/* ./ && rm -d *_* lost+found 192.168.2.2/mnt/storage 192.168.2.2/mnt 192.168.2.2
    mmv "*/event_*_*_*.jpg" "#1/#2_#3.jpg"
     mmv "*/event_*_*_*.meta.json" "#1/#2_#3.meta.json"
     cd ..
fi
}

do_get_images() {
    if [ -e ./images ]; then
        cd images
        wget ftp://192.168.2.2/mnt/storage/ --recursive -A jpg && mv ./192.168.2.2/mnt/storage/* ./ && rm -d *_* lost+found 192.168.2.2/mnt/storage 192.168.2.2/mnt 192.168.2.2 
        mmv "*/event_*_*_*.jpg" "#1/#2_#3.jpg" && cd ..
    else 
    mkdir images && cd images
    wget ftp://192.168.2.2/mnt/storage/ --recursive -A jpg && mv ./192.168.2.2/mnt/storage/* ./ && rm -d *_* lost+found 192.168.2.2/mnt/storage 192.168.2.2/mnt 192.168.2.2
    mmv "*/event_*_*_*.jpg" "#1/#2_#3.jpg" && cd ..
fi
}

# Pipe a filtered ls command after telneting to stdin and then to a textbox
do_list_images() {
   { echo "ls /mnt/storage -p | grep -v "lost" | grep /"; sleep 2;  echo "exit"; } | telnet 192.168.2.2 | grep -vE '(ls|Connection|#|Try|192.168.2.2|Escape)' | cut -c1-10 > .tmp_listfolders
    whiptail --textbox ./.tmp_listfolders 17 80
    rm .tmp_listfolders
}

do_clear_files() {
    { echo "rm /mnt/storage/*_*/ -r";sleep 10; echo "exit"; } | telnet 192.168.2.2 
    whiptail --textbox "Done" 10 20 
}

do_set_time() {
    TIME=$(date +%Y%m%d%H%M.%S)
    { echo "date --set "$TIME ;sleep 10; echo "exit"; } | telnet 192.168.2.2 
    whiptail --textbox "Done" 10 20 
}

do_download_then_clear() {
    do_get_files
    do_clear_files
}

rotate_images_and_clean() {
    ./FileSorter.sh
}

#
# Interactive loop
#

calc_whiptail_size
while true; do
    FUN=$(whiptail --title "Memento/Narrative Utility" --menu "options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Finish --ok-button Select \
    "1 About" "What's this all about?" \
    "2 Change interface" "add the usb0 interface required" \
    "3 List" "list image folders on Clip" \
    "4 Images" "dowload images" \
    "5 Images+JSON" "same as 4 but with JSON" \
    "6 Delete" "files on device" \
    "7 Time" "set time" \
    "8 Sort" "sort and rotate images in files" \
    3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        exit 0
    elif [ $RET -eq 0 ]; then 
        case "$FUN" in 
            1\ *) do_about ;;
            2\ *) do_change_if ;;
            3\ *) do_list_images ;;
            4\ *) do_get_images ;;
            5\ *) do_get_files ;;
            6\ *) do_clear_files ;;
            7\ *) do_set_time ;;
            8\ *) rotate_images_and_clean ;;
            *) whiptail --msgbox "Unrecognised option" 20 60 1 ;;
        esac || whiptail --msgbox "There was an error with $FUN" 20 60 1
    else
        exit 1 
    fi
done

