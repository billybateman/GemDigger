package game.effects
{
	import game.effects.filters.*;


	public class FilterEffects
	{
		public static const TYPE_BEVEL:String		= 'bevel';
		public static const TYPE_SHADOW:String		= 'shadow';
		public static const TYPE_BLUR:String		= 'blur';
		public static const TYPE_GLOW:String		= 'glow';
		public static const TYPE_BW:String			= 'blackAndWhite';

		private var filters:Array;


		public function FilterEffects()
		{
			this.filters = new Array();
		}


		public function createFilter( type:String ):void
		{
			var filter:Object;

			switch ( type ) {

				case TYPE_BEVEL		:	filter = new BevelEffect();			break;
				case TYPE_SHADOW	:	filter = new DropShadowEffect();	break;
				case TYPE_GLOW		:	filter = new GlowEffect();			break;
				case TYPE_BLUR		:	filter = new BlurEffect();			break;
				case TYPE_BW		:	filter = new BlackAndWhiteEffect();	break;
			}

			this.filters[ type ] = filter;
		}


		public function setFilter( type:String, property:String = null, value:String = null ):void
		{
			if ( this.filters[ type ] == null ) {

				this.createFilter( type );
			}

			if ( property ) {

				this.filters[ type ].filter[ property ] = value;
			}
		}


		public function getFilters():Array
		{
			var filters:Array = new Array();

			for ( var type:String in this.filters ) {

				filters.push( this.filters[ type ].filter );
			}

			return filters;
		}
	}
}