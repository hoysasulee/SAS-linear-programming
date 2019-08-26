/*Assignment 1 question 1 part 1 (Adapted from Kexiang Huang 18035793)*/

proc optmodel;
	/* declare sets and parameters */
	set <str> RESOURCES  = /wheat barley soyabean/;
	set <str> PRODUCTS = /Sweetmix Proteinrich/;
	num profit {PRODUCTS} = [1.5 3];
	num availability {RESOURCES} = [100 250 50];
	num required {PRODUCTS, RESOURCES} = [
		0.5 0.4 0.1
		0.25 0.5 0.25
		];

	/* declare variables */
	var NumProd {PRODUCTS} >= 0;
	impvar AmountUsed {r in RESOURCES} = 
		sum {p in PRODUCTS} NumProd[p] * required[p,r];
	impvar PercentUtilization {r in RESOURCES} = ( AmountUsed[r] / availability[r] );

	/* declare constraints */
	con Usage {r in RESOURCES}: 
		AmountUsed[r] <= availability[r];

	/* declare objective */
	max NetProfit = sum {p in PRODUCTS}
		profit[p] * NumProd[p];

	/*Print LP formulation*/
	expand NetProfit;
	expand / var impvar;

	/*Solve LP*/
	solve with lp / algorithm=ps logfreq=1;
	print 'Profit:' (NetProfit) dollar.;
	print 'Production Plan'  {i in PRODUCTS: NumProd[i]>0} NumProd;
	print 'Resouce Usage:' AmountUsed 
		Availability 
		PercentUtilization percent7.1
		Usage.dual;
 
quit;

/*Assignment 1 question 1 part 2 (Adapted from Kexiang Huang 18035793)*/

proc optmodel;
 set RESOURCES = / wheat barley soyabean maize/;
 set PRODUCTS = / sweetmix proteinrich firstfeed/;
 set NUTRITIONS = / Carbohydrate Protein/;
 num selling_price {PRODUCTS} = [1.84 3.45 2.50];
 num availability {RESOURCES} = [100 250 50 550];
 num cost{RESOURCES} = [0.2 0.4 0.8 0.5];
 num contents {NUTRITIONS,RESOURCES} = [0.8 0.8 0.5 0.6
 										0.05 0.1 0.25 0.1];

/* make desition variables*/
 var comproduct{PRODUCTS, RESOURCES} >= 0;

 impvar NumProd {p in PRODUCTS} = sum{r in RESOURCES} comproduct[p,r];
 impvar AmountUsed{r in RESOURCES} = sum{p in PRODUCTS} comproduct[p,r];
 impvar Revenue = sum{p in PRODUCTS} NumProd[p] * selling_price[p];
 impvar TotalCost = sum{r in RESOURCES} AmountUsed[r] * cost[r];
 impvar Carbohydrate{p in PRODUCTS} = sum {r in RESOURCES} comproduct[p,r] * contents['Carbohydrate',r];
 impvar Protein{p in PRODUCTS} = sum {r in RESOURCES} comproduct[p,r] * contents['Protein',r];
 impvar productcomp{p in PRODUCTS, r in resources} = comproduct[p,r] / NumProd[p];
 impvar CarbohydratePercentage {p in PRODUCTS} = Carbo[p] / NumProd[p];
 impvar ProteinPercentage {p in PRODUCTS} = Protein[p] / NumProd[p];

/* Objective function*/
 max Profit = Revenue - TotalCost;

/* Setup Constainst*/
 con Usage{r in RESOURCES}: AmountUsed [r] <= availability[r];
 con NumProd['firstfeed'] = 50;
 con Carbohydrate['sweetmix']  >= 0.7*NumProd['sweetmix'];
 con  NumProd['sweetmix']*0.05 <= Protein['sweetmix'] ;
 con  Protein['sweetmix']<= 0.3*NumProd['sweetmix'];
 con Carbohydrate['proteinrich']  >= 0.6*NumProd['proteinrich'];
 con 0.15*NumProd['proteinrich'] <= Protein['proteinrich'] ;
 con Protein['proteinrich']  <= 0.4*NumProd['proteinrich'];
 con Carbohydrate['firstfeed']  >= 0.6* NumProd['firstfeed'];
 con 0.1 * NumProd['firstfeed'] <= Protein['firstfeed'] ;
 con  Protein['firstfeed'] <= 0.15* NumProd['firstfeed'];
 solve;

 print 'Profit:' Profit dollar8.2;
 print 'Product receip:' productcomp percent7.2 ;
 print 'Nutritionl list:' CarbohydratePercentage percent5.2 ProteinPercentage percent5.2;
 print 'Product contains:' comproduct;
 print 'Production Plan:' NumProd;
 print 'Useage of Resources and reduced cost:' availability AmountUsed Usage.dual Usage.status;
 print _VAR_.name _var_  _VAR_.rc _var_.status  _VAR_.lb _VAR_.ub _VAR_.sol;
 print _CON_.name _CON_.body  _CON_.lb _CON_.ub _CON_.dual _CON_.status;


