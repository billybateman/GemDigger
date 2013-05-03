package game.text
{
	import fl.lang.*;

	import game.data.*;
	import game.effects.*;
	import game.objects.*;

	/**
	 * Creates a text field for an error text in the GameErrorPopup.
	 * If an error no is given, the class attempts to retrieve the
	 * text from teh localized langauge file.
	 */
	public class GameErrorText extends GameText
	{
		private const NEW_LINE:String = "\n";

		public function GameErrorText( errorNo:String, errorTxt:String )
		{
			super( GameErrorPopUp.sizeText, GameErrorPopUp.colorText, GameErrorPopUp.fontText, GameErrorPopUp.alignText );

			var localeText:String;

			this.x		= GameErrorPopUp.posTextX;
			this.y		= GameErrorPopUp.posTextY;
			this.width	= GameErrorPopUp.widthText;

			if ( errorNo == '' ) {

				this.setText( errorTxt, false );

			} else {

				localeText = Locale.loadString( GameData.LOCALE_ERR_PREFIX + errorNo );

				if ( localeText ) {

					this.setText( localeText, false );

				} else {

					this.setText( errorTxt, false );
				}
			}

			this.setFilter( FilterEffects.TYPE_GLOW, 'blurX', String( GameErrorPopUp.blurText ) );
			this.setFilter( FilterEffects.TYPE_GLOW, 'blurY', String( GameErrorPopUp.blurText ) );
			this.setFilter( FilterEffects.TYPE_GLOW, 'color', String( GameErrorPopUp.glowText ) );
			this.activateFilters();
		}
	}
}