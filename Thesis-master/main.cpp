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

int getTime(std::chrono::steady_clock::time_point start, std::chrono::steady_clock::time_point end){
	return std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
}

int main(int argc, const char* argv[]){

	max_x=max_y=min_y=min_x=0;

	setConfig(argc,argv);

	//Create variables for holding start and endpoint plus the test title
	point start, end;
	string testTitle;

	//Create vector for containing the linesegments of the polygons
	vector< vector < lineSegment> > polygons;

	//Create vector for containing the points of the polygons
	vector<point> points;

	//Call function that parses the file input
	readInput(start, end, testTitle, polygons, points);

	vector< vector < int > > graph;
	vector< vector < double > > graphDistance;

	//Vector so we can backtrack the route
	vector<int> route;

	vector< vector < int > > crossesNumber;
	//Get how many points we have
	size_t numberOfPoints = points.size();

	//Create a two dimenstional vector for the graph
	
	size_t dimension = numberOfPoints*(config.k+1);
	graph.resize(dimension,vector<int>());
	graphDistance.resize(dimension,vector<double>());

   auto time1 = std::chrono::steady_clock::now();

	//Call function that calculate the distance
	calculateNumberOfCrossings(crossesNumber, polygons, points);

   auto time2 = std::chrono::steady_clock::now();

	makeVisabilityGraph(graph, graphDistance, crossesNumber, points);

   auto time3 = std::chrono::steady_clock::now();


	//The graph is constructed call dijksta to calculate the distance
	double distance = dijkstra(graphDistance,graph,route);

   auto time4 = std::chrono::steady_clock::now();
	//Output the distance
	
	if(config.printGraph){
		draw(testTitle,start,end, polygons,distance,points,route,graph);
	}
	else{
		//cout << distance << endl;
		cout << getTime(time1,time2) << " " << getTime(time2,time3) << " " << getTime(time3,time4) << " " << distance << endl;
		//cout << "Dijkstra took : " << getTime(visibility_end,dijkstra_end) << endl;
	}
}
