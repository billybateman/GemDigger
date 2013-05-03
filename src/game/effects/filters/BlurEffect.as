package game.effects.filters
{
	import flash.filters.*;
	
	
	public class BlurEffect
	{
		public var filter:BlurFilter;
		
		
		public function BlurEffect()
		{
			this.filter = new BlurFilter();
			
			this.filter.blurX		= 5;
			this.filter.blurY		= 5;
			this.filter.quality		= BitmapFilterQuality.LOW;
		}
	}
}