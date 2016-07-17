package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.math.FlxRandom;

import de.polygonal.ai.pathfinding.AStar;
import de.polygonal.ai.pathfinding.AStarWaypoint;
import de.polygonal.ds.ArrayList;
import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;

class NetworkController extends FlxGroup
{
	private var _packets:FlxTypedGroup<Packet>;
	private var _graph:NetworkGraph;

	override public function new():Void
	{
		super();

		_packets = new FlxTypedGroup<Packet>();
		_graph = new NetworkGraph();
		
		add(_graph);
		add(_packets);

		generateTestPackets(10000);
	}
	
	private function generateTestPackets(num:Int = 1)
	{
		var wayPoints = _graph.get_waypoints();
		for (i in 0...num)
		{
			var start = FlxG.random.int(0, wayPoints.size-1);
			var end = start;
			while (start == end)
			{
				end = FlxG.random.int(0, wayPoints.size-1);
			}
			var arr = _graph.findShortestPath(wayPoints.get(start), wayPoints.get(end));
			makePacket(arr);
		}
	}

	private function makePacket(route)
	{
		var packet = new Packet(route);
		packet.ID = _packets.length;
		// packet.makeGraphic(4,10,FlxG.random.color());

		// var start = route.get(0);
		// packet.setPosition(start.x,start.y);

		_packets.add(packet);

		packet.send(null);
		// packet.velocity.y = 2;
	}
	
}