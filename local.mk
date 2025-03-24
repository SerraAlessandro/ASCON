MODE := work
SIM  := ghdl
GUI  := no
V    := 1

C := C
BUILD := $(TOP)/build
SCRIPTS := $(TOP)/scripts
KAT_TO_VHDL := $(SCRIPTS)/kat_to_vhdl.awk
KAT_FILE := $(BUILD)/LWC_AEAD_KAT_128_128.txt
KAT_PKG := $(VHDL)/kat_pkg.vhd

$(KAT_PKG): $(KAT_TO_VHDL) $(KAT_FILE)
	awk -f $< $(KAT_FILE) > $@

$(KAT_FILE): | $(BUILD)
	git submodule init
	git submodule update
	cmake -S $(C) -B $(BUILD) -DALG_LIST="asconaead128" -DIMPL_LIST="ref" -DTEST_LIST="genkat"
	cmake --build $(BUILD)
	ctest --test-dir $(BUILD)

ascon_pkg_sim.sim: $(KAT_PKG)

$(BUILD):
	mkdir -p build
