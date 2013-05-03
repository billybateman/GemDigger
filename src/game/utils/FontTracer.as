package game.utils
{
	import flash.text.*;

	public class FontTracer
	{
		public function FontTracer()
		{
		}

		public static function traceFonts( includeDeviceFonts:Boolean = false ):void
		{
			var fonts:Array = Font.enumerateFonts( includeDeviceFonts );

			fonts.sortOn( 'fontName', Array.CASEINSENSITIVE );

			TraceUtil.addLine( '****************************************' );
			TraceUtil.addLine( '***   FontTracer v2.0' );
			TraceUtil.addLine( '****************************************' );
			TraceUtil.addLine( '***' );

			for each ( var font:Object in fonts ) {

				TraceUtil.addLine( '*** Font Name: ' + font.fontName );
				TraceUtil.addLine( '*** Font Style: ' + font.fontStyle  );
				TraceUtil.addLine( '*** Font Type: ' + font.fontType );
				TraceUtil.addLine( '***' );
			}
		}
	}
}
