#!/bin/bash

CPPCHECK_RESULT=0
CLANG_TIDY_RESULT=0

RESULTS=()

CppCheck()
{
  folders=$1
  echo -e "\033[0;32m\033[1mRunning CppCheck analysis...\033[0m"
  for f in ${folders[@]}; do
    if [ "${f}" == "utilities" ]; then
      continue
    fi
    cppcheck --cppcheck-build-dir=build/ --inline-suppr --enable=style --error-exitcode=1 -i build/_deps/ -i build/CMakeFiles/ ./${f}
    RESULTS+=$?
  done

  for r in ${RESULTS[@]}; do
    if [ $r -ne 0 ]; then
      CPPCHECK_RESULT=$r
      return
    else
      CPPCHECK_RESULT=0
    fi
  done
}

ClangTidy()
{
  echo -e "\033[0;32m\033[1mRunning Clang-tidy analysis...\033[0m"
  $(pwd)/../cmake-utils/scripts/run-clang-tidy.py -clang-tidy-binary=clang-tidy-12 -p=build/ -ignore=$(pwd)/../cmake-utils/scripts/.clang-tidy-ignore
  CLANG_TIDY_RESULT=$?
}

CheckResults()
{
  if [ $CPPCHECK_RESULT -eq 0 ]; then
    echo -e "\033[0;32m\033[1mCppCheck analysis finished successfully!\033[0m"
  else
    echo -e "\033[0;31m\033[1mFailed CppCheck analysis!\033[0m"
  fi

  if [ $CLANG_TIDY_RESULT -eq 0 ]; then
    echo -e "\033[0;32m\033[1mClang-tidy analysis finished successfully!\033[0m"
  else
    echo -e "\033[0;31m\033[1mFailed Clang-tidy analysis!\033[0m"
  fi

  if [ $CPPCHECK_RESULT -eq 1 ] || [ $CLANG_TIDY_RESULT -eq 1 ]; then
    exit 1
  else
    exit 0
  fi
}

FOLDERS=$1

CppCheck $FOLDERS
# ClangTidy
CheckResults