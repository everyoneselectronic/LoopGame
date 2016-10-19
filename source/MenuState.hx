package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxCamera;

// import flixel.group.FlxGroup.FlxTypedGroup;

// import de.polygonal.ai.pathfinding.AStar;
// import de.polygonal.ai.pathfinding.AStarWaypoint;
// import de.polygonal.ds.ArrayList;
// import de.polygonal.ds.Graph;
// import de.polygonal.ds.GraphNode;

class MenuState extends FlxState
{
	private var player:FlxSprite;
	private var playerSpeed:Int = 800;

	private var network:NetworkController;

	override public function create():Void
	{
		// packets = new FlxTypedGroup<Packet>();
		// var test = new TestPathFinder();
		
		// add(test);
		// add(packets);

		network = new NetworkController();
		add(network);

		player = new FlxSprite(100, 100);
		player.makeGraphic(10,10);
        add(player);

        FlxG.camera.follow(player);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Reset velocity by default, if not moving
        player.velocity.set(0,0);

        // Move player
        if (FlxG.keys.pressed.UP) player.velocity.y = -playerSpeed;
        if (FlxG.keys.pressed.DOWN) player.velocity.y = playerSpeed;
        if (FlxG.keys.pressed.LEFT) player.velocity.x = -playerSpeed;
        if (FlxG.keys.pressed.RIGHT) player.velocity.x = playerSpeed;

        if (FlxG.keys.pressed.SPACE) network.updatePackets();
	}
}