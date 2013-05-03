package game.buttons
{
	import game.objects.*;

	import flash.display.SimpleButton;

	/**
	 * Defines a customer support button for the
	 * GameErrorPopup. The object must be defined
	 * in both the main game SWF and the preloader.
	 */
	public class CustomerSupportBtn extends SimpleButton
	{
		public function CustomerSupportBtn()
		{
			this.x = GameErrorPopUp.posBtnX;
			this.y = GameErrorPopUp.posBtnY;
		}
	}
}