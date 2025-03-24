$1 == "Count" { n += 1 }

$1 == "PT" { tmp = length($3); max_len_pt = max_len_pt < tmp ? tmp : max_len_pt }

$1 == "AD" { tmp = length($3); max_len_ad = max_len_ad < tmp ? tmp : max_len_ad }

NF { tv[n][$1] = $3 }

END {
  print "library ieee;"
  print "use ieee.std_logic_1164.all;"
  print ""
  print "package kat_pkg is"
  print ""
  print "  subtype w128_t is std_ulogic_vector(127 downto 0);"
  print "  type test_vector_t is record"
  print "    count:  natural;"
  print "    key:    w128_t;"
  print "    nonce:  w128_t;"
  print "    pt_len: natural;"
  print "    pt:     std_ulogic_vector(0 to " max_len_pt * 4 - 1 ");"
  print "    ad_len: natural;"
  print "    ad:     std_ulogic_vector(0 to " max_len_ad * 4 - 1 ");"
  print "    ct:     std_ulogic_vector(0 to " max_len_pt * 4 - 1 ");"
  print "    tag:    w128_t;"
  print "  end record;"
  print "  type test_vector_array_t is array(positive range <>) of test_vector_t;"
  print "  constant tv: test_vector_array_t(1 to " n ") := ("
  for(i = 1; i <= n; i++) {
    printf("    %d => (count => %d, ", i, tv[i]["Count"]);
    printf("key => x\"%s\", ", tv[i]["Key"])
    printf("nonce => x\"%s\", ", tv[i]["Nonce"])
    printf("pt_len => %d, ", 4 * length(tv[i]["PT"]))
    printf("ad_len => %d, ", 4 * length(tv[i]["AD"]))
    printf("tag => x\"%s\", ", substr(tv[i]["CT"], length(tv[i]["PT"]) + 1))
    tv[i]["CT"] = sprintf("%-*s", max_len_pt, substr(tv[i]["CT"], 1, length(tv[i]["PT"])))
    gsub(/ /, "0", tv[i]["CT"])
    tv[i]["PT"] = sprintf("%-*s", max_len_pt, tv[i]["PT"])
    gsub(/ /, "0", tv[i]["PT"])
    tv[i]["AD"] = sprintf("%-*s", max_len_ad, tv[i]["AD"])
    gsub(/ /, "0", tv[i]["AD"])
    printf("pt => x\"%s\", ", tv[i]["PT"])
    printf("ad => x\"%s\", ", tv[i]["AD"])
    printf("ct => x\"%s\")%s\n", tv[i]["CT"], i == n ? "" : ", ")
  }
  print "  );"
  print ""
  print "end package kat_pkg;"
}
