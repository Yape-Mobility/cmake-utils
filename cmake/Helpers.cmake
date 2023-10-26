function(create_shared_library TARGET_NAME SOURCE_FILES PUBLIC_LINK_LIB PRIVATE_LINK_LIB)
    add_library(${TARGET_NAME} SHARED ${SOURCE_FILES})
    target_compile_options(${TARGET_NAME}
        PRIVATE
            $<$<COMPILE_LANGUAGE:CXX>:${BUILD_FLAGS_FOR_CXX}>
    )
    target_compile_features(${TARGET_NAME} PUBLIC cxx_std_20)
    target_include_directories(${TARGET_NAME} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    )
    target_link_libraries(${TARGET_NAME}
        PUBLIC
            ${PUBLIC_LINK_LIB}
        PRIVATE
            ${PRIVATE_LINK_LIB}
    )
endfunction()

function(create_shared_library_with_custom_include_dirs TARGET_NAME SOURCE_FILES INCLUDE_DIRS PUBLIC_LINK_LIB PRIVATE_LINK_LIB)
    add_library(${TARGET_NAME} SHARED ${SOURCE_FILES})
    target_compile_options(${TARGET_NAME}
        PRIVATE
            $<$<COMPILE_LANGUAGE:CXX>:${BUILD_FLAGS_FOR_CXX}>
    )
    target_compile_features(${TARGET_NAME} PUBLIC cxx_std_20)
    target_include_directories(${TARGET_NAME} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        ${INCLUDE_DIRS}
        $<INSTALL_INTERFACE:include>
    )
    target_link_libraries(${TARGET_NAME}
        PUBLIC
            ${PUBLIC_LINK_LIB}
        PRIVATE
            ${PRIVATE_LINK_LIB}
    )
endfunction()

function(create_interface_library TARGET_NAME)
    add_library(${TARGET_NAME} INTERFACE)
    target_compile_options(${TARGET_NAME}
        INTERFACE
            $<$<COMPILE_LANGUAGE:CXX>:${BUILD_FLAGS_FOR_CXX}>
    )
    target_compile_features(${TARGET_NAME} INTERFACE cxx_std_20)
    target_include_directories(${TARGET_NAME} INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    )
endfunction()

function(install_and_export_targets_and_config TARGETS_TO_INSTALL EXPORT_NAME CMAKE_CONFIG_NAME)
    install(TARGETS ${TARGETS_TO_INSTALL}
        EXPORT ${EXPORT_NAME}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
    )

    install(DIRECTORY include/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/include/
    )

    install(EXPORT ${EXPORT_NAME}
        FILE ${CMAKE_CONFIG_NAME}Targets.cmake
        NAMESPACE ${EXPORT_NAME}::
        DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/${EXPORT_NAME}
    )

    install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/${CMAKE_CONFIG_NAME}Config.cmake
        DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/${EXPORT_NAME}
    )

    export(EXPORT ${EXPORT_NAME}
        FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/cmake/${CMAKE_CONFIG_NAME}Config.cmake
        NAMESPACE ${EXPORT_NAME}::
    )

    export(PACKAGE ${EXPORT_NAME})
endfunction()

function(compile_google_test TEST_NAME TEST_LIBS)
    find_package(gflags REQUIRED)
    find_package(GTest REQUIRED)

    add_executable(${TEST_NAME} ${TEST_NAME}.cpp)
    target_link_libraries(${TEST_NAME}
        PRIVATE
            ${TEST_LIBS}
            GTest::gtest_main
            gflags
            glog
    )
    target_compile_options(${TEST_NAME}
        INTERFACE
            $<$<COMPILE_LANGUAGE:CXX>:${BUILD_FLAGS_FOR_CXX}>
    )
    target_compile_features(${TEST_NAME} INTERFACE cxx_std_20)

    target_compile_definitions(${TEST_NAME} PRIVATE TESTS_DIR="${CMAKE_CURRENT_SOURCE_DIR}")
    add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
endfunction()
