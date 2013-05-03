package game.text
{
	import game.utils.*;
	import game.effects.*;
	import game.objects.*;

	public class GameErrorTitle extends GameText
	{
		public function GameErrorTitle( errorNo:String )
		{
			super( GameErrorPopUp.sizeTitle, GameErrorPopUp.colorTitle, GameErrorPopUp.fontTitle, GameErrorPopUp.alignTitle );

			this.x		= GameErrorPopUp.posTitleX;
			this.y		= GameErrorPopUp.posTitleY;
			this.width	= GameErrorPopUp.widthTitle;
			//this.height	= GameErrorPopUp.heightTitle;

			if ( errorNo == '' ) {

				this.setText( 'UNDEFINED ERROR', false );

			} else {

				this.setText( 'ERROR #' + errorNo, false );
			}

			TraceUtil.addLine( 'GameErrorTitle() text: ' + this.text );

			this.setFilter( FilterEffects.TYPE_GLOW, 'blurX', String( GameErrorPopUp.blurTitle ) );
			this.setFilter( FilterEffects.TYPE_GLOW, 'blurY', String( GameErrorPopUp.blurTitle ) );
			this.setFilter( FilterEffects.TYPE_GLOW, 'color', String( GameErrorPopUp.glowTitle ) );
			this.activateFilters();
		}
	}
}