package game.controllers
{
	import fl.lang.*;

	import flash.net.*;
	import flash.events.*;
	import flash.display.*;

	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;
	import game.objects.*;

	/**
	 * Loads localized text and assets (images, SWF files, etc.).
	 */
	public class GameLocalizer extends EventDispatcher
	{
		private static var assets:Array = new Array();
		private static var sounds:Array = new Array();
		private static var videos:Array = new Array();

		public function GameLocalizer()
		{
		}

		/**
		 * Loads all locale assets needed at the beginning of the game.
		 */
		public function start():void
		{
			if ( GameError.hasError ) return;
			this.loadLocaleAssets();
		}

		/**
		 * Adds an asset to be loaded at the start of the game.
		 * 
		 * @param id: ID used in the GameAsset to define the asset.
		 */
		public static function addAsset( id:String ):void
		{
			GameLocalizer.assets.push( id );
		}

		/**
		 * Adds a sound to be loaded at the start of the game.
		 * 
		 * @param id: ID used in the GameAsset to define the asset.
		 */
		public static function addSound( id:String ):void
		{
			GameLocalizer.sounds.push( id );
		}

		/**
		 * Adds an video to be loaded at the start of the game.
		 * 
		 * @param id: ID used in the GameAsset to define the asset.
		 */
		public static function addVideo( id:String ):void
		{
			GameLocalizer.videos.push( id );
		}

		public function loadAsset( id:String ):void
		{
			GameController.assetManager.loadGameAsset( id );
		}

		protected function loadLocaleText():void
		{
			if ( GameError.hasError ) return;

			var path:String = URLUtils.join( GameConfig.langTextURL, GameConfig.langTextFile );
			TraceUtil.addLine( 'GameLocalizer loadLocaleText() >>> Adding XML path...code:' + GameConfig.langCode + ', path:' + path );
			Locale.addXMLPath( GameConfig.langCode, path );
			TraceUtil.addLine( 'GameLocalizer loadLocaleText() >>> Loading language XML file...' );
			Locale.loadLanguageXML( GameConfig.langCode, this.processText );
		}

		/**
		 * Loads all assets specific to a locale that need to be loaded
		 * in the initialization phase of the game.
		 */
		protected function loadLocaleAssets():void
		{
			TraceUtil.addLine( 'GameLocalizer loadLocaleAssets() >>> Loading locale assets...' );

			for each ( var id:String in GameLocalizer.assets ) {

				this.loadAsset( id );
			}

			// Monitors the last asset's load progress and assumes that
			// all assets have been loaded if the last one has been.
			if ( id ) {

				var asset:GameAssetLoader = GameController.assetManager.getAsset( id );
				asset.addEventListener( GameEvent.ASSET_LOADED, this.assetsLoaded );

			} else {

				this.loadLocaleText();
			}
		}

		protected function assetsLoaded( event:Event ):void
		{
			TraceUtil.addLine( 'GameLocalizer assetsLoaded() >>> Locale assets have been loaded!' );
			event.currentTarget.removeEventListener( GameEvent.ASSET_LOADED, this.assetsLoaded );
			this.loadLocaleText();
		}

		/**
		 * Loads all sounds specific to a locale that need to be loaded
		 * in the initialization phase of the game.
		 */
		protected function loadLocaleSounds():void
		{
		}

		/**
		 * Loads all videos specific to a locale that need to be loaded
		 * in the initialization phase of the game.
		 */
		protected function loadLocaleVideos():void
		{
		}

		protected function processText( success:Boolean ):void
		{
			if ( success ) {

				TraceUtil.addLine( 'GameLocalizer processText() >>> Localizer has loaded the language file' );
				this.dispatchEvent( new GameEvent( GameEvent.LANGUAGE_LOADED ) );

			} else {

				TraceUtil.addLine( 'GameLocalizer processText() >>> Localizer could not load the language file' );

				var msgNo:String	= GameError.ERR_NO_1111;
				var msgTxt:String	= GameError.ERR_TXT_1111;
				var msgData:String	= 'Language code:' + GameConfig.langCode + '; path:' + GameConfig.langURL;

				GameErrorPopUp.show( msgNo, msgTxt, msgData );
			}
		}
	}
}
