*** Programm to generate data for RD graphs with polynomial fit

capture program drop rd_graphs
	program rd_graphs 
	syntax [, outcome(string) poly_order(string)]
	
	if `poly_order'==2|`poly_order'==3 {
		gen x1=inc_distance
		gen x2=x1^2
		gen post=(x1>0)
		gen post_x1=post*x1
		gen post_x2=post*x2
	}
	if `poly_order'==3 {
		gen x3=x1^3
		gen post_x3=post*x3	
	}
	
	if `poly_order'==2 {
		qui reg `outcome' x1 x2 post_x1 post_x2 post
	}
	if `poly_order'==3 {
		qui reg `outcome' x1 x2 x3 post_x1 post_x2 post_x3 post
	}	

	collapse `outcome', by(inc_distance_bin)
	global new = _N + 1
	set obs $new
	replace inc_distance_bin=0 if _n==$new
	sort inc_distance_bin

	if `poly_order'==2|`poly_order'==3 {
		gen x1=inc_distance
		gen x2=x1^2
		gen post=(x1>0)
		gen post_x1=post*x1
		gen post_x2=post*x2
	}
	if `poly_order'==3 {
		gen x3=x1^3
		gen post_x3=post*x3	
	}

	predict p`poly_order'_l if inc_distance_bin<=0

	if `poly_order'==2 {
		cap drop post post_x1 post_x2
	}
	if `poly_order'==3 {
		cap drop post post_x1 post_x2 post_x3
	}	

	if `poly_order'==2|`poly_order'==3 {
		gen post=(x1>=0)
		gen post_x1=post*x1
		gen post_x2=post*x2
	}
	if `poly_order'==3 {
		gen post_x3=post*x3	
	}		

	predict  p`poly_order'_r if inc_distance_bin>=0

end
