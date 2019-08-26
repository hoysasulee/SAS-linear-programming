/*  For 4 students */
proc optmodel;

	/* declare sets and parameters */
	set <str> STUDENTS = /A, B, C, D/;
	set <num> PROJECTS =  1..4;
 
	num cost {STUDENTS, PROJECTS} = 
		[   1, 3, 2, 4,
			2, 1, 1000, 3,
			1, 2, 3, 4, 
			4, 3, 1, 2];

	/*Define variables*/
	var Assign {STUDENTS, PROJECTS} >=0 ;
 

	/* declare constraints */
	con  maxAssign {i in STUDENTS}:  
		sum{j in PROJECTS} Assign[i,j] = 1;
	con assignjobs {j in PROJECTS}: 
		sum{i in STUDENTS} Assign[i,j] <= 1;

	/* declare objective */
	min TotalCost = sum {i in STUDENTS, j in PROJECTS} 
		cost[i,j] * Assign[i,j];
	solve;
	print 'Project Allocations';
	print {i in STUDENTS, j in PROJECTS: Assign[i,j]>0} Assign;

	print TotalCost;
quit;

