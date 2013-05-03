package game.controllers
{
	import game.net.*;
	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;

	import flash.net.*;
	import flash.events.*;

	/**
	 * Initializes the game for the GameController. If a GamePreloader is
	 * being used, some of this initialization process is skipped, since
	 * it's being taken care of by the preloader.
	 */
	public class GameInitializer
	{
		private var validator:InstanceValidator;
		private var initialized:Boolean;

		public function GameInitializer()
		{
		}

		public function start():void
		{
			GameController.instance.addEventListener( Event.ADDED_TO_STAGE, this.stageAvailable );

			if ( GamePreloader.isActivated ) {

				TraceUtil.addLine( 'GameInitializer >>> Game started via Preloader' );
				this.initGame();

			} else {

				TraceUtil.addLine( 'GameInitializer >>> Game started without Preloader' );
				this.initConfig();
			}
		}

		protected function initConfig():void
		{
			if ( GameError.hasError ) return;
			GameConfig.gameURL 	= '';
			GameController.configurator.addEventListener( GameEvent.CONFIG_LOADED, this.configLoaded );
			GameController.configurator.start();
		}

		protected function stageAvailable( event:Event ):void
		{
			GameController.instance.removeEventListener( Event.ADDED_TO_STAGE, this.stageAvailable );
			TraceUtil.addLine( 'GameInitializer >>> Added To Stage' );
			TraceUtil.addLine( 'GameInitializer stageAvailable() >>> Setting GameData.stage:' + GameController.instance.stage );
			GameData.stage = GameController.instance.stage;
			this.loadScene();
		}

		protected function configLoaded( event:Event ):void
		{
			GameController.configurator.removeEventListener( GameEvent.CONFIG_LOADED, this.configLoaded );
			TraceUtil.addLine( 'GameInitializer >>> Loaded Config' );
			if ( GameError.hasError ) return;
			this.initGame();
		}

		/**
		 * Sets the last configuration variables (language) and
		 * begins the localization process.
		 */
		protected function initGame():void
		{
			if ( GameError.hasError ) return;
			TraceUtil.addLine( 'GameInitializer >>> Initialize Game' );
			GameController.configurator.setConfig();
			if ( GameError.hasError ) return;
			this.loadLanguage();
		}

		protected function loadLanguage():void
		{
			GameController.localizer.addEventListener( GameEvent.LANGUAGE_LOADED, this.languageLoaded );
			GameController.localizer.start();
		}

		/**
		 * After the language files and assets have been loaded,
		 * the sounds and scenes are created and initialized.
		 */
		protected function languageLoaded( event:Event ):void
		{
			TraceUtil.addLine( 'GameInitializer >>> Loaded Language' );
			//TraceUtil.addToStage();

			GameController.localizer.removeEventListener( GameEvent.LANGUAGE_LOADED, this.languageLoaded );

			if ( GameError.hasError ) return;
			TraceUtil.addLine( 'GameInitializer >>> Initializing sound manager...' );
			GameController.soundManager.initAllSounds();
			if ( GameError.hasError ) return;
			TraceUtil.addLine( 'GameInitializer >>> Initializing scene manager...' );
			GameController.sceneManager.initAllScenes();
			if ( GameError.hasError ) return;

			this.initialized = true;
			this.loadScene();
		}

		/**
		 * The first scene is only loaded after the GameController has been
		 * added to the stage and the initialization process is complete.
		 */
		protected function loadScene():void
		{
			TraceUtil.addLine( 'GameInitializer loadScene() stage:' + GameController.instance.stage + ', initialized:' + this.initialized );

			if ( GameError.hasError ) return;

			if ( GameController.instance.stage && this.initialized ) {

				TraceUtil.addLine( 'GameInitializer >>> Loading Scene...' );
				GameController.sceneManager.addEventListener( GameEvent.SCENE_LOADED, this.sceneLoaded );
				GameController.sceneManager.startScene( GameData.nextScene );
				
			}
		}

		/**
		 * If the game was loaded via preloader, the GameInitializer informs
		 * the preloader that the first scene has been loaded by setting the
		 * GamePreloader.sceneLoaded to true.
		 */
		protected function sceneLoaded( event:Event ):void
		{
			TraceUtil.addLine( 'GameInitializer >>> Scene Loaded' );
			GameController.sceneManager.removeEventListener( GameEvent.SCENE_LOADED, this.sceneLoaded );

			if ( GameError.hasError ) return;

			if ( GamePreloader.isActivated ) {

				GamePreloader.sceneLoaded = true;
				TraceUtil.addLine( 'GameInitializer >>> Preloader informed of Scene Loaded' );
			}
		}
	}
}