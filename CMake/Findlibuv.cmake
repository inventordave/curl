#***************************************************************************
#                                  _   _ ____  _
#  Project                     ___| | | |  _ \| |
#                             / __| | | | |_) | |
#                            | (__| |_| |  _ <| |___
#                             \___|\___/|_| \_\_____|
#
# Copyright (C) Daniel Stenberg, <daniel@haxx.se>, et al.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at https://curl.se/docs/copyright.html.
#
# You may opt to use, copy, modify, merge, publish, distribute and/or sell
# copies of the Software, and permit persons to whom the Software is
# furnished to do so, under the terms of the COPYING file.
#
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
# KIND, either express or implied.
#
# SPDX-License-Identifier: curl
#
###########################################################################
# Find the libuv library
#
# Result Variables:
#
# LIBUV_FOUND         System has libuv
# LIBUV_INCLUDE_DIRS  The libuv include directories
# LIBUV_LIBRARIES     The libuv library names
# LIBUV_VERSION       Version of libuv

if(CURL_USE_PKGCONFIG)
  find_package(PkgConfig QUIET)
  pkg_check_modules(LIBUV "libuv")
endif()

if(LIBUV_FOUND)
  set(LIBUV_LIBRARIES ${LIBUV_LINK_LIBRARIES})
else()
  find_path(LIBUV_INCLUDE_DIR "uv.h")
  find_library(LIBUV_LIBRARY NAMES "uv" "libuv")

  if(LIBUV_INCLUDE_DIR)
    if(EXISTS "${LIBUV_INCLUDE_DIR}/uv/version.h")
      set(_version_regex_major "^#define[ \t]+UV_VERSION_MAJOR[ \t]+([0-9]+).*")
      set(_version_regex_minor "^#define[ \t]+UV_VERSION_MINOR[ \t]+([0-9]+).*")
      set(_version_regex_patch "^#define[ \t]+UV_VERSION_PATCH[ \t]+([0-9]+).*")
      file(STRINGS "${LIBUV_INCLUDE_DIR}/uv/version.h" _version_major REGEX "${_version_regex_major}")
      file(STRINGS "${LIBUV_INCLUDE_DIR}/uv/version.h" _version_minor REGEX "${_version_regex_minor}")
      file(STRINGS "${LIBUV_INCLUDE_DIR}/uv/version.h" _version_patch REGEX "${_version_regex_patch}")
      string(REGEX REPLACE "${_version_regex_major}" "\\1" _version_major "${_version_major}")
      string(REGEX REPLACE "${_version_regex_minor}" "\\1" _version_minor "${_version_minor}")
      string(REGEX REPLACE "${_version_regex_patch}" "\\1" _version_patch "${_version_patch}")
      unset(_version_regex_major)
      unset(_version_regex_minor)
      unset(_version_regex_patch)
      set(LIBUV_VERSION "${_version_major}.${_version_minor}.${_version_patch}")
      unset(_version_major)
      unset(_version_minor)
      unset(_version_patch)
    else()
      set(LIBUV_VERSION "0.0")
    endif()
  endif()

  set(LIBUV_INCLUDE_DIRS ${LIBUV_INCLUDE_DIR})
  set(LIBUV_LIBRARIES    ${LIBUV_LIBRARY})

  mark_as_advanced(LIBUV_INCLUDE_DIR LIBUV_LIBRARY)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(libuv
  REQUIRED_VARS
    LIBUV_INCLUDE_DIRS
    LIBUV_LIBRARIES
  VERSION_VAR
    LIBUV_VERSION
)