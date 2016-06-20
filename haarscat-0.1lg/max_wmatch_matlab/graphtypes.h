#define INF	100000000
#define NULL	0

struct node_entry {
    int degree;
    double label;
    int x;
    int y;
    struct edge_ent *adj_list;
    };
typedef struct node_entry *Graph;

struct edge_ent {
    int endpoint;
    double label;
    double label2;
    struct edge_ent *nextedge;
    struct edge_ent *prevedge;
    struct edge_ent *otheredge;
    };
typedef struct edge_ent *Edge;

extern Graph ReadGraph(),NewGraph(),CopyGraph();
extern int AddEdge(), RemoveEdge(),NumEdges();
extern Edge FindEdge();

#define Degree(graph,n)    (graph[n].degree)
#define NLabel(graph,n)    (graph[n].label)
#define Xcoord(graph,n)    (graph[n].x)
#define Ycoord(graph,n)    (graph[n].y)
#define FirstEdge(graph,n) (graph[n].adj_list)

#define EndPoint(e) (e->endpoint)
#define ELabel(e)   (e->label)
#define ELabel2(e)  (e->label2)
#define Other(e)    (e->otheredge)
#define NextEdge(e) (e->nextedge)


extern Graph Prim();
extern int *EulerTraverse(),*Match(),*Weighted_Match(),*Dijkstra(),*Concomp();

/* Euclidean graph type */
typedef int (*EuclidGraph)[2];

extern Graph EuclidPrim();
extern EuclidGraph ReadEuclid(),NewEuclid();
extern int eucdist(),eucdistsq();

extern int *CvxHull();

/* Distance matrix graph type */
typedef int *MatrixGraph;

extern int *MatrixDijkstra();
extern Graph MatrixPrim();
extern Graph MatrixMaxFlow();
extern MatrixGraph ReadMatrix(), NewMatrix();

/* in glib.c */
extern int eucdist(),  eucdist2(), eucdistsq();

/* in wmatch.c */
extern void Initialize();
extern int FreeUp(), FreeGraph();

/* in pairs.c */
extern int PAIR(), MERGE_PAIRS(), LINK_PATH(), INSERT_PAIR();

/* in unpairs.c */
extern int UNPAIR(), REMATCH(), UNLINK();

/* in term.c */
extern void SET_BOUNDS(), UNPAIR_ALL();

/* in readgraph.c */
extern int SetUp(), SetStandard(), SetEuclid(), SetMatrix();

/* in pointer.c */
extern int POINTER(),  SCAN ();
