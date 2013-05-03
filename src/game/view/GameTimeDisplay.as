package game.view
{
	import game.utils.*;
	import game.controllers.*;

	import flash.display.*;

	public class GameTimeDisplay extends Sprite
	{
		protected var time:String;

		public function GameTimeDisplay()
		{
		}

		public function setTime( time:uint ):void
		{
			var minutes:uint	= time / TimeManager.SECONDS_IN_MINUTE;
			var seconds:uint	= time % TimeManager.SECONDS_IN_MINUTE;
			this.time			= String( minutes ) + ':' + this.formatSeconds( seconds );
		}

		private function formatSeconds( seconds:uint ):String
		{
			return ( seconds < 10 ) ? '0' + String( seconds ) : String( seconds );
		}
	}
}