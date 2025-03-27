MODE := work
SIM  := ghdl
GUI  := no
V    := 1

KAT_STIM := $(TOP)/build/stim.txt

ascon_pkg_sim.sim: $(KAT_STIM)
ascon_pkg_sim.sim: GHDLRFLAGS += -gkat_file_name=$(KAT_STIM)

$(KAT_STIM):
	$(MAKE) -C $(TOP) -f Makefile.kat
