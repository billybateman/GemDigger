package game.effects
{
	import flash.geom.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;
	import flash.filters.*;

	/**
	 * Takes an image and uses the perlinNoise() method of the BitmapData
	 * class to make it look like the image has water flowing over it.
	 * The image must be a Sprite which contains the actual Bitmap image.
	 * 
	 * @param image		A sprite that contains the actual image.
	 * @param baseX		The base width of the perlin noise
	 * 					(x-direction). The smaller this value
	 * 					is, the more waves there will be.
	 * @param baseY 	The base height of the perlin noise
	 * 					(y-direction). The smaller this value
	 * 					is, the more waves there will be.
	 * @param speedX	The speed of the wave in the x-direction. The
	 * 					larger the value, the faster the wave.
	 * @param speedY	The speed of the wave in the y-direction. The
	 * 					larger the value, the faster the wave.
	 */
	public class WaterEffect extends Sprite
	{
		private var image:Sprite;
		private var baseX:Number;
		private var baseY:Number;
		private var speedX:Number;
		private var speedY:Number;

		private var perlin:Array;
		private var perlinData:BitmapData;
		private var filter:DisplacementMapFilter;

		public function WaterEffect( image:Sprite, speedX:Number, speedY:Number, baseX:Number, baseY:Number )
		{
			this.init( image, speedX, speedY, baseX, baseY );
			this.image = image;
			this.addChild( this.image );
		}

		public function start():void
		{
			this.addEventListener( Event.ENTER_FRAME, this.filterBitmap );
		}

		public function stop():void
		{
			this.removeEventListener( Event.ENTER_FRAME, this.filterBitmap );
		}

		private function init( image:Sprite, speedX:Number, speedY:Number, baseX:Number, baseY:Number ):void
		{
			this.image = image;
			this.addChild( this.image );

			this.baseX	= baseX;
			this.baseY	= baseY;
			this.speedX = speedX;
			this.speedY = speedY;

			this.perlinData		= new BitmapData( this.image.width, this.image.height );
			this.filter			= new DisplacementMapFilter( this.perlinData, new Point( 0, 0 ), 1, 2, 10, 60 );
			var pt1:Point		= new Point( 0, 0 );
			var pt2:Point		= new Point( 0, 0 );
			this.perlin			= [ pt1, pt2 ];
		}

		private function filterBitmap( event:Event ):void
		{
			this.perlin[ 0 ].x += this.speedX;
			this.perlin[ 1 ].y += this.speedY;
			this.perlinData.perlinNoise( this.baseX, this.baseY, 2, 50, true, false, 7, true, this.perlin );
			this.image.filters = [ this.filter ];
		}
	}
}