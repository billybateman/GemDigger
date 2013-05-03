package game.text
{
	import game.effects.*;
	import game.objects.*;

	public class GameErrorData extends GameText
	{
		public function GameErrorData( errorData:String )
		{
			super( GameErrorPopUp.sizeData, GameErrorPopUp.colorData, GameErrorPopUp.fontData, GameErrorPopUp.alignData );

			this.x		= GameErrorPopUp.posDataX;
			this.y		= GameErrorPopUp.posDataY;
			this.width	= GameErrorPopUp.widthData;

			this.setText( errorData, false );

			this.setFilter( FilterEffects.TYPE_GLOW, 'blurX', String( GameErrorPopUp.blurData ) );
			this.setFilter( FilterEffects.TYPE_GLOW, 'blurY', String( GameErrorPopUp.blurData ) );
			this.setFilter( FilterEffects.TYPE_GLOW, 'color', String( GameErrorPopUp.glowData ) );
			this.activateFilters();
		}
	}
}