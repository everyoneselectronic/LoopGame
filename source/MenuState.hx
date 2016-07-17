package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
// import flixel.group.FlxGroup.FlxTypedGroup;

// import de.polygonal.ai.pathfinding.AStar;
// import de.polygonal.ai.pathfinding.AStarWaypoint;
// import de.polygonal.ds.ArrayList;
// import de.polygonal.ds.Graph;
// import de.polygonal.ds.GraphNode;

class MenuState extends FlxState
{

	// private static var packets:FlxTypedGroup<Packet>;
	private var _fpsCounter:FlxText;

	override public function create():Void
	{
		// packets = new FlxTypedGroup<Packet>();
		// var test = new TestPathFinder();
		
		// add(test);
		// add(packets);

		var network = new NetworkController();
		add(network);

		_fpsCounter = new FlxText(10, 10, FlxG.width, "FPS: " + 30);
		_fpsCounter.setFormat(null, 22, FlxColor.WHITE, CENTER);
		add(_fpsCounter);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_fpsCounter.text = "FPS: " + FlxG.drawFramerate;
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