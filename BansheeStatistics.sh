#!/bin/bash
which R >/dev/null 2>&1
if [ $? != 0 ]; then
  echo "No R found on this installation."
  exit 1
fi

R --no-save -f BansheeStatistics.R
