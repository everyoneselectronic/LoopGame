package;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;

import pathfinding.AStar;
import pathfinding.AStarWaypoint;

import de.polygonal.ds.ArrayList;
import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;

class Packet extends FlxBasic
{
	private var	_id:Int;
	private var	_route:ArrayList<AStarWaypoint>;
	private var _name:String;
	private var _startNode:AStarWaypoint;
	private var _endNode:AStarWaypoint;
	
	public function new(id:Int, name:String, startNode:AStarWaypoint, endNode:AStarWaypoint, route:ArrayList<AStarWaypoint>):Void
	{
		_id = id;
		_route = route;
		_name = name;
		_startNode = startNode;
		_endNode = endNode;
		super();
	}

	override public function toString():String 
	{
		var route:String = "[ ";
		for (n in 0..._route.size)
		{
			var c:String = ", ";
			if (n == _route.size-1) c = " ]";
			var s = _route.get(n) + c;
			route += s;
		}

		return "name:" + _name + ", start:" + _startNode + ", end:" + _endNode + ", route:" + route;
	}

	public function toCsv():String 
	{
		var route:String = "[";
		for (n in 0..._route.size)
		{
			var c:String = "->";
			if (n == _route.size-1) c = "]";
			var s = _route.get(n) + c;
			route += s;
		}

		return _name + "," + _startNode + "," + _endNode + "," + route;
	}

	public function toArray():Array<Dynamic>
	{
		var a:Array<Dynamic> = new Array<Dynamic>();
		var route:String = "[";
		for (n in 0..._route.size)
		{
			var c:String = "->";
			if (n == _route.size-1) c = "]";
			var s = _route.get(n) + c;
			route += s;
		}

		a.push(_name);
		a.push(_startNode);
		a.push(_endNode);
		a.push(route);

		return a;
	}

	public function getRoute():ArrayList<AStarWaypoint>
	{
		return _route;
	}

	public function getName():String
	{
		return _name;
	}

	public function getStartNode():AStarWaypoint
	{
		return _startNode;
	}

	public function getEndNode():AStarWaypoint
	{
		return _endNode;
	}

}
