/* the (i,j)-th entry of m-by-n matrix A
 in C notation is A[ (j-1)*n + i-1]  */

#include <stdlib.h>
#include <math.h>
#include "matrix.h"
#include "mex.h"

#include "graphtypes.h"
/* #include "wmatch.c" */

/* Input Arguments */
#define	W_IN	prhs[0]

/* Output Arguments */
#define	MATE_OUT	plhs[0]


/* main function */
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{ 
    Graph graph;
	int i, j, n1, n2, n, *Mate, uu, vv;
	double *pW, wij;
    double *pM;


	/* Check for proper number of arguments */
    if (nrhs != 1) { 
	    mexErrMsgIdAndTxt( "MATLAB:max_wmatch:invalidNumInputs",
                "One input, the weight-matrix, required."); 
    } 
    else if (nlhs > 1) {
	    mexErrMsgIdAndTxt( "MATLAB:max_wmatch:maxlhs",
                "Too many output arguments."); 
    } 
    
    /* check dimension of input */
    n1 = mxGetM(W_IN);
	n2 = mxGetN(W_IN);
	if ( n1 != n2){
		 mexErrMsgIdAndTxt( "MATLAB:max_wmatch:invalidY",
                " max_wmatch require square weight matrix."); 
	} 
	n = n1;
	
    /* Create a matrix for the return argument */ 
    MATE_OUT = mxCreateDoubleMatrix( (mwSize)n, (mwSize)1, mxREAL);
    
    /* Assign pointers to the various parameters */ 
    pM = (double*) mxGetPr(MATE_OUT);
    pW = (double*) mxGetPr(W_IN);
    

	/* build graph from the input weight matrix*/
		
	/* copy the code from ReadGraph function in glib.c */
	
	graph = NewGraph( n );
	for (i = 1; i <= n; i++ ) {
		/* complete graph */
	
		for (j = i+1; j<=n ; j++){
			wij = pW[ (j-1)*n + i-1] ;
            AddEdge (graph, i, j, wij); /* 11/02/14 can only handle positive integer weight */
            
            /* mexPrintf("%d %d, wij=%d\n", i, j, (int)wij); */
		}
				
		/*
		for (j = 1; j <= degree; ++j) {
			fscanf(fp,"%d%d", &adj_node, &elabel);
			while (getc(fp)!='\n') ;
			if (i < adj_node)
				AddEdge (graph,i,adj_node,elabel);
			}
		*/
		}
    
	/* compute the mate */
    Mate = Weighted_Match(graph, 1, 1);

/*
  for (i=1; i<=n ; i++)
		mexPrintf("%d %d\n", i, Mate[i]);
*/    
    for( i=1; i<=n; i++)
        pM[i-1] = (double) Mate[i];
    
    FreeUp();
    FreeGraph(graph, n); /*free the nodes and graph, to stop memory leak */
    
    return;
    
}





