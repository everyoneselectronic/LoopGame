import de.polygonal.ai.pathfinding.AStarWaypoint;

class CustomWaypoint extends AStarWaypoint
{
	public var id:Int;
	
	public function new(id:Int)
	{
		super();
		this.id = id;
	}
	
	override public function toString():String 
	{
		return Std.string(id);
	}
}