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
	// private var ID:Int = 0;
	private var	_route:ArrayList<AStarWaypoint>;
	private var	_routePostion:Int = 0;
	private var _speed:Float = 100.0;
	
	public function new(route:ArrayList<AStarWaypoint>):Void
	{
		_route = route;
		super();
	}

	// override public function update(elapsed:Float):Void
	// {
	// 	super.update(elapsed);
	// }


	public function send(Timer:FlxTimer):Void
	{
		var packetdata:Array<Int> = new Array<Int>();

		// node - time at node - 

		// 	id:2 - 0s
		//  id:18 - 200s
		var currentPosition:Int = 0;
		var currNode = _route.get(currentPosition);
		var prevNode = currNode;

		for (n in _route)
		{
			if (currNode == prevNode)
			{
				// packetdata.push(n);
			}

		}

		var currentPosition = _routePostion;

		// var packetTime = FlxG.random.float(2.0,5.0);
		// trace("Packet_" + ID + " at " + _route.get(_routePostion));
		_routePostion++;

		if (_routePostion < _route.size)
		{
			var currentNode = _route.get(currentPosition);
			var nextNode = _route.get(_routePostion);
			var distance = currentNode.distanceTo(nextNode);
			var packetTime = distance/_speed;


			// time (seconds), callback, loops
			new FlxTimer().start(packetTime, send);

			// FlxTween.tween( this, { x: nextNode.x, y: nextNode.y }, packetTime, { onComplete: send } );

		}
		else
		{
			// trace("Packet_" + ID + " arrived");
			destroy();
		}
	}


}
