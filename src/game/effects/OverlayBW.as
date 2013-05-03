package game.effects
{
	import game.utils.*;

	import flash.display.*;

	import fl.transitions.*;
	import fl.transitions.easing.*;

	public class OverlayBW extends MovieClip
	{
		private const ALPHA_DURATION:int 	= 12;
		private const USE_SECONDS:Boolean	= false;

		private var tween:Tween;

		public function OverlayBW()
		{
			this.reset();
		}

		public function fadeIn():void
		{
			this.tween = new Tween( this, "alpha", Regular.easeIn, this.alpha, 1, ALPHA_DURATION, USE_SECONDS );
		}

		public function reset():void
		{
			this.alpha = 0;
		}
	}
}