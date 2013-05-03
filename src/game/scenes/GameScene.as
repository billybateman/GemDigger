package game.scenes
{
	import flash.events.*;
	import flash.display.*;

	import game.net.*;
	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;
	import game.buttons.*;
	import game.controllers.*;

	public class GameScene extends Sprite
	{
		public static const SCENE_NAME:String = 'GameScene';

		private const SOUND_X:Number	= 740;
		private const SOUND_Y:Number	= 560;

		public var sceneName:String;

		public function GameScene()
		{
			TraceUtil.addLine( 'GameScene() >>> Constructing GameScene' );
			this.init();
		}

		public function reset():void
		{
			GameController.prizeManager.setScene( this.sceneName );
			GameError.catchActionScriptError( this.resetScene );
			this.dispatchEvent( new GameEvent( GameEvent.RESET_COMPLETE ) );
		}

		public function activate():void
		{
		}

		public function deactivate():void
		{
		}

		/**
		 * Initializes data that doesn't need specific configuration data
		 * such as language and site dependent assets.
		 */
		protected function init():void
		{
			if ( !this.sceneName ) this.sceneName = GameScene.SCENE_NAME;

			TraceUtil.addLine( 'GameScene() >>> Initializing game scene: ' + this.sceneName );

			GameController.prizeManager.setScene( this.sceneName );
			
			TraceUtil.addLine( 'GameScene prizeManager setScene' );
			
			GameError.catchActionScriptError( this.initScene );
			
			this.addEventListener( Event.ADDED_TO_STAGE, this.addedToStage );
		}

		protected function initScene():void
		{
		}

		protected function resetScene():void
		{
		}

		protected function addedToStage( event:Event ):void
		{
			TraceUtil.addLine( 'GameScene addedToStage() >>> Starting' );
			
			this.removeEventListener( Event.ADDED_TO_STAGE, this.addedToStage );
			this.dispatchEvent( new GameEvent( GameEvent.SCENE_LOADED ) );
			
			TraceUtil.addLine( 'GameScene addedToStage() >>> Ending' );
		}
	}
}