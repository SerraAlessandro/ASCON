ascon_pkg_sim: ascon_sim_pkg
dma_in: axi_pkg fifo
dma_in_sim: axi_pkg rnd_pkg utils_pkg soft_fifo_pkg dma_in
dma_out: axi_pkg fifo
dma_out_sim: axi_pkg rnd_pkg utils_pkg soft_fifo_pkg dma_out
fifo_sim: rnd_pkg utils_pkg soft_fifo_pkg fifo
top_for_zybo: dma_in dma_out axi_lite_interface crypto_core
