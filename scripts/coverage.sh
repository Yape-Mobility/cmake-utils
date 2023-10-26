#!/bin/bash

if [[ -d "coverage" ]]; then
  rm -rf ./coverage
fi

mkdir ./coverage

gcovr --gcov-executable gcov-9 -r . --html --html-details -o coverage/coverage.html .
