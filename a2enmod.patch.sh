#!/bin/bash

DIR=${0%/*}
patch /usr/sbin/a2enmod -i "$DIR"/a2enmod.patch
