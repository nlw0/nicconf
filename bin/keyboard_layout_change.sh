#!/bin/bash

current=`setxkbmap -query | grep layout | awk 'END{print $2}'`

if [ $current == 'br' ]; then
    echo oi
    setxkbmap us intl -option ctrl:nocaps
else
    echo ai
    setxkbmap br -option ctrl:nocaps
fi

