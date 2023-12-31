function(run_clang_format FOLDERS)
  set(MAIN_DIR ${PARENT_DIRECTORY})
  foreach(DIR ${FOLDERS})
    message("Running clang-format on ${DIR} folder")
    execute_process(COMMAND python ${cmake-utils_SOURCE_DIR}/scripts/run-clang-format.py --clang-format-executable clang-format-12 -r ${MAIN_DIR}/${DIR} -i --style Google)
  endforeach()
endfunction()
