#!/bin/bash

mkdir -p ~/.local/bin
rsync -avPh ./bin/* ~/.local/bin/
