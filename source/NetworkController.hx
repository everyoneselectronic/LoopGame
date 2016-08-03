package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.math.FlxRandom;
// import flixel.util.FlxSave;

import de.polygonal.ai.pathfinding.AStar;
import de.polygonal.ai.pathfinding.AStarWaypoint;
import de.polygonal.ds.ArrayList;
import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;

class NetworkController extends FlxGroup
{
	private var _packets:FlxTypedGroup<Packet>;
	private var _graph:NetworkGraph;

	// private var _gameSave:FlxSave;

	override public function new():Void
	{
		super();

		_graph = new NetworkGraph();
		_packets = new FlxTypedGroup<Packet>();
		
		add(_graph);
		add(_packets);


		generateTestPackets();


		for (p in _packets)
		{
			trace(p.toCss());
		}

	}

	private function generateTestPackets()
	{
		var waypoints = _graph.get_waypoints();

		var w = waypoints.get(0);

		// var packets:Array<Packet> = new Array<Packet>();

		var currentNode = w;

		var timeFrame:Int = 1000;
		var baseTime:Int = 0;
		var endTime:Int = baseTime + timeFrame;
		var timesUsed:Array<Int> = new Array<Int>();

		// total packets to be sent from this node
		var numPackets:Int = FlxG.random.int(100,500);
		trace(numPackets);

		// make packet groups
		var packetGroups:Array<Int> = new Array<Int>();
		var count = 0;

		while (count < numPackets)
		{
			var groupSize = FlxG.random.int(1, 21);

			if ((groupSize + count) > numPackets)
			{
				groupSize = numPackets - count;
				count = numPackets;
			}
			else
			{
				count += groupSize;
			}

			trace(count);

			packetGroups.push(groupSize);
		}


		// generate packets
		count = 0;

		for (i in 0...packetGroups.length)
		{
			for (p in 0...packetGroups[i])
			{
				var id = count;

				// name = node_id_partNum
				var totalNum = packetGroups[i] - 1;
				var partNum:String = p + "";
				if (p < 10) partNum = "0" + p;
				var name:String = currentNode.id + "_" + id + "_" + p + "/" + totalNum;

				// set startNode
				var startNode:AStarWaypoint = currentNode;

				// set endNode
				var a:Array<Int> = [currentNode.id];
				var n = FlxG.random.int(0, waypoints.size - 1, a );
				var e = waypoints.get(n);
				var endNode:AStarWaypoint = e;

				var route:ArrayList<AStarWaypoint> = _graph.findShortestPath(startNode, endNode);

				// send time to send 
				var timeToSend:Int = FlxG.random.int(baseTime, endTime, timesUsed);
				timesUsed.push(timeToSend);

				var packet = new Packet(id, name, startNode, endNode, route);
				_packets.add(packet);

				count++;
			}
		}

	}

	// private function makePacket(route)
	// {
	// 	var packet = new Packet(route);
	// 	packet.ID = _packets.length;
	// 	// packet.makeGraphic(4,10,FlxG.random.color());

	// 	// var start = route.get(0);
	// 	// packet.setPosition(start.x,start.y);

	// 	_packets.add(packet);

	// 	packet.send(null);
	// 	// packet.velocity.y = 2;
	// }
	
}