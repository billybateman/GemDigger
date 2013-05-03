package game.effects.filters
{
	import flash.filters.*;
	
	
	public class BevelEffect
	{
		public var filter:BevelFilter;
		
		
		public function BevelEffect()
		{
			this.filter = new BevelFilter();
			
			this.filter.distance		= 2;
			this.filter.angle			= 45;
			this.filter.highlightColor	= 0xFFFFFF;
			this.filter.highlightAlpha	= .5;
			this.filter.shadowColor		= 0x000000;
			this.filter.shadowAlpha		= 1;
			this.filter.blurX			= 3;
			this.filter.blurY			= 3;
			this.filter.strength		= 1;
			this.filter.quality			= BitmapFilterQuality.HIGH;
			this.filter.type			= BitmapFilterType.INNER;
			this.filter.knockout		= false;
		}
	}
}