package game.utils
{
	public class URLUtils
	{
		private static const SLASH:String = '/';


		public function URLUtils()
		{
		}
		
		
		/**
		 * Joins two URL parts to make one URL.
		 */
		public static function join( URL1:String, URL2:String ):String {
			
			var url1:String = URLUtils.stripSlash( URL1 );
			var url2:String = URLUtils.stripSlash( URL2 );

			var slash:String = ( !Boolean( url1 ) || !Boolean( url2 ) ) ? '' : URLUtils.SLASH;
			
			return url1 + slash + url2;
		}
		
		
		/**
		 * Strips the ending slash from a URL.
		 */
		public static function stripSlash( URL:String ):String {
			
			if ( !Boolean( URL ) ) return URL;

			var idx:int = URL.length - 1;
			
			return ( URL.substr( idx, 1 ) == URLUtils.SLASH ) ? URL.substr( 0, idx ) : URL;
		}
	}
}