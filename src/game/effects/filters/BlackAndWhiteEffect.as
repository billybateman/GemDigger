package game.effects.filters
{
	import flash.filters.ColorMatrixFilter;    
	import fl.motion.AdjustColor;
	

	public class BlackAndWhiteEffect
	{
		public var filter:ColorMatrixFilter;
		
		
		public function BlackAndWhiteEffect()
		{
			var color:AdjustColor;
			var matrix:Array;
			
			color				= new AdjustColor();
			color.brightness	= 20;
			color.contrast		= 20;
			color.hue			= 0;
			color.saturation	= -100;
			
			matrix				= color.CalculateFinalFlatArray();

			this.filter 		= new ColorMatrixFilter( matrix );
		}
	}
}
