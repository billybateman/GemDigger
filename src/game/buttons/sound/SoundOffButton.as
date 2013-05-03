package game.buttons.sound
{
	import game.buttons.*;
	import game.buttons.sound.*;

	/**
	 * Defines the Sound Off state of the SoundButton. The
	 * button contains the following three display objects:
	 * 
	 * - SoundOffUp
	 * - SoundOffDn
	 * - SoundOffOvr
	 * 
	 * These objects define the up, down and hover state of
	 * the button, respectively. All three objects must be
	 * defined in the main game SWF.
	 */
	public class SoundOffButton extends GameSimpleButton
	{
		private var soundOffUp:SoundOffUp;
		private var soundOffDn:SoundOffDn;
		private var soundOffOv:SoundOffOvr;

		public function SoundOffButton()
		{
			this.soundOffDn = new SoundOffDn();
			this.soundOffUp = new SoundOffUp();
			this.soundOffOv = new SoundOffOvr();

			super( this.soundOffUp, this.soundOffDn, this.soundOffOv );
		}
	}
}