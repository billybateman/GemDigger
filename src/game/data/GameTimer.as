package game.data
{
	import game.view.*;

	import flash.events.*;
	import flash.display.*;

	public class GameTimer extends EventDispatcher
	{
		public var name:String;
		public var display:GameTimeDisplay;

		public var start:int;
		public var seconds:int;

		public var active:Boolean;

		public function GameTimer( name:String, display:GameTimeDisplay )
		{
			this.name		= name;
			this.display	= display;
			this.start		= 0;
			this.seconds	= 0;
			this.active		= false;
		}
	}
}