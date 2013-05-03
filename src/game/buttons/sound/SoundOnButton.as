package game.buttons.sound
{
	import game.buttons.*;
	import game.buttons.sound.*;

	/**
	 * Defines the Sound On state of the SoundButton. The
	 * button contains the following three display objects:
	 * 
	 * - SoundOnUp
	 * - SoundOnDn
	 * - SoundOnOvr
	 * 
	 * These objects define the up, down and hover state of
	 * the button, respectively. All three objects must be
	 * defined in the main game SWF.
	 */
	public class SoundOnButton extends GameSimpleButton
	{
		private var soundOnUp:SoundOnUp;
		private var soundOnDn:SoundOnDn;
		private var soundOnOv:SoundOnOvr;

		public function SoundOnButton()
		{
			this.soundOnDn = new SoundOnDn();
			this.soundOnUp = new SoundOnUp();
			this.soundOnOv = new SoundOnOvr();

			super( this.soundOnUp, this.soundOnDn, this.soundOnOv );
		}
	}
}