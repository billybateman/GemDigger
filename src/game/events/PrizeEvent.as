package game.events
{
	import flash.events.*;
	
	
	public class PrizeEvent extends Event
	{
		public static const PRIZE_RECEIVED:String		= 'prizeReceived';
		public static const PRIZE_LOADED:String			= 'prizeLoaded';
		public static const PRIZE_REGISTERED:String		= 'prizeRegistered';
		
		
		public function PrizeEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		
		override public function clone():Event {
			
			return new PrizeEvent( this.type, this.bubbles, this.cancelable );
		}
	}
}