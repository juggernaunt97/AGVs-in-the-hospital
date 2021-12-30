#include <iostream> //cin cout
#include <vector> //vector
#include <cstdio> //scanf
#include <sstream> //ostringstream
#include <cmath> //pow sqrt
#include <queue> //priority_queue
#include <stdlib.h> //atoi
#include <tuple> //get<n> make_tuple
#include <chrono>
#include <fstream>

//So we don't need to write std:: everywhere
using namespace std;
int tr[100005];
struct {
	bool printGraph = false;
	bool drawRoute = true;
	int printLevel = 0;
	size_t k = 0;
} config;

//point type for holding a coordinate
void setMinMax(double x, double y);
struct point {
	double x;
	double y;
	point(double x,double y){
		this->x = x;
		this->y = y;
		setMinMax( x, y);
	}

	point(){

	}
	bool operator==(const point &other) const {
		return (this->x==other.x && this->y==other.y);
	}
};
//Type used in the priority queue in the dijkstra function
typedef std::pair<double,std::pair<int,int> > pq_pair;
//Input n start points
pair<point,point> npoints[200];
//linesegment type holding two points
struct lineSegment {
	point p;
	point q;
	lineSegment(point p,point q){
		this->p = p;
		this->q = q;
	};
	lineSegment(){

	}
	bool operator==(const lineSegment &other) const {
		return (this->p==other.p && this->q==other.q) ||
		(this->p==other.q && this->q==other.p);
  }
};

#include "draw.cpp"
#include "naive.cpp"

int numberofstart;
void setConfig(int argc, const char* argv[]){
	for(int i = 1 ; i < argc ; i++ ){
		string s(argv[i]);
		if(s.compare("-k")==0){
			config.k = atoi(argv[i+1]);
		}
		if(s.compare("-p")==0){
			config.printGraph = true;
			if(argc-1>i){
				string temp(argv[i+1]);

				if(temp.find_first_not_of( "0123456789" ) == string::npos){
					config.printLevel = atoi(argv[i+1]);
				}
			}
		}
	}
}
	//Create vector for containing the points of the polygons
vector<point> points;

	//Vector so we can backtrack the route
	vector<int> route;
void backtrack(int n)
{
    //cout<<n<<'\n';
    ofstream file ("/home/chau/target Machine learning/AGV-Hospital-ver2/AGVs-in-the-hospital/code/output.txt",ios::out | ios::app);
    file<<points[n].x<<" "<<points[n].y<<"\n";
    if(n==0){cout<<points[n].x<<" "<<points[n].y<<'\n';return;}
    backtrack(route[n]);
    cout<<points[n].x<<" "<<points[n].y<<'\n';

	file.close();

}
int getTime(std::chrono::steady_clock::time_point start, std::chrono::steady_clock::time_point end){
	return std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
}
void readInput(vector< vector< lineSegment> > &polygons, vector<point> &points);
int main(int argc, const char* argv[]){

    cin.tie(0);
    freopen("nam.inp","r",stdin);
	int max_x=0,max_y=0,min_y=0,min_x=0;

	setConfig(argc,argv);

	//Create variables for holding start and endpoint plus the test title
	point start, end;
	string testTitle;

	//Create vector for containing the linesegments of the polygons
	vector< vector < lineSegment> > polygons;


	//Call function that parses the file input
	readInput( polygons, points);
	for(int i=1;i<=numberofstart;i++)
	{
    vector< vector < int > > graph;
	vector< vector < double > > graphDistance;


	vector< vector < int > > crossesNumber;

	//Get how many points we have
	size_t numberOfPoints = points.size();
	//Create a two dimenstional vector for the graph
	points[0]=npoints[i].first;
	points[numberOfPoints-1]=npoints[i].second;
	size_t dimension = numberOfPoints*(config.k+1);
	graph.resize(dimension,vector<int>());
	graphDistance.resize(dimension,vector<double>());
	//Call function that calculate the distance	
	calculateNumberOfCrossings(crossesNumber, polygons, points);
	makeVisabilityGraph(graph, graphDistance, crossesNumber, points);
	//The graph is constructed call dijksta to calculate the distance
	double distance = dijkstra(graphDistance,graph,route);
	//Output the distance
	//cout<<distance<<'\n';
	//Out put the way we can go
	backtrack(numberOfPoints-1);
	ofstream file ("/home/chau/target Machine learning/AGV-Hospital-ver2/AGVs-in-the-hospital/code/output.txt",ios::out | ios::app);
	if(numberofstart!=i){
		cout<<"\n";
		file<<"\n";
		}
	file.close();
	//cout<<numberOfPoints<<"\n";
	//for(int i=0;i<numberOfPoints;i++)cout<<i<<" "<<points[i].x<<""<<points[i].y<<" "<<route[i]<<"\n";
	}
}

void readInput(vector< vector< lineSegment> > &polygons, vector<point> &points){

//get the number of start points
    cin>>numberofstart;
	//Read start and end points
	for(int i=0;i<numberofstart;i++)
	{
	    point start = readPoint();
        point end  = readPoint();
        npoints[i+1]={start,end};
	}
    points.push_back(npoints[1].first);
	//Get the number of Polygons
	int numberOfPolygons;
	cin >> numberOfPolygons;

	polygons.resize(numberOfPolygons, vector<lineSegment>());

	//Iterate through the polygons
	for(int i=0;i<numberOfPolygons;i++){

		//Get the number of sides
		int numberOfSides;
		cin >> numberOfSides;

		//Get the first point and remember it
		//so we can make the last linesegment after the loop
		point firstPoint = readPoint();

		//Create a variable for the last point we saw
		point lastPoint  = firstPoint;

		//Add the first point
		points.push_back(firstPoint);

		for(int j=1;j<numberOfSides;j++){

			//Get the next point
			point currentPoint = readPoint();

			//Add point to list of points
			points.push_back(currentPoint);

			//create linesegment
			lineSegment l;

			//Set the linesegment
			l.p = lastPoint;
			l.q = currentPoint;

			//push it to the list of linesegments
			polygons[i].push_back(l);

			//and update the lastPoint
			lastPoint = currentPoint;
		}

		//Construct the missing linesegment
		lineSegment l;
		l.p = lastPoint;
		l.q = firstPoint;

		//and push it to the vector
		polygons[i].push_back(l);
	}

	points.push_back(npoints[1].second);

}

