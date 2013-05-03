package game.controllers
{
	import game.net.*;
	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;
	import game.objects.*;

	import flash.events.*;

	/**
	 * The Game Configurator establishes the connection to the server,
	 * loads all configuration and initial game data, and initializes
	 * the GameConfig data structure for use in the game.
	 * 
	 * @see game.data.GameConfig
	 */
	public class GameConfigurator extends EventDispatcher
	{
		private var responder:GameResponder;
		private var validator:InstanceValidator;

		public function GameConfigurator()
		{
		}

		public function start():void
		{
			if ( GameData.standalone ) {

				this.setStandalone();

			} else {

				this.setConnection();
			}
		}

		/**
		 * If the game is being played in standalone mode, the configurator
		 * only sets defaults for the most important config values. 
		 */
		protected function setStandalone():void
		{
			GameConfig.name			= GameData.gameName;
			GameConfig.langCode		= GameData.LANG_CODE_DEFAULT;
			GameConfig.defaultCode	= GameData.LANG_CODE_DEFAULT;
			GameConfig.gameURL		= '';
			GameConfig.version		= '';
			GameConfig.gameSite		= GameConfig.SITE_SHOPPIE;
			GameConfig.swf			= GameData.gameName + GameConfig.SWF_EXT;

			this.dispatchEvent( new GameEvent( GameEvent.CONFIG_LOADED, true ) );
		}

		protected function setConnection():void
		{
			// Validate that this is the only game instance.
			this.validator = new InstanceValidator();
			if ( !this.validator.isSingleInstance() ) return;

			GameData.gateway = '';

			if ( GamePreloader.isActivated ) this.setConfigVars();

			if ( !GameData.gateway ) {

				this.loadGateway();

			} else {

				this.startConfig();
			}
		}

		/**
		 * Sets configuration data obtained from the FlashVars.
		 */
		protected function setConfigVars():void
		{
			var parms:Object	= GamePreloader.parms;
			var swf:String		= ( parms.swf ) ? parms.swf : GameData.gameName + GameConfig.SWF_EXT;
			var static:String	= ( parms.static ) ? parms.static : '';
			var version:String	= ( parms.version ) ? parms.version : GameData.gameVersion;
			var gateway:String	= ( parms.url ) ? parms.url : '';
			var gpid:String		= ( parms.gpid ) ? parms.gpid : '';
			var support:String	= ( parms.support ) ? parms.support : '';
			var lang:String		= ( parms.lang ) ? parms.lang : '';
			var site:String		= ( parms.site ) ? parms.site : '';

			//TraceUtil.addLine( 'GameConfigurator setConfigVars() loader URL: ' + this.loaderInfo.url );
			TraceUtil.addLine( 'GameConfigurator setConfigVars() swf: ' + swf );
			TraceUtil.addLine( 'GameConfigurator setConfigVars() static: ' + static );
			TraceUtil.addLine( 'GameConfigurator setConfigVars() version: ' + version );
			TraceUtil.addLine( 'GameConfigurator setConfigVars() gateway: ' + gateway );
			TraceUtil.addLine( 'GameConfigurator setConfigVars() gpid: ' + gpid );
			TraceUtil.addLine( 'GameConfigurator setConfigVars() support: ' + gpid );
			TraceUtil.addLine( 'GameConfigurator setConfigVars() lang: ' + lang );
			TraceUtil.addLine( 'GameConfigurator setConfigVars() site: ' + site );

			GameConfig.name		= GameData.gameName;
			GameConfig.swf		= swf;
			GameConfig.gameURL 	= static;
			GameConfig.version	= version;
			GameConfig.langCode	= lang;
			GameConfig.gameSite = site as uint;

			GameData.supportURL	= support;

			if ( gateway ) {

				GameData.gateway = gateway + '?gpid=' + gpid;
				TraceUtil.addLine( 'GameConfigurator setConfigVars() gateway: ' + GameData.gateway );
				GameController.connection.setGateway( GameData.gateway );
			}
		}

		/**
		 * Loads the gateway for the AMF connection via an XML file.
		 */
		protected function loadGateway():void
		{
			if ( GameError.hasError ) return;
			var loader:GatewayLoader = new GatewayLoader();
			loader.addEventListener( GameNetEvent.GATEWAY_LOADED, this.gatewayLoaded );
			loader.load();
		}

		protected function gatewayLoaded( event:Event ):void
		{
			event.currentTarget.removeEventListener( GameNetEvent.GATEWAY_LOADED, this.gatewayLoaded );
			if ( GameError.hasError ) return;
			TraceUtil.addLine( 'GameConfigurator gatewayLoaded() target: ' + event.target );
			GameController.connection.setGateway( GameData.gateway );
			if ( GameError.hasError ) return;
			this.startConfig();
		}

		/**
		 * Establishes a connection to the server and loads the
		 * initial configuration data.
		 */
		protected function startConfig():void
		{
			if ( GameError.hasError ) return;
			this.establishConnection();
			if ( GameError.hasError ) return;
			this.loadConfig();
		}

		protected function establishConnection():void
		{
			TraceUtil.addLine( 'GameConfigurator >>> Establish Connection to Server' );
			GameController.connection.connect();
		}

		protected function loadConfig():void
		{
			

			if ( GameConfig.name == null ) {

				GameConfig.name			= GameData.gameName;
				GameConfig.version		= GameData.gameVersion;
			}
			
			TraceUtil.addLine( 'GameConfigurator loadConfig() GameConfig: ' + GameConfig );
			TraceUtil.addLine( 'GameConfigurator loadConfig() GameConfig.name: ' + GameConfig.name );

			this.callServer();
		}

		protected function callServer():void
		{
			GameController.responder.addEventListener( GameNetEvent.RESPONSE_RECEIVED, this.loadReceived );
			GameController.responder.addEventListener( GameNetEvent.ERROR_RECEIVED, this.errorReceived );
			GameController.connection.call();
		}

		protected function loadReceived( event:Event ):void
		{
			GameController.responder.removeEventListener( GameNetEvent.RESPONSE_RECEIVED, this.loadReceived );
			GameController.responder.removeEventListener( GameNetEvent.ERROR_RECEIVED, this.errorReceived );

			TraceUtil.addLine( 'GameConfigurator loadReceived() >>> Configuration load received!' );

			this.setLoad();
			if ( GameError.hasError ) return;
			this.setData();

			this.dispatchEvent( new GameEvent( GameEvent.CONFIG_LOADED ) );
		}

		protected function errorReceived( event:Event ):void
		{
			GameController.responder.removeEventListener( GameNetEvent.RESPONSE_RECEIVED, this.loadReceived );
			GameController.responder.removeEventListener( GameNetEvent.ERROR_RECEIVED, this.errorReceived );

			TraceUtil.addLine( 'GameConfigurator errorReceived() >>> Configuration ERROR received!' );

			var msgNo:String	= GameError.ERR_NO_1107;
			var msgTxt:String	= GameError.ERR_TXT_1107;
			var msgData:String	= '';
			var error:Object	= GameController.responder.getError();

			for ( var i in error ) {

				msgData += i + ':' + error[ i ] + '; ';
			}

			GameErrorPopUp.show( msgNo, msgTxt, msgData );
		}

		/**
		 * Sets the main configuration variables after the configuration
		 * has been loaded from the server.
		 */
		protected function setLoad():void
		{
			if ( GameError.hasError ) return;

			var response:Object		= GameController.responder.getResponse();
			var config:Object		= response.config;
			var lang:Object			= config.lang;

			GameData.displayData( 'config', config );

			GameConfig.gameOverURL	= ( config.completionUrl ) ? config.completionUrl : GameData.GAME_OVER_URL;
			GameConfig.multiplier	= config.multiplier;
			GameConfig.gameSite		= config.site;
			GameConfig.gameSize		= int( GameData.gameSize );

			TraceUtil.addLine( 'GameConfigurator setLoad() multiplier: '	+ GameConfig.multiplier );
			TraceUtil.addLine( 'GameConfigurator setLoad() gameSize: '		+ GameConfig.gameSize );
			TraceUtil.addLine( 'GameConfigurator setLoad() gameSite: '		+ GameConfig.gameSite );
			TraceUtil.addLine( 'GameConfigurator setLoad() gameURL: '		+ GameConfig.gameURL );
			TraceUtil.addLine( 'GameConfigurator setLoad() gameOverURL: '	+ GameConfig.gameOverURL );

			GameConfig.langID		= lang.id;
			GameConfig.langName		= lang.name;
			GameConfig.langCode		= lang.abbreviation;
			GameConfig.defaultCode	= GameData.LANG_CODE_DEFAULT;

			TraceUtil.addLine( 'GameConfigurator setLoad() langID: '		+ GameConfig.langID );
			TraceUtil.addLine( 'GameConfigurator setLoad() langName: '		+ GameConfig.langName );
			TraceUtil.addLine( 'GameConfigurator setLoad() langCode: '		+ GameConfig.langCode );
			TraceUtil.addLine( 'GameConfigurator setLoad() defaultCode: '	+ GameConfig.defaultCode );

			if ( GameConfig.multiplier <= 0 ) {

				GameConfig.multiplier = 1;
			}
		}

		/**
		 * This method must be overriden by the class extension
		 * so data specific to a game instance may be processed
		 * after the configuration has been loaded.
		 */
		protected function setData():void
		{
		}

		/**
		 * Sets the remaining configuration variables (language) after the game
		 * has been loaded as part of the game initialization process.
		 */
		public function setConfig():void
		{
			if ( GameError.hasError ) return;
			this.setLanguage();
		}

		/**
		 * The lanugage configuration is necessary for game localization
		 * and must therefore be completed before the localization process
		 * begins.
		 */
		public function setLanguage():void
		{
			if ( GameError.hasError ) return;

			var path:String				= URLUtils.join( GameConfig.gameURL, GameConfig.LANG_DIR );
			GameConfig.langURL			= URLUtils.join( path, GameConfig.langCode );
			GameConfig.langSwfURL		= URLUtils.join( GameConfig.langURL, GameConfig.SWF_DIR );
			GameConfig.langTextURL		= URLUtils.join( GameConfig.langURL, GameConfig.TEXT_DIR );
			GameConfig.langImageURL		= URLUtils.join( GameConfig.langURL, GameConfig.IMAGE_DIR );
			GameConfig.langSoundURL		= URLUtils.join( GameConfig.langURL, GameConfig.SOUND_DIR );
			GameConfig.langVideoURL		= URLUtils.join( GameConfig.langURL, GameConfig.VIDEO_DIR );
			GameConfig.langTextFile		= GameConfig.name + GameConfig.UNDER_SCORE + GameConfig.langCode + GameConfig.XML_EXT;

			GameConfig.defaultURL		= URLUtils.join( path, GameConfig.defaultCode );
			GameConfig.defaultSwfURL	= URLUtils.join( GameConfig.defaultURL, GameConfig.SWF_DIR );
			GameConfig.defaultTextURL	= URLUtils.join( GameConfig.defaultURL, GameConfig.TEXT_DIR );
			GameConfig.defaultImageURL	= URLUtils.join( GameConfig.defaultURL, GameConfig.IMAGE_DIR );
			GameConfig.defaultSoundURL	= URLUtils.join( GameConfig.defaultURL, GameConfig.SOUND_DIR );
			GameConfig.defaultVideoURL	= URLUtils.join( GameConfig.defaultURL, GameConfig.VIDEO_DIR );
			GameConfig.defaultTextFile	= GameConfig.name + GameConfig.UNDER_SCORE + GameConfig.defaultCode + GameConfig.XML_EXT;

			TraceUtil.addLine( 'GameConfigurator setLanguage() langCode: '		+ GameConfig.langCode );
			TraceUtil.addLine( 'GameConfigurator setLanguage() langTextFile: '	+ GameConfig.langTextFile );
			TraceUtil.addLine( 'GameConfigurator setLanguage() langSwfURL: '	+ GameConfig.langSwfURL );
			TraceUtil.addLine( 'GameConfigurator setLanguage() langTextURL: '	+ GameConfig.langTextURL );
			TraceUtil.addLine( 'GameConfigurator setLanguage() langImageURL: '	+ GameConfig.langImageURL );
			TraceUtil.addLine( 'GameConfigurator setLanguage() langSoundURL: '	+ GameConfig.langSoundURL );
			TraceUtil.addLine( 'GameConfigurator setLanguage() langVideoURL: '	+ GameConfig.langVideoURL );

			TraceUtil.addLine( 'GameConfigurator setLanguage() defaultCode: '		+ GameConfig.defaultCode );
			TraceUtil.addLine( 'GameConfigurator setLanguage() defaultTextFile: '	+ GameConfig.defaultTextFile );
			TraceUtil.addLine( 'GameConfigurator setLanguage() defaultSwfURL: '		+ GameConfig.defaultSwfURL );
			TraceUtil.addLine( 'GameConfigurator setLanguage() defaultTextURL: '	+ GameConfig.defaultTextURL );
			TraceUtil.addLine( 'GameConfigurator setLanguage() defaultImageURL: '	+ GameConfig.defaultImageURL );
			TraceUtil.addLine( 'GameConfigurator setLanguage() defaultSoundURL: '	+ GameConfig.defaultSoundURL );
			TraceUtil.addLine( 'GameConfigurator setLanguage() defaultVideoURL: '	+ GameConfig.defaultVideoURL );
		}
	}
}