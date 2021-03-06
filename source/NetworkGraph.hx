package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.math.FlxRandom;

import pathfinding.AStar;
import pathfinding.AStarWaypoint;

import de.polygonal.ds.ArrayList;
import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;

using flixel.util.FlxSpriteUtil;

class NetworkGraph extends FlxGroup
{
	private var _graph:Graph<AStarWaypoint>;
	private var _wayPoints:ArrayList<AStarWaypoint>;
	
	private var _astar:AStar;
	
	private var _source:AStarWaypoint;
	private var _target:AStarWaypoint;
	
	private var _canvas:FlxSprite;
	
	override public function new():Void
	{
		super();
		_buildGraph();
	}
	
	function _buildGraph()
	{

		//an array of point coordinates:
		//the first point's x coordinate is at index [0] and its y coordinate at index [1],
		//followed by the coordinates of the remaining points.
		// var nodeData = [82.00,298.00,132.00,446.00,184.00,179.00,228.00,326.00,306.00,478.00,391.00,373.00,406.00,240.00,414.00,111.00,500.00,447.00,537.00,245.00,597.00,376.00,618.00,186.00];
		
		//an array of arc indices:
		//the source node is at index [0], target node at index[1], followed by all remaining arcs.
		// var arcData = [9,10,10,11,11,9,7,9,11,7,6,5,5,9,9,6,3,5,6,3,2,0,0,3,3,2,0,1,1,3,1,4,4,3,5,8,8,9,4,5,2,6,6,7,7,2,8,10,4,8];
		
		Data.parseData();
		var nodeData = Data.nodeData;
		var arcData = Data.arcData;

		var nodeGraphicSize:Int = 10;
		_canvas = new FlxSprite();
		_canvas.makeGraphic(Data.largestCoords[0]+nodeGraphicSize, Data.largestCoords[1]+nodeGraphicSize, FlxColor.TRANSPARENT, true);
		add(_canvas);

		// nodeData = _editor.getNodeData();
		// arcData = _editor.getArcData();
		
		_graph = new Graph<AStarWaypoint>();
		_astar = new AStar(_graph);
		
		_wayPoints = new ArrayList<AStarWaypoint>();
		
		//create nodes + waypoints
		for (i in nodeData)
		{
			var nodeX = i[0];
			var nodeY = i[1];
			
			//create a waypoint object for each node
			var wp  = new AStarWaypoint(nodeData.indexOf(i));
			wp.x    = nodeX;
			wp.y    = nodeY;
			wp.node = _graph.addNode(_graph.createNode(wp));
			
			_wayPoints.pushBack(wp); //index => graph node

			// make visual nodes
			_canvas.drawRect(wp.x, wp.y, 10, 10, FlxColor.RED);
		}
		
		//create arcs between nodes
		for (a in arcData)
		{
			var index0 = a[0];
			var index1 = a[1];
			var source = _wayPoints.get(index0).node;
			var target = _wayPoints.get(index1).node;
			
			_graph.addMutualArc(source, target, 1);

			// make visual arcs
			var start = _wayPoints.get(index0);
			var end = _wayPoints.get(index1);
			var lineStyle:LineStyle = { thickness: 1, color: FlxColor.WHITE };
			_canvas.drawLine(start.x, start.y, end.x, end.y, lineStyle);
		}
	}

	public function findShortestPath(source:AStarWaypoint, target:AStarWaypoint):ArrayList<AStarWaypoint> 
	{
		/*///////////////////////////////////////////////////////
		// find shortest path from first to second node
		///////////////////////////////////////////////////////*/
		var path = new ArrayList<AStarWaypoint>();
		var pathExists = _astar.find(_graph, source, target, path);
		// trace('path exists: $pathExists');
		// trace('waypoints : $path');
		return path;
	}

	public function get_graph():Graph<AStarWaypoint>
	{
		return _graph;
	}

	public function get_waypoints():ArrayList<AStarWaypoint>
	{
		return _wayPoints;
	}

	public function get_node(index):AStarWaypoint
	{
		var node = _wayPoints.get(index);
		return node;
	}
	
}