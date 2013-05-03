package game.text
{
	import game.effects.*;

	public class GameTextMem extends GameText
	{
		public function GameTextMem()
		{
			super( 12, 0xFFFFFF, GameFont.FONT_ARIAL_BLACK, GameText.ALIGN_LEFT );
			
			this.width		= 150;
			this.height		= 25;
			
			this.mouseEnabled = false;
			
			this.setFilter( FilterEffects.TYPE_SHADOW, 'blurX', '2' );
			this.setFilter( FilterEffects.TYPE_SHADOW, 'blurY', '2' );
			this.setFilter( FilterEffects.TYPE_SHADOW, 'distance', '1' );
			this.setFilter( FilterEffects.TYPE_SHADOW, 'strength', '1' );
			this.setFilter( FilterEffects.TYPE_SHADOW, 'color', '0x000000' );
			this.setFilter( FilterEffects.TYPE_GLOW, 'blurX', '2' );
			this.setFilter( FilterEffects.TYPE_GLOW, 'blurY', '2' );
			this.setFilter( FilterEffects.TYPE_GLOW, 'color', '0x000000' );
			this.activateFilters();
		}
	}
}