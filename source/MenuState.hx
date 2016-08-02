package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

import flixel.FlxGame;

// import flixel.group.FlxGroup.FlxTypedGroup;

// import de.polygonal.ai.pathfinding.AStar;
// import de.polygonal.ai.pathfinding.AStarWaypoint;
// import de.polygonal.ds.ArrayList;
// import de.polygonal.ds.Graph;
// import de.polygonal.ds.GraphNode;

class MenuState extends FlxState
{
	override public function create():Void
	{
		// packets = new FlxTypedGroup<Packet>();
		// var test = new TestPathFinder();
		
		// add(test);
		// add(packets);

		var network = new NetworkController();
		add(network);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	// public static function makePacket(route)
	// {
	// 	var packet = new Packet(route);
	// 	packet.makeGraphic(4,10,FlxG.random.color());
	// 	var start = route.get(0);
	// 	packet.setPosition(start.x,start.y);
	// 	packets.add(packet);
	// 	packet.ID = packets.length;
	// }
}