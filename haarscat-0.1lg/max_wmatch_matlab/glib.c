#include "graphtypes.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int AddEdge (g,n,m,label)
Graph g;
int n,m;
double label;

{	Edge edge1,edge2;

	edge1 = (Edge) malloc( 2*sizeof(struct edge_ent)); /* to free */
	edge2 = edge1 + 1;

	edge1->label = label;
	edge1->endpoint = m;
	edge1->otheredge = edge2;
	edge1->prevedge = NULL;
	edge1->nextedge = g[n].adj_list;
	if (edge1->nextedge != NULL)
		edge1->nextedge->prevedge = edge1;
	g[n].adj_list = edge1;
	g[n].degree++;

	edge2->label = label;
	edge2->endpoint = n;
	edge2->otheredge = edge1;
	edge2->prevedge = NULL;
	edge2->nextedge = g[m].adj_list;
	if (edge2->nextedge != NULL)
		edge2->nextedge->prevedge = edge2;
	g[m].adj_list = edge2;
	g[m].degree++;
    return(1);
}

Edge FindEdge(graph,i,j)
Graph graph;
int i,j;

{	Edge edge;

	edge = graph[i].adj_list;
	while (edge!=NULL && edge->endpoint!=j)
		edge = edge->nextedge;
	if (edge==NULL) return(NULL);
	else return(edge);
}

int RemoveEdge(graph,edge)
Graph graph;
Edge edge;

{	Edge other;
	int i,j;

	if (edge==NULL) return(0);
	other = edge->otheredge;
	i = other->endpoint;
	j = edge->endpoint;
	graph[i].degree--; graph[j].degree--;
	if (edge->prevedge == NULL) {
		graph[i].adj_list = edge->nextedge;
		if (edge->nextedge != NULL)
			edge->nextedge->prevedge = NULL;
		}
	else if (edge->nextedge == NULL)
        	(edge->prevedge)->nextedge = NULL;
	else {
		(edge->nextedge)->prevedge = edge->prevedge;
		(edge->prevedge)->nextedge = edge->nextedge;
		}
	if (other->prevedge == NULL) {
		graph[j].adj_list = other->nextedge;
		if (other->nextedge != NULL)
			other->nextedge->prevedge = NULL;
		}
	else if (other->nextedge == NULL)
		(other->prevedge)->nextedge = NULL;
	else {
		(other->nextedge)->prevedge = other->prevedge;
		(other->prevedge)->nextedge = other->nextedge;
		}
	free((edge < other) ? edge : other);
    
	return(1);
}

int NumEdges(g)
Graph g;
{	int i,size,edges;

	edges = 0;
	size = Degree(g,0);
	for (i=1; i<=size; i++)
		edges += Degree(g,i);
	edges /= 2;
	return(edges);
}

Graph NewGraph(size)
int size;
{	Graph tmp;
	int i;

	tmp = (Graph) malloc((size+1)*sizeof(struct node_entry)); /* to free */
	for (i=1; i<=size; i++) {
		Degree(tmp,i) = 0;
		FirstEdge(tmp,i) = NULL;
		NLabel(tmp,i) = i;
		}
	Degree(tmp,0) = size;
	return(tmp);
}

EuclidGraph NewEuclid(size)
int size;
{
	EuclidGraph xy;

	xy = (EuclidGraph) malloc((size+1)*2*sizeof(int));
	xy[0][0] = size;
	return(xy);
}

MatrixGraph NewMatrix(size)
int size;
{
	MatrixGraph graph;
	int i;

	graph = (MatrixGraph) malloc((size*(size+1)+1)*sizeof(int));
	graph[0] = size;

	for (i=1; i<=size; i++)		/* zero the diagonal */
		graph[i*(size+1)] = 0;

	return(graph);
}

Graph CopyGraph(g)
Graph g;
{	int i,j,size;
	Edge edge;
	Graph cp;

	size = Degree(g,0);
	cp = NewGraph(size);
	for (i=1; i<=size; i++) {
		Xcoord(cp,i) = Xcoord(g,i);
		Ycoord(cp,i) = Ycoord(g,i);
		edge = FirstEdge(g,i);
		for (j=1; j<=Degree(g,i); j++) {
			if (i < EndPoint(edge))
				AddEdge(cp,i,EndPoint(edge),ELabel(edge));
			edge = NextEdge(edge);
			}
		}
	return (cp);
}

/* Graph I/O routines */

Graph ReadGraph (size,file)
int *size;
char file[];

{	Graph graph;
	FILE *fp;
 	char c;
	int edges, degree, vlabel, adj_node, i, j;
    double elabel;
	int xcoord, ycoord;

	if (file[0] == '\0') fp = stdin;
	else fp = fopen(file,"r");
	if (fp==NULL) {
		printf("ReadGraph: file %s can't be opened\n",file);
		exit(0);
		}
	fscanf(fp,"%d%d %c",size,&edges,&c);
	if (c !='U' && c!='u') {
		printf("ReadGraph: file %s does not contain an undirected graph\n",file);
		exit(0);
		}
	while (getc(fp)!='\n') ;

	graph = NewGraph(*size);
	for (i = 1; i <= *size; ++i) {
		fscanf(fp,"%d%d%d%d",&degree,&vlabel,&xcoord,&ycoord);
		NLabel(graph,i) = vlabel;
		Xcoord(graph,i) = xcoord;
		Ycoord(graph,i) = ycoord;
		while (getc(fp)!='\n') ;
		for (j = 1; j <= degree; ++j) {
			fscanf(fp,"%d%lf", &adj_node, &elabel); /* to scan double value to elabel*/
            /* printf("readgraph: %d, %d, w=%4.2f \n", i, adj_node, elabel); */
			while (getc(fp)!='\n') ;
			if (i<adj_node)
				AddEdge (graph,i,adj_node,elabel);
			}
		}
	fclose(fp);
	return(graph);
}

