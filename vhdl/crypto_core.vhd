-- Copyright © Telecom Paris
-- Copyright © Renaud Pacalet (renaud.pacalet@telecom-paris.fr)
-- 
-- This file must be used under the terms of the CeCILL. This source
-- file is licensed as described in the file COPYING, which you should
-- have received as part of this distribution. The terms are also
-- available at:
-- https://cecill.info/licences/Licence_CeCILL_V2.1-en.html

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

library common;
use common.axi_pkg.all;

entity crypto_core is
  port(
    aclk:       in  std_ulogic;
    aresetn:    in  std_ulogic;
    tvalid_in:  in  std_ulogic;
    tready_in:  out std_ulogic;
    tdata_in:   in  std_ulogic_vector(31 downto 0);
    tlast_in:   in  std_ulogic;
    tvalid_out: out std_ulogic;
    tready_out: in  std_ulogic;
    tdata_out:  out std_ulogic_vector(31 downto 0);
    tlast_out:  out std_ulogic;
    key:        in  std_ulogic_vector(127 downto 0);
    nonce:      in  std_ulogic_vector(127 downto 0);
    tag:        out std_ulogic_vector(127 downto 0)
  );
end entity crypto_core;

architecture rtl of crypto_core is
begin
end architecture rtl;
