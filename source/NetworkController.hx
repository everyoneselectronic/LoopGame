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

import pathfinding.AStar;
import pathfinding.AStarWaypoint;

import de.polygonal.ds.ArrayList;
import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;

class NetworkController extends FlxGroup
{
	private var _packets:FlxTypedGroup<Packet>;
	private var _graph:NetworkGraph;

	private var _networkData:Array<Array<Int>> = [];

	private var _currentTime:Int = 0;
	private var _timeFrame:Int = 1000;
	private var numPacketRange:Array<Int> = [10,50];

	override public function new():Void
	{
		super();

		_graph = new NetworkGraph();
		_packets = new FlxTypedGroup<Packet>();
		
		add(_graph);
		add(_packets);

		// trace(Data.arcData);

		generateTestPackets();
		generateCSV();

	}

	public function updatePackets()
	{
		generateTestPackets();
		generateCSV();
	}

	private function deleteUsedNetworkData(endTime)
	{
		if (_networkData.length > 0)
		{
			var i:Int = 0;
			while (i < _networkData.length)
			{
				var d = _networkData[i];
				if (d[2] < endTime)
				{
					_networkData.splice(i, 1);
				} else i++;
			}
		}
	}

	private function generateTestPackets()
	{
		var waypoints = _graph.get_waypoints();
		var baseTime:Int = _currentTime;
		var endTime:Int = baseTime + _timeFrame;

		_currentTime = endTime + 1;

		deleteUsedNetworkData(baseTime);

		var packetID:Int = _packets.length;

		// generate packets, packet groups for each node
		for (node in waypoints)
		{
			var currentNode = node;

			// total packets to be sent from this node
			var numPackets:Int = FlxG.random.int(numPacketRange[0],numPacketRange[1]);

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
		// set file path
		var fileNetworkTraffic:String = "./networkTrafficData.csv";

		// delete file of exsits
		if (sys.FileSystem.exists(fileNetworkTraffic)) sys.FileSystem.deleteFile(fileNetworkTraffic);
		
		// create csv header
		sys.io.File.saveContent(fileNetworkTraffic, "packetID, packetName, packetRoute, currentTime, currentNode, startNode, endNode\r\n");

		// write csv data
		for (d in _networkData)
		{
			var id:Int = d[0];
			var p = _packets.members[id];
			var pArray = p.toArray();

			var packetID:String = Std.string(d[0]);
			var packetName:String = Std.string(pArray[0]);
			var packetRoute:String = Std.string(pArray[3]);
			var currentTime:String = Std.string(d[2]);
			var currentNode:String = Std.string(d[1]);
			var startNode:String = Std.string(pArray[1]);
			var endNode:String = Std.string(pArray[2]);

			var str = packetID + ", " + packetName + ", " + packetRoute + ", " + currentTime + ", " + currentNode + ", " + startNode + ", " + endNode;

			var fn = sys.io.File.append(fileNetworkTraffic);
	        fn.writeString(str + "\r\n");
	        fn.close();
		}
	}

}