package game.buttons
{
	import game.data.*;
	import game.utils.*;
	import game.controllers.*;
	import game.buttons.sound.*;

	import flash.events.*;
	import flash.display.*;

	/**
	 * A button that turns sound on or off for
	 * the entire application. The button contains
	 * the following two display objects:
	 * 
	 * - SoundOnButton
	 * - SoundOffButton
	 * 
	 * Both buttons must be defined in the
	 * main game SWF.
	 */
	public class SoundButton extends Sprite
	{
		private var soundOnBtn:SoundOnButton;
		private var soundOffBtn:SoundOffButton;

		public function SoundButton()
		{
		}

		public function activate():void
		{
			if ( this.isMute() ) {

				this.soundOff();

			} else {

				this.soundOn();
			}

			//TraceUtil.addLine( 'SoundButton activate() stageRef:' + GameConfig.stageRef );

			GameData.stage.addChild( this );
			if ( !GameData.stage.hasEventListener( Event.ADDED ) ) GameData.stage.addEventListener( Event.ADDED, this.updateStack );

			this.visible = true;
		}

		public function deactivate():void
		{
			this.soundOnBtn.removeEventListener( MouseEvent.MOUSE_DOWN, this.toggle );
			this.soundOffBtn.removeEventListener( MouseEvent.MOUSE_DOWN, this.toggle );

			this.visible = false;
			this.soundOnBtn.visible = false;
			this.soundOffBtn.visible = false;

			GameData.stage.removeChild( this );
			GameData.stage.removeEventListener( Event.ADDED, this.updateStack );
		}

		/**
		 * Returns the sound status of the application.
		 */
		public function isMute():Boolean
		{
			//TraceUtil.addLine( 'SoundButton isMute() SoundManager.instance:' + SoundManager.instance );
			return GameController.soundManager.isMute();
		}

		protected function toggle( event:Event ):void
		{
			if ( this.isMute() ) {

				this.soundOn();

			} else {

				this.soundOff();
			}

			GameController.soundManager.toggleSound();
		}

		protected function soundOn():void
		{
			this.soundOffBtn.removeEventListener( MouseEvent.MOUSE_DOWN, this.toggle );
			this.soundOnBtn.addEventListener( MouseEvent.MOUSE_DOWN, this.toggle );

			this.soundOnBtn.visible		= true;
			this.soundOffBtn.visible	= false;

			this.soundOnBtn.enable();
			this.soundOffBtn.disable();
			//TraceUtil.addLine( 'SoundButton soundOn() >>> SoundOn enabled' );
		}

		protected function soundOff():void
		{
			this.soundOnBtn.removeEventListener( MouseEvent.MOUSE_DOWN, this.toggle );
			this.soundOffBtn.addEventListener( MouseEvent.MOUSE_DOWN, this.toggle );

			this.soundOffBtn.visible	= true;
			this.soundOnBtn.visible		= false;

			this.soundOffBtn.enable();
			this.soundOnBtn.disable();
			//TraceUtil.addLine( 'SoundButton soundOff() >>> SoundOff enabled' );
		}

		/**
		 * Keeps the sound button on top of other display objects.
		 */
		protected function updateStack( event:Event ):void
		{
			GameData.stage.addChild( this );
		}

		protected function init():void
		{
			this.soundOnBtn = new SoundOnButton();
			this.soundOffBtn = new SoundOffButton();

			this.soundOnBtn.visible = false;
			this.soundOffBtn.visible = false;

			this.addChild( this.soundOffBtn );
			this.addChild( this.soundOnBtn );
		}
	}
}

/**
 * This is a private class declared outside of the package
 * that is only accessible to classes inside of this
 * file.  Because of that, no outside code is able to get a
 * reference to this class to pass to the constructor, which
 * enables us to prevent outside instantiation.
 */
class Lock {}
