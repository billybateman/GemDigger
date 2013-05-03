package game.text
{
	import game.utils.*;

	import flash.text.*;
	import flash.utils.*;

	/**
	 * The GameFont class stores the actual font name used by
	 * the system in an array that is indexed by a font label
	 * (defined through the game).
	 */
	public class GameFont
	{
		public static const FONT_ARIAL:String			= 'Arial';
		public static const FONT_ARIAL_BLACK:String		= 'ArialBlack';

		private static const FONT_PREFIX:String 		= 'fonts.';

		private static var fonts:Array = new Array();

		public function GameFont()
		{
		}

		public static function setFont( label:String, fontClass:Class ):void
		{
			var font:Font = new fontClass();

			//TraceUtil.addLine( 'GameFont setFont() font: ' + font );
			//TraceUtil.addLine( 'GameFont setFont() font.fontName: ' + font.fontName );

			GameFont.fonts[ label ] = font.fontName;
		}

		public static function getFont( label:String ):String
		{
			return ( GameFont.fonts[ label ] ) ? GameFont.fonts[ label ] : null;
		}
	}
}