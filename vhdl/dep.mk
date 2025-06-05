ascon_sim_pkg: ascon_pkg
ascon_pkg_sim: ascon_pkg ascon_sim_pkg
dma_in: axi_pkg fifo
dma_in_sim: axi_pkg rnd_pkg utils_pkg soft_fifo_pkg dma_in
dma_in_axi_sim: axi_pkg rnd_pkg utils_pkg soft_fifo_pkg axi_lite_slave dma_in
dma_out: axi_pkg fifo
dma_out_sim: axi_pkg rnd_pkg utils_pkg soft_fifo_pkg dma_out
fifo_sim: rnd_pkg utils_pkg soft_fifo_pkg fifo
ascon_fsm: ascon_pkg
tb_ascon_fsm: ascon_pkg ascon_fsm
crypto_core: ascon_fsm axi_stream_slave axi_stream_master
axi_lite_interface: axi_pkg
top_for_zybo: dma_in dma_out axi_lite_interface crypto_core
top_for_zybo_sim: axi_pkg rnd_pkg utils_pkg axi_memory top_for_zybo
