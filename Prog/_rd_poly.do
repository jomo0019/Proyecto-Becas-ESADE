*** Program to run parametric estimation (split polynomial approximation)

* Requires rdob_m.ado (slightly modified version of rdob.ado (available at http://faculty-gsb.stanford.edu/imbens/documents/rdob.zip)

capture program drop rd_poly
	program rd_poly
	
	global coeff
	global se
	global tstat
	global pvalue
	global significance	
	
	if `1'==2  {
		cap drop x1 x2 post_x1 post_x2 post
		gen x1=-inc_distance
		gen x2=x1^2
		gen post=(x1>=0)
		gen post_x1=x1*post
		gen post_x2=x2*post
		local regressors x1 x2 post_x1 post_x2 post
	}	
	if `1'==3  {
		cap drop x1 x2 x3 post_x1 post_x2 post_x3 post
		gen x1=-inc_distance
		gen x2=x1^2
		gen x3=x1^3
		gen post=(x1>=0)
		gen post_x1=x1*post
		gen post_x2=x2*post	
		gen post_x3=x3*post	
		local regressors x1 x2 x3 post_x1 post_x2 post_x3 post
	}	
	if `1'==4  {
		cap drop x1 x2 x3 x4 post_x1 post_x2 post_x3 post_x4 post
		gen x1=-inc_distance
		gen x2=x1^2
		gen x3=x1^3
		gen x4=x1^4
		gen post=(x1>=0)
		gen post_x1=x1*post
		gen post_x2=x2*post	
		gen post_x3=x3*post	
		gen post_x4=x4*post	
		local regressors x1 x2 x3 x4 post_x1 post_x2 post_x4 post_x4 post
	}	
	
	qui reg `2' `regressors', robust
	local tstat = abs(_b[post]/_se[post])
	local pvalue = 2*ttail(e(df_r),abs(`tstat'))

	if `pvalue'>=0 & `pvalue'<=0.01  {
		local significance "***"
	}
	if `pvalue'>0.01 & `pvalue'<=0.05  {
		local significance "**"
	}
	if `pvalue'>0.05 & `pvalue'<=0.10  {
		local significance "*"
	}
	if `pvalue'>0.10 {
		local significance ""
	}

	global bandwidth=$full_bw
	global coeff =_b[post]
	global se = _se[post]
	global tstat `tstat'
	global pvalue `pvalue'
	global significance `significance'
	global nobs = e(N)

	
end
