sets  i   sectors / 1 * 10 /
      j   sites  / 1 * 5/;

parameters

yc(j) capacity of site j /
$include   capacities.dat
/

rx(i) requirement of sector i /
$include   rx.dat
/

Table dist(i,j) "distances of sectors to sites"
          1      2      3     4     5
    1    3.4    1.4    4.9   7.4   9.3          
    2    2.4    2.1    8.3   9.1   8.8           
    3    1.4    2.9    3.7   9.4   8.6           
    4    2.6    3.6    4.5   8.2   8.9              
    5    1.5    3.1    2.1   7.9   8.8 
    6    4.2    4.9    6.5   7.7   6.1
    7    4.8    6.2    9.9   6.2   5.7
    8    5.4    6.0    5.2   7.6   4.9
    9    3.1    4.1    6.6   7.5   7.2
    10   3.2    6.5    7.1   6.0   8.3
    
;


Variables
         X(i,j)    if sector i is going to site j
         Z         total cost;
*Y(j)       if we increase capacity of site j
binary variable X;

equations constraint(i)     assignment of each sector
          cap(j)            capacity of each site
          cost              definition of total cost;

*constraint1     extra capacity        
*constraint1 ..  sum(j,Y(j)) =l= 1; Uncomment for capacity expansion calculation.

constraint(i) ..   sum(j, x(i,j))  =e=  1 ; 

cap(j)..         sum(i, rx(i)*x(i,j)) =l= yc(j);

cost..            Z =e= sum(i, rx(i)*1000*0.1*sum(j, dist(i,j)*x(i,j)));

model UFLP / all /;

UFLP.optcr = 0.0 ;

option rmip=cplex;
option mip=cplex;

*solve UFLP using rmip minimizing Z;
solve UFLP using mip minimizing Z;
display X.L
