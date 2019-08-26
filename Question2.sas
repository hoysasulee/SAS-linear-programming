proc optmodel;
	/* declare sets and parameters */
	set <str> Ports = /Auckland Tauranga Christchurch /;
	set <str> Plants = /Napier PalmerstonNorth Invercargill/;
	num supply {Ports} = [50 100 50];
	num demand {Plants} = [80 90 100];
	num cost {Ports, Plants} = 
		[75	60	69
		79	73	68
		85	76	70
	];

	/*Define variables*/
	var NumShip {Ports, Plants} >= 0;
	impvar FlowOut {i in Ports} = 
		sum {j in Plants} NumShip[i,j];
	impvar FlowIn {j in Plants} = 
		sum {i in Ports} NumShip[i,j];

	/* declare constraints */
	con Supply_con {i in Ports}:  
		FlowOut[i] = supply[i];
	con Demand_con {j in Plants}: 
		FlowIn[j] <= demand[j];
	con NumShip['Auckland','Invercargill'] = 0;
	con NumShip['Tauranga','Invercargill'] = 0;
	con NumShip['Christchurch','Napier'] = 0;
	con NumShip['Christchurch','PalmerstonNorth'] = 0;


	/* declare objective */
	min TotalCost = sum {i in Ports, j in Plants} 
		cost[i,j] * NumShip[i,j];


	/* Solve LP*/
	solve;
	print 'Shipments Quantities';
	reset options pmatrix=2;
    print NumShip;



	/*	Sensitivity Analysis*/
	/*Reduced cost = change in cost required for variable to enter the basis	*/
	print _VAR_.name _var_ _VAR_.rc _var_.status  _VAR_.lb _VAR_.ub _VAR_.sol;

	/*Dual value = change in the objective function value from a 1 unit change in the constraint RHS	*/
	print _CON_.name _CON_.body _CON_.lb _CON_.ub _CON_.dual _CON_.status;
quit;



