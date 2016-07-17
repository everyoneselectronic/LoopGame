package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup.FlxTypedGroup;

import de.polygonal.ai.pathfinding.AStar;
import de.polygonal.ai.pathfinding.AStarWaypoint;
import de.polygonal.ds.ArrayList;
import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;

class Packet extends FlxSprite
{

	private var	_route:ArrayList<AStarWaypoint>;
	private var	_routePostion:Int = 0;
	private var _speed:Float = 100.0;
	
	override public function new(route:ArrayList<AStarWaypoint>):Void
	{
		_route = route;
		send(null);
		super();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function send(Tween:FlxTween):Void
	{
		var currentPosition = _routePostion;

		// var packetTime = FlxG.random.float(2.0,5.0);
		trace("Packet_" + ID + " at " + _route.get(_routePostion));
		_routePostion++;

		if (_routePostion < _route.size)
		{
			var currentNode = _route.get(currentPosition);
			var nextNode = _route.get(_routePostion);
			var distance = currentNode.distanceTo(nextNode);
			var packetTime = distance/_speed;
			FlxTween.tween( this, { x: nextNode.x, y: nextNode.y }, packetTime, { onComplete: send } );

		}
		else
		{
			trace("Packet_" + ID + " arrived");
			destroy();
		}
	}


}
