package game.events
{
	import flash.events.*;

	public class GameNetEvent extends Event
	{
		public static const ERROR_RECEIVED:String		= 'errorReceived';
		public static const RESPONSE_RECEIVED:String	= 'responseReceived';
		public static const GATEWAY_LOADED:String		= 'gatewayLoaded';

		public function GameNetEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

		override public function clone():Event
		{
			return new GameEvent( this.type, this.bubbles, this.cancelable );
		}
	}
}