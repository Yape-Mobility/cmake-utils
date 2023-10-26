set(CLANG_WARNINGS
    -Wall
    -Wextra
    -Wshadow
    -Wnon-virtual-dtor
    -Wold-style-cast
    -Wcast-align
    -Wunused
    -Woverloaded-virtual
    -Wpedantic
    -Wconversion
    -Wno-sign-conversion
    -Wnull-dereference
    -Wdouble-promotion
    -Wformat=2
    -Wimplicit-fallthrough
    -Wreturn-type
    -Werror
)

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(BUILD_FLAGS_FOR_CXX "${CLANG_WARNINGS}")
else()
  message(AUTHOR_WARNING "No compiler warnings set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
endif()
