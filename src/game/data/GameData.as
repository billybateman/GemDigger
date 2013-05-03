package game.data
{
	import game.utils.*;

	import flash.display.*;

	public class GameData
	{
		public static const LANG_CODE_EN:String			= 'en';
		public static const LANG_CODE_DE:String			= 'de';
		public static const LANG_CODE_FR:String			= 'fr';
		public static const LANG_CODE_IT:String			= 'it';
		public static const LANG_CODE_ES:String			= 'es';

		public static const LANG_CODE_DEFAULT:String	= GameData.LANG_CODE_EN;

		public static const LOCALE_ERR_PREFIX:String	= 'IDS_ERR_';

		public static const ASSET_TYPE_SWF:String		= 'swf';
		public static const ASSET_TYPE_TEXT:String		= 'text';
		public static const ASSET_TYPE_IMAGE:String		= 'image';
		public static const ASSET_TYPE_SOUND:String		= 'sound';
		public static const ASSET_TYPE_VIDEO:String		= 'video';

		public static const REQUEST_URL_PROD:String		= 'https://www.quibids.com/ajax/games/request.php';
		public static const REQUEST_URL_DEV:String		= 'https://www.dev1.okc.quibids.com/ajax/games/request.php';
		public static const SUPPORT_URL:String			= 'http://www.quibids.com/help/support.php';
		public static const GAME_OVER_URL:String		= 'https://www.quibids.com/gameplay/claim.php';

		/**
		 * The stage variable is used so classes not in the display list can also
		 * access the stage, for instance the LevelManager.
		 */
		public static var stage:Stage;

		/**
		 * The main variable contains a reference to the main Flash document.
		 */
		public static var main:DisplayObject;

		/**
		 * Contains the name of the next scene to be loaded by the
		 * SceneManager. Set this during the initialization phase
		 * of the game so the GameInitializer knows which scene to
		 * load first.
		 */
		public static var nextScene:String;

		/**
		 * Contains all the sounds that will be initialized
		 * by the SoundManager.
		 */
		public static var sound:Object	= new Object();

		/**
		 * Contains all the scenes that will be initialized
		 * by the SceneManager.
		 */
		public static var scene:Object	= new Object();

		/**
		 * Run the game as a standalone version?
		 * 
		 * Used ONLY for test purposes.
		 */
		public static var standalone:Boolean = false;

		/**
		 * Contains the gateway to which the NetConnection will connect.
		 */
		public static var gateway:String;

		/**
		 * The URL to which the game navigates if the user
		 * clicks the support button on the GameErrorPopUp.
		 */
		public static var supportURL:String;

		/**
		 * Contains the languages available for this game.
		 */
		private  static var lang:Array		= new Array();

		/**
		 * Contains all external assets that will be loaded
		 * during the game.
		 */
		private  static var asset:Object	= new Object();

		private static var _gameID:String;
		private static var _gameSize:String;
		private static var _gameName:String;
		private static var _gameVersion:String;

		public function GameData()
		{
		}

		/**
		 * Initializes the languages in which the game is available.
		 * 
		 * @param code: language code
		 */
		public static function addLanguage( code:String ):void
		{
			GameData.lang.push( code );
		}

		/**
		 * Adds an asset definition of type GameAsset to the asset
		 * container. Thes are assets that must be loaded from an
		 * external source. The assets can be loaded with
		 * AssetManager.loadGameAsset().
		 * 
		 * @param id:	The ID by which the asset will be identified in the game.
		 * @param name:	The asset's file name.
		 * @param type:	The asset type. Should be a GameData.ASSET_TYPE.
		 */
		public static function setAsset( id:String, name:String, type:String ):void
		{
			var asset:GameAsset 	= new GameAsset();
			asset.id				= id;
			asset.name				= name;
			asset.type				= type;
			GameData.asset[ id ]	= asset;
			
			TraceUtil.addLine( 'GameData setAsset >>> id:' + id + ' name:' + name + ' type:' + type + ' asset:' + asset );
		}

		/**
		 * Retrieves the GameAsset from the asset container.
		 */
		public static function getAsset( id:String ):GameAsset
		{
			return ( GameData.asset[ id ] ) ? GameData.asset[ id ] as GameAsset : null;
		}

		/**
		 * Returns the number of available languages for the game.
		 */
		public static function getNumLang():uint
		{
			return GameData.lang.length;
		}

		/**
		 * Tests if a language is available for this game. The language is made
		 * available by adding it with the addLanguage() method.
		 */
		public static function langAvailable( code:String ):Boolean
		{
			for ( var lang:String in GameData.lang ) {

				if ( lang == code ) return true;
			}

			return false;
		}

		/**
		 * Adds a scene definition to the scene container. The scene definitions
		 * are retrieved and the actual scenes created by the SceneManager.
		 */
		public static function setScene( name:String, scene:Class ):void
		{
			GameData.scene[ name ] = scene;
		}

		/**
		 * Retrieves a scene definition from the scene container.
		 */
		public static function getScene( name:String ):Class
		{
			return ( GameData.scene[ name ] ) ? GameData.scene[ name ] : null;
		}

		/**
		 * Adds a sound definition of type GameSound to the sound
		 * container. Sound definitions are retrieved and the actual
		 * sounds created by the SoundManager.
		 * 
		 * @param id:		The ID by which the sound will be identified in the game.
		 * @param type:		The sound type. Possible values are defined in the
		 * 					SoundManager class.
		 * @param sndClass:	The class of the actual sound.
		 * @param volume:	The initial volume to which the sound will be set Range 0 - 1.
		 * 
		 * Usage: GameData.setSound( 'drip', SoundManager.TYPE_EFFECT, PaintDrip, 0.5 );
		 */
		public static function setSound( id:String, type:String, sndClass:Class, volume:Number ):void
		{
			var sound:GameSound = new GameSound();
			sound.type			= type;
			sound.soundClass		= sndClass;
			sound.volume		= volume;
			sound.isPlaying		= false;
			sound.sound			= null;

			GameData.sound[ id ] = sound;
		}

		/**
		 * Retrieves a sound definition from the sound container.
		 */
		public static function getSound( id:String ):GameSound
		{
			return ( GameData.sound[ id ] ) ? GameData.sound[ id ] as GameSound : null;
		}

		public static function get gameID():String
		{
			return GameData._gameID;
		}

		public static function set gameID( value:String ):void
		{
			GameData._gameID = value;
		}

		public static function get gameSize():String
		{
			return GameData._gameSize;
		}

		public static function set gameSize( value:String ):void
		{
			GameData._gameSize = value;
		}

		public static function get gameName():String
		{
			return GameData._gameName;
		}

		public static function set gameName( value:String ):void
		{
			GameData._gameName = value;
		}

		public static function get gameVersion():String
		{
			return GameData._gameVersion;
		}

		public static function set gameVersion( value:String ):void
		{
			GameData._gameVersion = value;
		}

		/**
		 * A simple method with which to trace the properties
		 * of an object.
		 */
		public static function displayData( name:String, object:Object ):void
		{
			for ( var i in object ) {

				TraceUtil.addLine( 'GameData displayObject() name:' + name + ' -- ' + i + ':' + object[ i ] );
			}
		}
	}
}