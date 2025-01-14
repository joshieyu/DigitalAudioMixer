Lock handling Library
=====================

:Version: 2.2.0
:Vendor: XMOS

Overview
--------

This library provides access to hardware and software locks for use in
concurrent C programs. In general it is not safe to use these to
marshall within XC due to the assumptions XC
makes about safe concurrent data access.

Two types of locks are provided. Hardware locks are fast and power
efficient but there are a limited number per tile. Software locks are
slower but you can use an unlimited number of them.

Software version and dependencies
.................................

The CHANGELOG contains information about the current and previous versions.
For a list of direct dependencies, look for DEPENDENT_MODULES in lib_locks/module_build_info.

Required Software (dependencies)
================================

  * None

Documentation
=============

You can find the documentation for this software in the /doc directory of the package.

Support
=======

This package is supported by XMOS Ltd. Issues can be raised against the software at: http://www.xmos.com/support
