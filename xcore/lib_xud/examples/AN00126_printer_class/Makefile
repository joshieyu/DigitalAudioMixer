# The APP_NAME variable determines the name of the final .xe file. It should
# not include the .xe postfix. If left blank the name will default to
# the project name

APP_NAME = app_printer_demo

# The flags passed to xcc when building the application
# You can also set the following to override flags for a particular language:
#
#    XCC_XC_FLAGS, XCC_C_FLAGS, XCC_ASM_FLAGS, XCC_CPP_FLAGS
#
# If the variable XCC_MAP_FLAGS is set it overrides the flags passed to
# xcc for the final link (mapping) stage.

BUILD_FLAGS = -O3 -report -DUSE_XSCOPE=1 -fxscope

XCC_FLAGS_200 = $(BUILD_FLAGS)
XCC_FLAGS_AI = $(BUILD_FLAGS)

# The TARGET variable determines what target system the application is
# compiled for. It either refers to an XN file in the source directories
# or a valid argument for the --target option when compiling.

ifeq ($(CONFIG),AI)
TARGET = XCORE-AI-EXPLORER
else
TARGET = XCORE-200-EXPLORER
endif

# The USED_MODULES variable lists other module used by the application.

USED_MODULES = lib_xud lib_logging

#=============================================================================
# The following part of the Makefile includes the common build infrastructure
# for compiling XMOS applications. You should not need to edit below here.

XMOS_MAKE_PATH ?= ../..
include $(XMOS_MAKE_PATH)/xcommon/module_xcommon/build/Makefile.common
