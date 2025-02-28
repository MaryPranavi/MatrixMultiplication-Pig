M = LOAD '$M' USING PigStorage(',') AS (row,column,value:int);
N = LOAD '$N' USING PigStorage(',') AS (row,column,value:int);

A = JOIN M BY column FULL OUTER, N BY row;
B = FOREACH A GENERATE M::row AS r, N::column AS c, (M::value)*(N::value) AS value;
C = GROUP B BY (r, c);

result = FOREACH C GENERATE group.$0 as row, group.$1 as column, SUM(B.value) AS value;

STORE result INTO '$O' USING PigStorage(',');