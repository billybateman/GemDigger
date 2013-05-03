package data
{
	import fonts.*;
	import sounds.*;
	import scenes.*;
	//import buttons.*;
	//import objects.*;
	import controllers.*;
	
	import game.net.*;
	import game.data.*;
	import game.events.*;
	import game.text.*;
	import game.utils.*;
	import game.errors.*;
	import game.buttons.*;
	import game.objects.*;
	import game.controllers.*;
	
	import flash.net.*;
	import flash.events.*;
	import flash.display.*;
	
	//import com.greensock.plugins.*;
	
	/**
	 * Initializes and sets all relevant game data. This allows for easier access
	 * to game data (except for configuration data) since everything is in one
	 * place and therefore easier to find.
	 * 
	 * Configuration data is loaded by the GameConfigurator and stored in
	 * the GameConfig class.
	 */
	public class MainData extends GameData
	{
		private static const INSTANCE_ID:String			= '6';
		private static const INSTANCE_NAME:String		= 'Main';
		private static const INSTANCE_VERSION:String	= '1.0';
		private static const INSTANCE_SIZE:String		= '3452425';
		
		private static const PASSWORD:String =
			'MaMRADQ0NDTN9PRl2RhU3WTR4jU4rOMc' +
			'odA1srkIhiFXQhQE/9+OWU9NwKf4RdLe' +
			'T966xoTi89j1cwl5Hdgrj2nHMQK2RzEv' +
			'rEOi5sSBSvPugqdELDekKPUTzP5DkB26' +
			'viKoAbMzbUyzoBOop2i5dzbQEYQ75OOE' +
			'3Frg6l9YJXytkqhtu2enYFSHlPQnkCaA' +
			'1G+6lDfhO1/QCuBU3Rn3TZsM/dkyQ6//' +
			'g7eO0VbozJhvKievyd82pBLzv0217e6l' +
			'xF2JP9Ywy++/oZJ3rdNsHKlGBmD9lcME' +
			'EmJAvuBX9d68gIAsGI6q7slzR5zgLhwl' +
			'L1mwvncrIFdHWGV7rnpCj/wim253Upmc' +
			'1pKeIgH7TtTGPPaL3DMBgHn2dheVIIOO' +
			'rg3sBP+7A8fM+QHaCrFWODZsqvIR4cGg' +
			'iDEh0+5Qt04XqQH4H1Zw5MDnnDfaCe10' +
			'66F7GaKSoI0eecKc2Hh5iapWv7WC/kng';
		
		public static const AMF_GATEWAY:String = 'http://www.bbateman.hq.quibids.com/ajax/games/newgame.php';
		
		public static const CONN_METHOD_INIT:String		= 'NewGame.init';
		public static const CONN_METHOD_PLAY:String		= 'NewGame.play';
		public static const CONN_METHOD_START:String	= 'NewGame.start';
		public static const CONN_METHOD_OVER:String		= 'NewGame.finish';
		public static const CONN_METHOD_ERROR:String	= 'NewGame.error';
	
		public static const FONT_ARIAL_BLACK:String			= 'ArialBlack';
		public static const FONT_DOWNCOME:String			= 'Downcome';
		
		public static const SOUND_TRACK:String			= 'soundtrack';
		
		public static var step:uint			= 0;
		public static var maxSteps:uint		= 0;
		public static var maxTime:uint		= 0;
		public static var time:uint			= 0;
		public static var percent:uint		= 0;
		public static var cleared:uint		= 0;
		public static var bonusPercent:uint	= 0;
		public static var bonusCleared:uint	= 0;
		public static var totalPoints:uint	= 0;
		public static var totalBids:uint	= 0;
		public static var totalScore:uint	= 0;
		

		public function MainData()
		{
		}
		
		/**
		 * These are variables and utilities that may change
		 * for testing purposes and are therefore kept together
		 * and at the top of the class for easier access.
		 */
		public static function initGameVars():void
		{
			TraceUtil.addLine( 'MainData initGameVars() >>> Initializing game variables...' );
			
			// true:	Game runs with NO server connection.
			// false:	Game runs WITH server connection.
			GameData.standalone = true;
			
			// true:	Trace is directed to the Flash trace statement.
			// false:	Trace is NOT directed to the Flash trace statement.
			TraceUtil.flashTrace = true;
			
			// true:	Trace is directed to the Monster Debugger.
			// false:	Trace is NOT directed to the Monster debugger.
			TraceUtil.monsterTrace = true;
			
			// Sets a line number for each trace statement.
			TraceUtil.useLineNo = true;
			
			// If used, this statement activates the Monster Debugger.
			// If not used, the Monster Debugger will not be activated
			// and no trace statements will be directed to the Monster
			// Debugger
			TraceUtil.start();
			
			// If activated, lists the embedded fonts used in this game. 
			//FontTracer.traceFonts();
			
			// Starts the framerate utility that displays the game's
			// framerate in the upper righthand corner of the game.
			//FPSUtil.start();
			
			// Starts the memory uitility that displays the game's
			// memory allocation in the lower righthand corner of the game.
			//MemUtil.start();
		}
		
		/**
		 * These are things that need to be done before the actual game
		 * itself can be initialized, like initializing preliminary game
		 * variables, configuration, communication, and utilities.
		 */
		public static function initMain( main:DisplayObject ):void
		{
			TraceUtil.addLine( 'MainData initMain() >>> Initializing main data...' );
			
			GameData.main	= main;
			GameData.stage	= main.stage;
			
			MainData.initInstance();
			MainData.initFonts();
			
			// At this point the primary game variables
			// and utilities will be initialized. This must
			// be run after the methods above and before
			// the controller is initialized because the
			// controller relies on this information.
			MainData.initGameVars();
			
			MainData.initLang();
			MainData.initImages();
			MainData.initGreensock();
			MainData.initEncryption();
			MainData.initErrorPopUp();
			
			MainData.initController();
		}
		
		/**
		 * These are things that are specific to the game and
		 * need to be initialized after the game configuration
		 * has been loaded, such as sounds, scenes, and levels.
		 */
		public static function initGame():void
		{
			TraceUtil.addLine( 'MainData initGame() >>> Initializing game data...' );
			
			GameConfig.langCode = ( GameConfig.langCode ) ? GameConfig.langCode : GameData.LANG_CODE_DEFAULT;
			GameConfig.gameSite = ( GameConfig.gameSite ) ? GameConfig.gameSite : GameConfig.SITE_SHOPPIE;
			
			TraceUtil.addLine( 'MainData initGame() langCode:' + GameConfig.langCode );
			TraceUtil.addLine( 'MainData initGame() gameSite:' + GameConfig.gameSite );
			
			MainData.initSounds();
			MainData.initScenes();
		}
		
		public static function initInstance():void
		{
			TraceUtil.addLine( 'MainData initInstance() >>> Initializing instance data...' );
			
			GameData.gameID			= MainData.INSTANCE_ID;
			GameData.gameSize		= MainData.INSTANCE_SIZE;
			GameData.gameName		= MainData.INSTANCE_NAME;
			GameData.gameVersion	= '';
		}
		
		public static function initController():void
		{
			TraceUtil.addLine( 'MainData initControllers() >>> Initializing controllers...' );
			
			GameController.setLocalizer( LocaleController.instance );
			GameController.setInitializer( InitController.instance );
			GameController.setConfigurator( ConfigController.instance );
			GameController.setPrizeManager( PrizeController.instance );
			GameController.setSoundManager( SoundController.instance );
			GameController.setSceneManager( SceneController.instance );
			GameController.setAssetManager( AssetController.instance );
			
			GameData.gateway	= MainData.AMF_GATEWAY;
			GameData.supportURL = GameData.SUPPORT_URL;
			
			TraceUtil.addLine( 'MainData initController >>> Initializing Gateway AMF Connection to ' + GameData.gateway );
			
			
			GameError.setMethod( MainData.CONN_METHOD_ERROR );
			
			var connection:AMFConnection = new AMFConnection();
			var responder:GameResponder = new GameResponder();
			connection.setGateway( GameData.gateway );
			connection.setMethod( MainData.CONN_METHOD_INIT );
			connection.setParm( new Object() );
			
			GameController.setConnection( connection  );
			GameController.setResponder( responder );
		}
		
		public static function initFonts():void
		{
			TraceUtil.addLine( 'MainData initFonts() >>> Initializing fonts...' );
			
			GameFont.setFont( GameFont.FONT_ARIAL_BLACK, 			ArialBlack );
			// Use the code snippet below to add more fonts to the game:
			 GameFont.setFont( MainData.FONT_DOWNCOME, 	Downcome );
		}
		
		public static function initLang():void
		{
			TraceUtil.addLine( 'MainData initLang() >>> Setting available languages...' );
			
			GameData.addLanguage( GameData.LANG_CODE_EN );
			GameData.addLanguage( GameData.LANG_CODE_DE );
		}
		
		/**
		 * Defines any language (but not site) dependent SWF files. If the SWF
		 * will definitely be used in the game, they can also be selected for
		 * loading by the GameLocalizer. Otherwise they should be loaded in
		 * the initalization phase of the scene in which they'll be used.
		 */
		public static function initSWF():void
		{
			TraceUtil.addLine( 'MainData initSWF() >>> Defining SWF assets...' );
			
			var version:String	= ( GameConfig.version ) ? '.' + GameConfig.version : '';
			
			// Define assets.
			//var file:String = MainData.SWF_HOW_TO + version + GameConfig.SWF_EXT;
			//GameData.setAsset( MainData.SWF_HOW_TO,	file, GameData.ASSET_TYPE_SWF );
		}
		
		/**
		 * Defines any language (but not site) dependent images. If the images
		 * will definitely be used in the game, they can also be selected for
		 * loading by the GameLocalizer. Otherwise they should be loaded in
		 * the initalization phase of the scene in which they'll be used.
		 */
		public static function initImages():void
		{
			TraceUtil.addLine( 'MainData initImages() >>> Defining localized image assets...' );
			
			// Define assets.
			//GameData.setAsset( MainData.IMAGE_CONGRATS,		MainData.FILE_CONGRATS,		GameData.ASSET_TYPE_IMAGE );
			
			// Select for loading by GameLocalizer
			//GameLocalizer.addAsset( MainData.IMAGE_CONGRATS );
		}
		
		/**
		 * Initializes any Greensock plugins needed in the game.
		 */
		public static function initGreensock():void
		{
			TraceUtil.addLine( 'MainData initGreensock() >>> Initializing Greensock plugins...' );
			// Activate the Greensock motionBlur plugin
			//TweenPlugin.activate( [ MotionBlurPlugin ] );
		}
		
		/**
		 * Initializes the game's encryption key. Can also be used to create a
		 * new encrypted password.
		 */
		public static function initEncryption():void
		{
			TraceUtil.addLine( 'MainData initEncryption() >>> Initializing game encryption...' );
			
			// Activate this statement to create a new PASSWORD for the game.
			//GameEncryption.initEncryptionKey( 'dadc79568277776158c36a17ed4c66a3' );
			
			// Set the encryption key for this game.
			GameEncryption.encryptionKey = GameEncryption.getEncryptionKey( MainData.PASSWORD );
			//TraceUtil.addLine( 'MainData() encryptionKey: ' + GameEncryption.encryptionKey );
		}
		
		public static function initErrorPopUp():void
		{
			TraceUtil.addLine( 'MainData initErrorPopUp() >>> Initializing error popup...' );
			
			GameErrorPopUp.fontTitle	= MainData.FONT_ARIAL_BLACK;
			GameErrorPopUp.fontText		= MainData.FONT_ARIAL_BLACK;
			GameErrorPopUp.fontData		= MainData.FONT_ARIAL_BLACK;
			
			GameErrorPopUp.sizeTitle	= 28;
			GameErrorPopUp.sizeText		= 22;
			GameErrorPopUp.sizeData		= 22;
			
			GameErrorPopUp.colorTitle	= 0x6C1805;
			GameErrorPopUp.colorText	= 0x302520;
			GameErrorPopUp.colorData	= 0x302520;
			
			GameErrorPopUp.glowTitle	= 0x6C1805;
			GameErrorPopUp.glowText		= 0x302520;
			GameErrorPopUp.glowData		= 0x302520;
			
			GameErrorPopUp.blurTitle	= 2;
			GameErrorPopUp.blurText		= 1;
			GameErrorPopUp.blurData		= 1;
			
			GameErrorPopUp.posTitleX	= 25;
			GameErrorPopUp.posTitleY	= 25;
			GameErrorPopUp.widthTitle	= 480;
			
			GameErrorPopUp.posTextX		= 25;
			GameErrorPopUp.posTextY		= 70;
			GameErrorPopUp.widthText	= 480;
			
			GameErrorPopUp.posDataX		= 25;
			GameErrorPopUp.posDataY		= 170;
			GameErrorPopUp.widthData	= 480;
			
			GameErrorPopUp.posBtnX		= 50;
			GameErrorPopUp.posBtnY		= 275;
		}
		
		/**
		 * Defines all site dependent assets for loading.
		 */
		public static function initSite():void
		{
			TraceUtil.addLine( 'MainData initSite() >>> Defining site dependent assets...site:' + GameConfig.gameSite );
			
			GameConfig.gameSite = GameConfig.SITE_QUIBIDS;
			
		}
		
		public static function initScenes():void
		{
			TraceUtil.addLine( 'MainData initScenes() >>> Initializing game scenes...' );
			
			GameData.setScene( HelpScene.SCENE_NAME,	HelpScene );
			GameData.setScene( MainScene.SCENE_NAME,	MainScene );
			GameData.setScene( SummaryScene.SCENE_NAME,	SummaryScene );
			
			if ( GameData.standalone ) {
				GameData.nextScene = HelpScene.SCENE_NAME;
				MainData.step = 0;
			}
		}
		
		public static function initSounds():void
		{
			TraceUtil.addLine( 'MainData initSounds() >>> Initializing game sounds...' );
			
			GameData.setSound( MainData.SOUND_TRACK,SoundManager.TYPE_SOUNDTRACK,	SoundTrack,	0.2 );
		}
		
		public static function initCustomerSupportBtn():void
		{
			TraceUtil.addLine( 'MainData initCustomerSupportBtn() >>> Initializing customer support button...' );
			
			
		}
		
		/**
		 * Redirects from the game configurator so data specific
		 * to this game may be initialized here.
		 */
		public static function setData():void
		{
			TraceUtil.addLine( 'MainData setData() >>> Setting game configuration data...' );
			
			GameError.catchActionScriptError( MainData.setInitData );
		}
		
		public static function setPlay():void
		{
			GameError.catchActionScriptError( MainData.setPlayData );
		}
		
		/**
		 * Sets data received from an AMF call to server method NewGame.init
		 */
		public static function setInitData():void
		{
			//MainData.initCustomerSupportBtn();
			MainData.initSite();
			MainData.initSWF();
			MainData.setGameSettings();
			MainData.setScore();
			MainData.setPlays();
			
		}
		
		/**
		 * Sets data received from an AMF call to server method NewGame.play
		 */
		public static function setPlayData():void
		{
			MainData.setScore();
			MainData.setPlays();
		}
		
		public static function setGameSettings():void
		{
			var response:Object	= GameController.responder.getResponse();
			var settings:Object	= response.settings;
			//GameData.displayData( 'settings', settings );
			MainData.time		= settings.allotedTime;
			MainData.maxTime	= settings.allotedTime;
			MainData.maxSteps	= settings.maxPlays;
		}
		
		public static function setScore():void
		{
			var response:Object	= GameController.responder.getResponse();
			var score:Object	= response.score;
			
			//GameData.displayData( 'score', score );
			
			MainData.percent = score.percent;
			MainData.cleared = score.cleared;
			
			if ( GameConfig.gameSite == GameConfig.SITE_QUIBIDS ) {
				
				MainData.bonusCleared	= score.colorsClearedBids;
				MainData.bonusPercent	= score.percentCapturedBids;
				MainData.totalBids		= score.totalBids;
				
			} else {
				
				MainData.bonusCleared	= score.colorsClearedPoints;
				MainData.bonusPercent	= score.percentCapturedPoints;
				MainData.totalPoints	= score.totalPoints;
			}
		}
		
		public static function setPlays():void
		{
			var response:Object	= GameController.responder.getResponse();
			var plays:Array		= response.plays;
			var numPlays:uint	= plays.length;
			
			if ( numPlays > 0 ) {
				
				var last:uint = numPlays - 1;
				var lastPlay:Object = plays[ last ];
				var color:String = lastPlay.color;
				var time:uint = lastPlay.time;
				MainData.time = time;
				MainData.step = numPlays;
				
			} else {
				
				MainData.step = 0;
			}
			
			//GameData.displayData( 'plays', plays );
			TraceUtil.addLine( 'MainData setPlays() plays.length (step):' + numPlays + ' time:' + MainData.time );
		}
		
		public static function sendOver():void
		{
			
			if ( !GameData.standalone ) {
				TraceUtil.addLine( 'MainData sendOver() >>> Sending over to server' );
				
				GameController.connection.setMethod( MainData.CONN_METHOD_OVER );
				GameController.connection.setParm( new Object() )
				
				GameController.responder.addEventListener( GameNetEvent.RESPONSE_RECEIVED, MainData.finishReceived );
				GameController.responder.addEventListener( GameNetEvent.ERROR_RECEIVED, MainData.errorReceived );
				GameController.connection.call();
			}
			
		}
		
		
		public static function sendStart():void
		{
			
			if ( !GameData.standalone ) {
				TraceUtil.addLine( 'MainData sendStart().' );
				
				// This checks the step returned to the game during loading, use this to know what step in game the user is at.
				// anything greater than 0 means the user has already past the 1 step of sendStart
				//TraceUtil.addLine( 'You should be moved to step:' + MainData.step);
				
				if ( MainData.step > 1 ) return;
				
				TraceUtil.addLine( 'MainData sendStart() >>> Sending start to server' );
				
				GameController.connection.setMethod( MainData.CONN_METHOD_START );
				GameController.connection.setParm( new Object() )
				
				GameController.responder.addEventListener( GameNetEvent.RESPONSE_RECEIVED, MainData.startReceived );
				GameController.responder.addEventListener( GameNetEvent.ERROR_RECEIVED, MainData.errorReceived );
				GameController.connection.call();
			}
		}
		
		public static function startReceived( event:Event ):void
		{
			TraceUtil.addLine( 'MainData startReceived().' );
			
			GameController.responder.removeEventListener( GameNetEvent.RESPONSE_RECEIVED, MainData.startReceived );
			GameController.responder.removeEventListener( GameNetEvent.ERROR_RECEIVED, MainData.errorReceived );
		}
		
		public static function finishReceived( event:Event ):void
		{
			GameController.responder.removeEventListener( GameNetEvent.RESPONSE_RECEIVED, MainData.finishReceived );
			GameController.responder.removeEventListener( GameNetEvent.ERROR_RECEIVED, MainData.errorReceived );
			
			var response:Object	= GameController.responder.getResponse();
			var redirect:String	= response.redirect;
			
			GameConfig.gameOverURL = redirect;
			GameController.gameOver();
		}
		
		public static function responseReceived( event:Event ):void
		{
			TraceUtil.addLine( 'MainData responseReceived() >>> data response from server' );
			
			GameController.responder.removeEventListener( GameNetEvent.RESPONSE_RECEIVED, MainData.responseReceived );
			GameController.responder.removeEventListener( GameNetEvent.ERROR_RECEIVED, MainData.errorReceived );
			
			if ( GameError.hasError ) return;
		}
		
		public static function errorReceived( event:Event ):void
		{
			TraceUtil.addLine( 'MainData errorReceived().' );
			
			GameController.responder.removeEventListener( GameNetEvent.RESPONSE_RECEIVED, MainData.responseReceived );
			GameController.responder.removeEventListener( GameNetEvent.ERROR_RECEIVED, MainData.errorReceived );
			
			if ( GameError.hasError ) return;
			
			var error:Object = GameController.responder.getError();
			var msgNo:String	= error.faultCode;
			var msgTxt:String	= error.faultString;
			var msgData:String	= '';
			
			GameErrorPopUp.show( msgNo, msgTxt, msgData );
		}
		
		public static function resetGame():void
		{
			TraceUtil.addLine( 'MainData resetGame()' );
			
			if ( GameData.standalone ) {
				MainData.step = 0;
			}
		}
		
	}
}