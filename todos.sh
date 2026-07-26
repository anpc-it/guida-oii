#!/bin/bash
{
  echo "File:Line:Content"
  grep -rnriw --exclude-dir=.git --exclude="todos.sh" "TODO" .
} | sed 's/:/\t/' | sed 's/:/\t/' | column -t -s $'\t' -o " | "