# This variable should contain a space separated list of all
# the directories containing buildable applications (usually
# prefixed with the app_ prefix)
BUILD_SUBDIRS = ./examples/app_adat_loopback ./examples/app_adat_tx_example \
	./examples/app_adat_rx_example examples/app_adat_tx_direct_example

# This variable should contain a space separated list of all
# the directories containing buildable plugins (usually
# prefixed with the plugin_ prefix)
PLUGIN_SUBDIRS =

# This variable should contain a space separated list of all
# the directories containing applications with a 'test' make target
TEST_SUBDIRS =

# Provided that the above variables are set you shouldn't need to modify
# the targets below here.

%.all:
	cd $* && xmake all

%.clean:
	cd $* && xmake clean

%.test:
	cd $* && xmake test

all: $(foreach x, $(BUILD_SUBDIRS), $x.all)
plugins: $(foreach x, $(PLUGIN_SUBDIRS), $x.all)
clean: $(foreach x, $(BUILD_SUBDIRS), $x.clean)
clean_plugins: $(foreach x, $(PLUGIN_SUBDIRS), $x.clean)
test: $(foreach x, $(TEST_SUBDIRS), $x.test)
