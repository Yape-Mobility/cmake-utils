#!/bin/bash

echo -e "\033[0;32m\033[1mRunning GCovr analysis ...\033[0m"

if [[ -d "coverage" ]]; then
  rm -rf ./coverage
fi

mkdir ./coverage

lcov -c -d . -o coverage.info
lcov -r coverage.info "/usr*" -o coverage_no_usr.info
genhtml coverage_no_usr.info --output-directory coverage