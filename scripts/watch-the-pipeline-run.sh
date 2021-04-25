#!/bin/bash -e
PL=$(tkn pr list | grep Running | awk '{ print $1 }') && tkn pr logs -f $PL