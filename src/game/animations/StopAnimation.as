package game.animations
{
	import game.events.*;

	import flash.events.*;
	import flash.display.*;

	public class StopAnimation extends MovieClip
	{
		public function StopAnimation()
		{
			this.reset();
		}

		public function reset():void
		{
			this.gotoAndStop( 1 );
		}

		public function start():void
		{
			this.addEventListener( Event.ENTER_FRAME, this.checkEnd );
			this.play();
		}

		protected function checkEnd( event:Event ):void
		{
			if ( this.currentFrame == this.totalFrames ) {

				this.removeEventListener( Event.ENTER_FRAME, this.checkEnd );
				this.stop();
				this.dispatchEvent( new GameEvent( GameEvent.ANIMATION_COMPLETE ) );
			}
		}
	}
}