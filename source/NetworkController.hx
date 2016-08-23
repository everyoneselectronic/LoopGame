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

// import de.polygonal.ai.pathfinding.AStar;
// import de.polygonal.ai.pathfinding.AStarWaypoint;
import de.polygonal.ds.ArrayList;
import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;

class NetworkController extends FlxGroup
{
	private var _packets:FlxTypedGroup<Packet>;
	private var _graph:NetworkGraph;

	private var _networkData:Array<Array<Int>>;

	override public function new():Void
	{
		super();

		_graph = new NetworkGraph();
		_packets = new FlxTypedGroup<Packet>();
		
		add(_graph);
		add(_packets);

		generateTestPackets();

		generateCSV();

	}

	private function generateTestPackets()
	{
		_networkData = new Array<Array<Int>>();

		var waypoints = _graph.get_waypoints();
		var timeFrame:Int = 1000;
		var baseTime:Int = 0;
		var endTime:Int = baseTime + timeFrame;

		var packetID:Int = 0;

		// generate packets, packet groups for each node
		for (node in waypoints)
		{
			var currentNode = node;

			// total packets to be sent from this node
			var numPackets:Int = FlxG.random.int(100,500);

			// make packet groups
			var packetGroups:Array<Int> = new Array<Int>();
			var count:Int = 0;

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
				packetGroups.push(groupSize);
			}

			// generate packets
			var timesUsed:Array<Int> = new Array<Int>();

			for (i in 0...packetGroups.length)
			{
				// set startNode
				var startNode:AStarWaypoint = currentNode;

				// set endNode
				var a:Array<Int> = [currentNode.id];
				var n = FlxG.random.int(0, waypoints.size - 1, a );
				var e = waypoints.get(n);
				var endNode:AStarWaypoint = e;

				// set route
				var route:ArrayList<AStarWaypoint> = _graph.findShortestPath(startNode, endNode);

				for (p in 0...packetGroups[i])
				{
					var id = packetID;

					// make name
					var totalNum = packetGroups[i];
					var partNum:Int = p + 1;
					var partNumStr:String = partNum + "";
					if (partNum < 10) partNumStr = "0" + partNum;
					var name:String = currentNode.id + "_" + id + "_" + partNumStr + "/" + totalNum;

					// send time to send 
					// need to make increase from first packet
					var timeToSend:Int = FlxG.random.int(baseTime, endTime, timesUsed);
					timesUsed.push(timeToSend);

					// calculate travel
					var time:Int = timeToSend;
					var pN:AStarWaypoint = currentNode;

					for (n in route)
					{
						var data:Array<Int> = new Array<Int>();

						var s = pN;
						var e = n;
						var d:Float = s.distanceTo(e);

						// divide by 10 to reduce times
						time += Std.int(d/10);
						
						data = [ packetID, e.id, time ];

						_networkData.push(data);

						pN = n;
					}	

					// add to packet group
					var packet = new Packet(id, name, startNode, endNode, route);
					_packets.add(packet);

					packetID++;
				}
			}
		}
	}

	private function generateCSV()
	{
		var filePackets:String = "./packets.csv";
		var fileNetwork:String = "./networkData.csv";

		if (sys.FileSystem.exists(filePackets)) sys.FileSystem.deleteFile(filePackets);
		sys.io.File.saveContent(filePackets, "name, startNode, endNode, route\r\n");
		
		if (sys.FileSystem.exists(fileNetwork)) sys.FileSystem.deleteFile(fileNetwork);
		sys.io.File.saveContent(fileNetwork, "packet, Node, Time\r\n");

		for (p in _packets)
		{
			// trace(p.toCsv());
			var fp = sys.io.File.append(filePackets);
	        fp.writeString(p.toCsv() + "\r\n");
	        fp.close();
		}

		for (d in _networkData)
		{
			// trace(d);
			var str:String = d.toString();
			str = str.substr(1,str.indexOf("]")-1);

			var fn = sys.io.File.append(fileNetwork);
	        fn.writeString(str + "\r\n");
	        fn.close();
		}
	}
	
}