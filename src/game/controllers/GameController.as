package game.controllers
{
	import game.net.*;
	import game.data.*;
	import game.text.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;
	import game.objects.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	/**
	 * The game controller can be seen as a master controller that controls
	 * specialized game controllers.
	 */
	public class GameController extends Sprite
	{
		private static var _instance:GameController;

		public static var connection:GameConnection;
		public static var responder:GameResponder;
		public static var sceneManager:SceneManager;
		public static var soundManager:SoundManager;
		public static var assetManager:AssetManager;
		public static var prizeManager:PrizeManager;
		public static var configurator:GameConfigurator;
		public static var initializer:GameInitializer;
		public static var localizer:GameLocalizer;

		protected var initialized:Boolean;

		private var validator:InstanceValidator;

		public function GameController()
		{
			GameController._instance = this;
			this.init();
		}

		public static function get instance():GameController
		{
			return _instance;
		}

		public static function setConnection( connection:GameConnection ):void
		{
			GameController.connection = connection;
		}

		public static function setResponder( responder:GameResponder ):void
		{
			GameController.responder = responder;
		}

		public static function setInitializer( initializer:GameInitializer ):void
		{
			GameController.initializer = initializer;
		}

		public static function setLocalizer( localizer:GameLocalizer ):void
		{
			GameController.localizer = localizer;
		}

		public static function setConfigurator( configurator:GameConfigurator ):void
		{
			GameController.configurator = configurator;
		}

		public static function setPrizeManager( manager:PrizeManager ):void
		{
			GameController.prizeManager = manager;
		}

		public static function setSoundManager( manager:SoundManager ):void
		{
			GameController.soundManager = manager;
		}

		public static function setAssetManager( manager:AssetManager ):void
		{
			GameController.assetManager = manager;
		}

		public static function setSceneManager( manager:SceneManager ):void
		{
			GameController.sceneManager = manager;
		}

		protected function init():void
		{
			if ( GameError.hasError ) return;

			TraceUtil.addLine( 'GameController init() loader URL: ' + this.loaderInfo.url );

			TraceUtil.addLine( '' );
			TraceUtil.addLine( '****************************************' );
			TraceUtil.addLine( '***   QuiBids Flash Game Library        ' );
			TraceUtil.addLine( '***                                     ' );
			TraceUtil.addLine( '***   Version: 2.0                      ' );
			TraceUtil.addLine( '***   Date:    February 2012            ' );
			TraceUtil.addLine( '***   Class:   GameController           ' );
			TraceUtil.addLine( '***                                     ' );
			TraceUtil.addLine( '***   QuiBids Flash Game Library        ' );
			TraceUtil.addLine( '****************************************' );
			TraceUtil.addLine( '*' );
			TraceUtil.addLine( '* ' + GameData.gameName );
			TraceUtil.addLine( '*' );
			TraceUtil.addLine( '****************************************' );

			GameController.initializer.start();
		}

		public static function gameOver():void
		{
			TraceUtil.addLine( 'GameController >>> GAME OVER' );

			if ( !GameData.standalone ) {

				var request:URLRequest = new URLRequest( GameConfig.gameOverURL );

				TraceUtil.addLine( 'GameController gameOver() gameOverURL: ' + GameConfig.gameOverURL );

				try {

					navigateToURL( request, '_self' );

				} catch ( error:Error ) {

					TraceUtil.addLine( 'GameController gameOver() ==> ERROR: ' + error.message );

					var msgNo:String	= GameError.ERR_NO_1106;
					var msgTxt:String	= GameError.ERR_TXT_1106;
					var msgData:String	= 'URL: ' + ( GameConfig.gameOverURL ? GameConfig.gameOverURL : '' );

					GameError.setError( msgNo, msgTxt, msgData );
				}
			}
		}
	}
}