/*
WriteGraph (graph,file)
Graph graph;
char file[];

{	FILE *fp;
	int size, i,j,edges;
	Edge p;

	if (file[0] == '\0') fp = stdout;
	else fp = fopen(file,"w");
	if (fp==NULL) {
		printf("WriteGraph: file %s can't be opened\n",file);
		exit(0);
		}
	size = Degree(graph,0);
	edges = NumEdges(graph);
	fprintf(fp,"%d %d U\n",size,edges);

	for (i = 1; i <= size; i++) {
		fprintf(fp,"%d %f %d %d L\n",Degree(graph,i),NLabel(graph,i),
					   Xcoord(graph,i),Ycoord(graph,i));
		p = FirstEdge(graph,i);
		for (j = 1; j <= Degree(graph,i); ++j) {
			fprintf(fp,"%d %f L\n",EndPoint(p),ELabel(p));
			p = NextEdge(p);
			}
		}
	fclose(fp);
}

 */

EuclidGraph ReadEuclid(size,file)
int *size;
char file[];

{	EuclidGraph graph;
	FILE *fp;
	char c;
	int i,xcoord, ycoord;

	if (file[0]=='\0') fp=stdin;
	else fp = fopen(file,"r");
	if (fp==NULL) {
		printf("ReadEuclid: file %s can't be opened\n",file);
		exit(0);
		}
	fscanf(fp,"%d %c",size,&c);
	if (c!='E' && c!='e') {
		printf("ReadEuclid: file %s isn't Euclidean\n",file);
		exit(0);
		}
	while (getc(fp)!='\n');
	graph = NewEuclid(*size);

	for (i=1; i<=*size; ++i) {
		fscanf(fp,"%d%d",&xcoord,&ycoord);
		while (getc(fp)!='\n') ;
		graph[i][0] = xcoord;
		graph[i][1] = ycoord;
		}
	fclose(fp);
	return (graph);
}

/*
WriteEuclid(graph,file)
EuclidGraph graph;
char file[];

{	FILE *fp;
	int size, i;

	if (file[0] == '\0') fp = stdout;
	else fp = fopen(file,"w");
	if (fp==NULL) {
		printf("WriteEuclid: file %s can't be opened\n",file);
		exit(0);
		}
	size = graph[0][0];
	fprintf(fp,"%d E\n",size);
	for (i = 1; i <= size; i++) 
		fprintf(fp,"%d %d\n",graph[i][0],graph[i][1]);
	fclose(fp);
}
*/

MatrixGraph ReadMatrix(size,file)
int *size;
char file[];
{	MatrixGraph graph;
	FILE *fp;
	char c;
	int i,j,k;

	if (file[0]=='\0') fp=stdin;
	else fp = fopen(file,"r");
	if (fp==NULL) {
		printf("ReadMatrix: file %s can't be opened\n",file);
		exit(0);
		}
	fscanf(fp,"%d %c",size,&c);
	if (c!='M' && c!='m') {
		printf("ReadMatrix: file %s isn't a distance matrix\n",file);
		exit(0);
		}
	while (getc(fp)!='\n');
	graph = NewMatrix(*size);

	for (i=1; i<*size; i++) {
		for (j=i+1; j<=*size; j++) {
			fscanf(fp,"%d",&k);
			graph[i*(*size)+j] = graph[j*(*size)+i] = k;
			}
		while (getc(fp)!='\n');
		}
	fclose(fp);
	return(graph);
}

/*
WriteMatrix(graph,file)
MatrixGraph graph;
char file[];

{	FILE *fp;
	int size, i, j;

	if (file[0] == '\0') fp = stdout;
	else fp = fopen(file,"w");
	if (fp==NULL) {
		printf("WriteMatrix: file %s can't be opened\n",file);
		exit(0);
		}
	size = graph[0];
	fprintf(fp,"%d M\n",size);
	for (i = 1; i < size; i++) {
		for (j=i+1; j<=size; j++)
			fprintf(fp,"%d ",graph[i*size+j]);
		fprintf(fp,"\n");
		}
	fclose(fp);
}
*/

/* Euclidean distance routines */

int eucdist (graph,i,j) /* Find the distance between two points */
			/* 10K x 10K unit square */
EuclidGraph graph;
int i,j;
{	int dv,dh;
	register int k, l;

	dv = graph[i][0]-graph[j][0];
	dh = graph[i][1]-graph[j][1];
	k = dv*dv + dh*dh;
	if (k==0) return(0);
	if (dv<0) dv = -dv;
	if (dh<0) dh = -dh;
	l = dv + dh;
	l = (l + k/l)>>1;
	l = (l + k/l)>>1;
	l = (l + k/l)>>1;
	l = (l + k/l)>>1;
	return ((l*l<k) ? ++l : l);
}


int eucdist2 (graph,i,j) /* Find the distance between two points */
			/* 1M x 1M unit square */
EuclidGraph graph;
int i,j;
{	double dv,dh,d;
	int l;

	dv = (double) graph[i][0]-graph[j][0];
	dh = (double) graph[i][1]-graph[j][1];
	d  = sqrt(dv*dv + dh*dh);
	l  = (int) d;
	return((d-l > .000000001) ? l+1 : l);
}


int eucdistsq(graph,i,j) /* Find the square of the dist between two points */
EuclidGraph graph;
int i,j;
{
	register int dv,dh;

	dv = graph[i][0]-graph[j][0];
	dh = graph[i][1]-graph[j][1];
	return(dv*dv+dh*dh);
}

