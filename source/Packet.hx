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

import de.polygonal.ai.pathfinding.AStar;
import de.polygonal.ai.pathfinding.AStarWaypoint;
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

}
