package game.controllers
{
	import game.net.*;
	import game.data.*;
	import game.text.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;
	import game.objects.*;
	import game.animations.*;

	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.system.*;
	import flash.display.*;

	/**
	 * The preloader loads the main game SWF and displays the progress
	 * of the load process to the user in a (hopefully) entertaining manner.
	 */
	public class GamePreloader extends Sprite
	{
		private const END_DELAY:int		= 3000;
		private const WAIT_DELAY:int	= 2000;

		protected static var activated:Boolean	= false;

		public static var parms:Object			= new Object();
		public static var sceneLoaded:Boolean	= false;

		private var loader:Loader;
		private var timer:Timer;

		private var gameURL:String;

		private var gameSize:int;
		private var startDelay:int;
		private var bytesLoaded:uint;

		private var validator:InstanceValidator;

		protected var scene:Sprite;

		protected static var progressBar:ProgressBar;

		public function GamePreloader()
		{
			this.init();
		}

		/**
		 * Set the progress bar that is to be used with this preloader.
		 */
		public static function setProgressBar( progressBar:ProgressBar ):void
		{
			GamePreloader.progressBar = progressBar;
		}

		public static function get isActivated():Boolean
		{
			return GamePreloader.activated;
		}

		protected function init():void
		{
			if ( GameError.hasError ) return;

			// Set whether game is started via preloader
			GamePreloader.activated = true;

			// Make parms available to configurator
			GamePreloader.parms = this.loaderInfo.parameters;

			TraceUtil.addLine( '' );
			TraceUtil.addLine( '****************************************' );
			TraceUtil.addLine( '***   QuiBids Flash Game Library        ' );
			TraceUtil.addLine( '***                                     ' );
			TraceUtil.addLine( '***   Version: 2.0                      ' );
			TraceUtil.addLine( '***   Date:    February 2012            ' );
			TraceUtil.addLine( '***   Class:   GamePreloader            ' );
			TraceUtil.addLine( '***                                     ' );
			TraceUtil.addLine( '***   QuiBids Flash Game Library        ' );
			TraceUtil.addLine( '****************************************' );
			TraceUtil.addLine( '' );

			GameController.configurator.addEventListener( GameEvent.CONFIG_LOADED, this.configLoaded );
			GameController.configurator.start();
		}

		/**
		 * Loads configuration data via the GameConfigurator.
		 */
		protected function configLoaded( event:Event ):void
		{
			GameController.configurator.removeEventListener( GameEvent.CONFIG_LOADED, this.configLoaded );
			if ( GameError.hasError ) return;
			this.loadGame();
		}

		/**
		 * Loads the game SWF.
		 */
		protected function loadGame():void
		{
			if ( GameError.hasError ) return;

			this.gameURL	= URLUtils.join( GameConfig.gameURL, GameConfig.swf );
			this.gameSize	= ( GameConfig.gameSize == -1 ) ? int( GameData.gameSize ) : GameConfig.gameSize;

			TraceUtil.addLine( 'GamePreloader loadGame() gameURL: ' + this.gameURL );
			TraceUtil.addLine( 'GamePreloader loadGame() gameSize: ' + this.gameSize );

			this.bytesLoaded = 0;
			this.addEventListener( Event.ENTER_FRAME, this.progress );

			this.loader = new Loader();
			this.loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, this.loadError );
			this.loader.contentLoaderInfo.addEventListener( Event.COMPLETE, this.gameLoaded );

			TraceUtil.addLine( 'GamePreloader loadGame() >>> Loading game...' );

			TraceUtil.addLine( '' );
			TraceUtil.addLine( '****************************************' );
			TraceUtil.addLine( '* Loading ' + GameConfig.swf );
			TraceUtil.addLine( '****************************************' );
			TraceUtil.addLine( '' );

			try {

				this.loader.load( new URLRequest( this.gameURL ) );

			} catch ( error:Error ) {

				TraceUtil.addLine( 'GamePreloader loadGame() ==> ERROR -- ID:' + error.errorID + ', name: ' + error.name + ', message:' + error.message );

				var msgNo:String	= GameError.ERR_NO_1108;
				var msgTxt:String	= GameError.ERR_TXT_1108;
				var msgData:String	= 'Error: ' + error.errorID + ' ' + error.message;

				GameErrorPopUp.show( msgNo, msgTxt, msgData );
			}
		}

		protected function loadError( event:ErrorEvent ):void
		{
			TraceUtil.addLine( 'GamePreloader loadError() ==> ERROR: ' + event.errorID + ' ' + event.text );

			var msgNo:String	= GameError.ERR_NO_1109;
			var msgTxt:String	= GameError.ERR_TXT_1109;
			var msgData:String	= 'Error: ' + event.errorID.toString();

			GameErrorPopUp.show( msgNo, msgTxt, msgData );
		}

		/**
		 * When the game has completely loaded, the completion is displayed on the screen.
		 */
		protected function gameLoaded( event:Event ):void
		{
			this.removeEventListener( Event.ENTER_FRAME, this.progress );
			this.loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, this.gameLoaded );
			this.loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, this.loadError );

			TraceUtil.addLine( 'GamePreloader gameLoaded() >>> Game has completely loaded' );

			GamePreloader.progressBar.addEventListener( GameEvent.ANIMATION_COMPLETE, this.delayWait );
			GamePreloader.progressBar.progress( 1 );
		}

		/**
		 * Displays the load progress in the progress bar.
		 */
		protected function progress( event:Event ):void
		{
			var ratio:Number;

			if ( this.stage.loaderInfo.bytesLoaded > this.bytesLoaded ) {

				this.bytesLoaded	= this.stage.loaderInfo.bytesLoaded;
				ratio				= ( this.gameSize == 0 ) ? 0 : this.bytesLoaded / this.gameSize;

				GamePreloader.progressBar.progress( ratio );

				if ( ratio == 1 ) this.removeEventListener( Event.ENTER_FRAME, this.progress );
			}
		}

		/**
		 * Give the preloader a moment to display that it has loaded 100% of the game,
		 * otherwise the first game screen would be displayed before the load process
		 * has displayed completely, which can be irritating for the user.
		 */
		protected function delayWait( event:Event ):void
		{
			GamePreloader.progressBar.removeEventListener( GameEvent.ANIMATION_COMPLETE, this.delayWait );

			if ( GameError.hasError ) return;

			this.timer = new Timer( WAIT_DELAY, 1 );
			this.timer.addEventListener( TimerEvent.TIMER, this.startWait );
			this.timer.start();
		}

		/**
		 * Starts a wait loop until the GameController notifies the GamePreloader
		 * that the first scene has loaded.
		 */
		protected function startWait( event:Event ):void
		{
			TraceUtil.addLine( 'GamePreloader startWait() >>> Preloader is waiting for scene to load' );
			this.timer.removeEventListener( TimerEvent.TIMER, this.startWait );
			if ( GameError.hasError ) return;
			this.addEventListener( Event.ENTER_FRAME, this.waitSceneLoaded );
			this.stage.addChild( this.loader );
		}

		/**
		 * Checks if the GameController has loaded the first scene. If yes,
		 * processing continues to end the preloader cycle.
		 */
		protected function waitSceneLoaded( event:Event ):void
		{
			if ( GameError.hasError ) return;

			if ( GamePreloader.sceneLoaded ) {

				TraceUtil.addLine( 'GamePreloader waitSceneLoaded() >>> Preloader has received scene load confirmation' );
				this.removeEventListener( Event.ENTER_FRAME, this.waitSceneLoaded );
				this.endPreloader();
			}
		}

		/**
		 * Ends the preloader cycle.
		 */
		protected function endPreloader():void
		{
			this.scene.visible = false;
			TraceUtil.addLine( 'GamePreloader endPreloader() >>> DONE!!!' );
		}
	}
}