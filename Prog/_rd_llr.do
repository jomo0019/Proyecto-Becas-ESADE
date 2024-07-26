*** Program to run non-parametric estimation (local linear regression with optimal bandwidth)

* Requires rdob_m.ado (slightly modified version of rdob.ado (available at http://faculty-gsb.stanford.edu/imbens/documents/rdob.zip)

capture program drop rd_llr
	program rd_llr
	
	global bwd
	global coeff
	global se
	global tstat
	global pvalue
	global significance
	
	gen x=-inc_distance
		
	if missing("`2'") {
		rdob_m `1' x, c(0)
	}
	else {
		rdob_m `1' x, c(0) bw(`2')
	}
	
	global pvalue = 2*(1-normal(abs(${tstat}))) 
	
	if $pvalue>=0 & $pvalue<=0.01  {
		local significance "***"
	}
	if $pvalue>0.01 & $pvalue<=0.05  {
		local significance "**"
	}
	if $pvalue>0.05 & $pvalue<=0.10  {
		local significance "*"
	}
	if $pvalue>0.10 {
		local significance ""
	}

	global bandwidth = $bwd
	global significance `significance'
	
end
