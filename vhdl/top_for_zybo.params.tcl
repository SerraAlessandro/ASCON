#
# Copyright © Telecom Paris
# Copyright © Renaud Pacalet (renaud.pacalet@telecom-paris.fr)
# 
# This file must be used under the terms of the CeCILL. This source
# file is licensed as described in the file COPYING, which you should
# have received as part of this distribution. The terms are also
# available at:
# https://cecill.info/licences/Licence_CeCILL_V2.1-en.html
#

# edit the following assignments to declare the target clock frequency, the
# list of VHDL source files, the IO ports and any other relevant parameter

# target clock frequency (MHz)
set f_mhz 100

# list of design units: FILE LIBRARY (paths relative to vhdl/)
array set dus {
    common/axi_pkg.vhd     common
    common/fifo.vhd        common
    axi_lite_interface.vhd work
    ASCON_fsm.vhd	   work
    axi_stream_master.vhd  work
    axi_stream_slave.vhd   work
    crypto_core.vhd        work
    dma_in.vhd             work
    dma_out.vhd            work
    top_for_zybo.vhd       work
}

# list of external ports: NAME { PIN IO_STANDARD }
array set ios {
}

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0:
