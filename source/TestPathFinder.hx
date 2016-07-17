package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;

import de.polygonal.ai.pathfinding.AStar;
import de.polygonal.ai.pathfinding.AStarWaypoint;
import de.polygonal.ds.ArrayList;
import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;

class TestPathFinder extends FlxGroup
{
	static var NODE_RADIUS = 10;
	static var ARC_OFFSET = 4;
	
	// static var _app:TestPathFinder;
	// public static function main()
	// {
	// 	_app = new TestPathFinder();
	// }
	
	var _graph:Graph<AStarWaypoint>;
	var _wayPoints:ArrayList<CustomWaypoint>;
	
	var _astar:AStar;
	// var _path:ArrayList<AStarWaypoint>;
	
	var _source:AStarWaypoint;
	var _target:AStarWaypoint;
	
	// var _editor:Editor;
	// var _info:String;
	// var _vr:VectorRenderer;
	
	public function new()
	{
		_buildGraph();
	}
	
	function _buildGraph()
	{
		//an array of point coordinates:
		//the first point's x coordinate is at index [0] and its y coordinate at index [1],
		//followed by the coordinates of the remaining points.
		var nodeData = [82.00,298.00,132.00,446.00,184.00,179.00,228.00,326.00,306.00,478.00,391.00,373.00,406.00,240.00,414.00,111.00,500.00,447.00,537.00,245.00,597.00,376.00,618.00,186.00];
		
		//an array of arc indices:
		//the source node is at index [0], target node at index[1], followed by all remaining arcs.
		var arcData = [9,10,10,11,11,9,7,9,11,7,6,5,5,9,9,6,3,5,6,3,2,0,0,3,3,2,0,1,1,3,1,4,4,3,5,8,8,9,4,5,2,6,6,7,7,2,8,10,4,8];
		
		// nodeData = _editor.getNodeData();
		// arcData = _editor.getArcData();
		
		_graph = new Graph<AStarWaypoint>();
		_astar = new AStar(_graph);
		
		_wayPoints = new ArrayList<CustomWaypoint>();
		
		//create nodes + waypoints
		var i = 0;
		var id = 0;
		while (i < nodeData.length)
		{
			var nodeX = nodeData[i++];
			var nodeY = nodeData[i++];
			
			//create a waypoint object for each node
			var wp  = new CustomWaypoint(id++);
			wp.x    = nodeX;
			wp.y    = nodeY;
			wp.node = _graph.addNode(_graph.createNode(wp));
			
			_wayPoints.pushBack(wp); //index => graph node
			
			// //create a button for each node
			// var trigger = new Trigger(new CircleSurface(nodeX, nodeY, NODE_RADIUS));
			// trigger.attach(this, TriggerEvent.CLICK);
			
			// //resolve waypoint from trigger
			// trigger.userData = wp;
		}
		
		//create arcs between nodes
		var i = 0;
		while (i < arcData.length)
		{
			var index0 = arcData[i++];
			var index1 = arcData[i++];
			var source = _wayPoints.get(index0).node;
			var target = _wayPoints.get(index1).node;
			
			_graph.addMutualArc(source, target, 1);
		}

		// trace(_graph);

		var arr = findShortestPath(_graph, _wayPoints.get(0), _wayPoints.get(8));

		trace(arr.toArray());

	}
	
	private function findShortestPath(graph:Graph<AStarWaypoint>, source:AStarWaypoint, target:AStarWaypoint):ArrayList<AStarWaypoint> 
	{
		/*///////////////////////////////////////////////////////
		// find shortest path from first to second node
		///////////////////////////////////////////////////////*/
		var path = new ArrayList<AStarWaypoint>();
		var pathExists = _astar.find(graph, source, target, path);
		
		// trace('path exists: $pathExists');
		// trace('waypoints : $path');
		return path;
	}
}