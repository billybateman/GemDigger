package game.effects.filters
{
	import flash.filters.*;
	
	
	public class GlowEffect
	{
		public var filter:GlowFilter;
		
		
		public function GlowEffect()
		{
			this.filter = new GlowFilter();
			
			this.filter.blurX			= 3;
			this.filter.blurY			= 3;
			this.filter.strength		= 1;
			this.filter.quality			= BitmapFilterQuality.HIGH;
			this.filter.color			= 0xFFFFFF;
			this.filter.knockout		= false;
			this.filter.inner			= false;
		}
	}
}