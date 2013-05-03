package game.text
{
	public class GameTextRandomColor extends GameText
	{
		private const COLOR_RED:uint		= 0xFF0000;
		private const COLOR_GREEN:uint		= 0x00FF00;
		private const COLOR_BLUE:uint		= 0x0000FF;
		private const COLOR_ORANGE:uint		= 0xFF6600;
		private const COLOR_YELLOW:uint		= 0xFFFF00;
		private const COLOR_BROWN:uint		= 0x993300;
		private const COLOR_PINK:uint		= 0xFF66CC;
		private const COLOR_AQUA:uint		= 0x66FFCC;
		private const COLOR_VIOLET:uint		= 0x990099;
		
		
		public function GameTextRandomColor( size:uint, font:String, align:String )
		{
			var color:uint = getRandomColor();
			super( size, color, font, align );
		}


		private function getRandomColor():uint
		{
			var _colors:Array	= new Array(
				COLOR_RED,
				COLOR_GREEN,
				COLOR_BLUE,
				COLOR_ORANGE,
				COLOR_YELLOW,
				COLOR_BROWN,
				COLOR_PINK,
				COLOR_AQUA,
				COLOR_VIOLET
			);

			var colorNo:uint = Math.floor( Math.random() * _colors.length );

			return _colors[ colorNo ];
		}
	}
}