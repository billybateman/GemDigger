package game.effects.filters
{
	import flash.filters.*;


	public class DropShadowEffect
	{
		public var filter:DropShadowFilter;


		public function DropShadowEffect()
		{
			this.filter = new DropShadowFilter();
			
			this.filter.distance	= 3;
			this.filter.angle		= 45;
			this.filter.color		= 0x000000;
			this.filter.alpha		= .5;
			this.filter.blurX		= 5;
			this.filter.blurY		= 5;
			this.filter.strength	= 1;
			this.filter.quality		= BitmapFilterQuality.LOW;
			this.filter.inner		= false;
			this.filter.knockout 	= false;
			this.filter.hideObject	= false;
		}
	}
}