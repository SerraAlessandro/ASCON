$1 == "Count" { n += 1 }
NF { tv[n][$1] = $3 }
END {
	for(i = 1; i <= n; i++) {
		tv[i]["Tag"] = substr(tv[i]["CT"], length(tv[i]["CT"]) - 31)
		tv[i]["CT"] = substr(tv[i]["CT"], 1, length(tv[i]["CT"]) - 32)
		printf("%d %s %s %d %s %d %s %s %s\n", tv[i]["Count"], tv[i]["Key"], tv[i]["Nonce"], length(tv[i]["PT"]), tv[i]["PT"], length(tv[i]["AD"]), tv[i]["AD"], tv[i]["CT"], tv[i]["Tag"])
	}
}
