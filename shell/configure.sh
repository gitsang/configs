#!/bin/bash

mkdir -p ~/.local/etc
rsync -avPh ./etc/* ~/.local/etc/
