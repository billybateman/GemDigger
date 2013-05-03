package game.data
{
	public class GameConfig
	{
		public static const LANG_DIR:String		= 'lang';
		public static const SWF_DIR:String		= 'swf';
		public static const TEXT_DIR:String		= 'text';
		public static const IMAGE_DIR:String	= 'images';
		public static const SOUND_DIR:String	= 'sounds';
		public static const VIDEO_DIR:String	= 'videos';
		public static const SWF_EXT:String		= '.swf';
		public static const XML_EXT:String		= '.xml';
		public static const UNDER_SCORE:String	= '_';

		public static const SITE_QUIBIDS:uint	= 1;
		public static const SITE_SHOPPIE:uint	= 2;

		public static var gameSize:int;
		public static var multiplier:int;

		public static var id:String;
		public static var swf:String;
		public static var name:String;
		public static var version:String;

		public static var gameURL:String;
		public static var gameOverURL:String;

		public static var gameSite:uint;

		public static var langID:uint;
		public static var langName:String;
		public static var langCode:String;

		public static var langURL:String;
		public static var langTextFile:String;
		public static var langTextURL:String;
		public static var langSwfURL:String;
		public static var langImageURL:String;
		public static var langSoundURL:String;
		public static var langVideoURL:String;

		// Default language URLs (used if
		// locale item is not found with
		// langURL).
		public static var defaultCode:String;
		public static var defaultURL:String;
		public static var defaultTextFile:String;
		public static var defaultTextURL:String;
		public static var defaultSwfURL:String;
		public static var defaultImageURL:String;
		public static var defaultSoundURL:String;
		public static var defaultVideoURL:String;

		public function GameConfig()
		{
		}
	}
}
