package game.animations
{
	import flash.events.*;
	import flash.display.*;
	
	import game.utils.*;
	import game.events.*;

	public class ProgressBar extends MovieClip
	{
		protected var endFrame:int;

		public function ProgressBar()
		{
		}

		public function progress( ratio:Number ):void
		{
			//TraceUtil.addLine( 'ProgressBar progress() ratio: ' + ratio );

			this.endFrame = ( ratio > 1 ) ? this.totalFrames : ratio * this.totalFrames;
/*
			switch ( true ) {

				case ratio < 1:
					//TraceUtil.addLine( 'ProgressBar progress() ratio < 1 -- endFrame: ' + this.endFrame );
					break;

				case ratio == 1:
					//TraceUtil.addLine( 'ProgressBar progress() ratio = 1 -- endFrame: ' + this.endFrame );
					break;

				case ratio > 1:
					//TraceUtil.addLine( 'ProgressBar progress() ratio > 1 -- endFrame: ' + this.endFrame );
					break;
			}
*/
			this.addEventListener( Event.ENTER_FRAME, this.checkFrame );
			this.play();
		}

		protected function init():void
		{
			this.gotoAndStop( 1 );
			this.endFrame = 0;
			//TraceUtil.addLine( 'ProgressBar init() totalFrames: ' + this.totalFrames );
			trace( 'ProgressBar init() totalFrames: ' + this.totalFrames );
		}

		protected function checkFrame( event:Event ):void
		{
			//TraceUtil.addLine( 'ProgressBar checkFrame() currentFrame: ' + this.currentFrame );

			if ( this.currentFrame >= this.endFrame ) {

				//TraceUtil.addLine( 'ProgressBar checkFrame() endFrame: ' + this.endFrame );
				//TraceUtil.addLine( 'ProgressBar checkFrame() totalFrames: ' + this.totalFrames );

				this.gotoAndStop( this.endFrame );
				this.removeEventListener( Event.ENTER_FRAME, this.checkFrame );

				if ( this.endFrame >= this.totalFrames ) {

					//TraceUtil.addLine( 'ProgressBar checkFrame() >>> Animation Complete!' );
					this.dispatchEvent( new GameEvent( GameEvent.ANIMATION_COMPLETE ) );
				}
			}
		}
	}
}