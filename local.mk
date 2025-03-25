MODE := work
SIM  := ghdl
GUI  := no
V    := 1

KAT_PKG := $(VHDL)/kat_pkg.vhd

ascon_pkg_sim.sim: $(KAT_PKG)

.PHONY: $(KAT_PKG)

$(KAT_PKG):
	$(MAKE) -C $(TOP) -f Makefile.kat
