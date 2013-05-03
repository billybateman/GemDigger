package game.controllers
{
	import game.net.*;
	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;
	import game.scenes.*;
	import game.objects.*;

	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;
	import game.errors.GameError;

	/**
	 * The SceneManager creates scenes and can load and unload them
	 * from the stage. The SceneManager ensures that scenes are not
	 * displayed until the initialization and reset phases of the
	 * scenes are completed.
	 */
	public class SceneManager extends EventDispatcher
	{
		private var timer:Timer;
		private var frame:Number;
		private var time:int;
		private var sceneMask:GameSceneMask;

		private var scene:String;
		private var fade:Boolean;

		private var _scenes:Object;

		private var sequence:Array	= new Array();
		private var currentID:uint	= 0;

		private var previous:GameScene;
		private var current:GameScene;

		public function SceneManager():void
		{
		}

		/**
		 * Creates and initializes all scenes defined
		 * in the GameData.scene container.
		 */
		public function initAllScenes():void
		{
			TraceUtil.addLine( 'SceneManager initScenes() >>> Initializing scenes...' );

			this.previous	= null;
			this.current	= null;

			this._scenes	= new Object();

			for ( var name:String in GameData.scene ) {

				if ( GameError.hasError ) return;
				this.initScene( name );
			}
		}

		/**
		 * Initializes a specific scene in the GameData.scene container.
		 */
		public function initScene( name:String ):void
		{
			TraceUtil.addLine( 'SceneManager initScene() name: ' + name );

			var scene:Class	= GameData.scene[ name ];
			TraceUtil.addLine( 'SceneManager initScene() scene: ' + scene );

			try {

				var newScene:GameScene = new scene();

				TraceUtil.addLine( 'SceneManager initScene() newScene: ' + newScene );
				TraceUtil.addLine( 'SceneManager initScene() _scenes: ' + this._scenes );

				this._scenes[ name ] = newScene;

			} catch ( error:Error ) {

				TraceUtil.addLine( 'SceneManager initScene() ==> ERROR: ' + error.message );

				var msgNo:String	= GameError.ERR_NO_1110;
				var msgTxt:String	= GameError.ERR_TXT_1110;
				var msgData:String	= 'Scene name: ' + name;

				GameError.setError( msgNo, msgTxt, msgData );
			}
		}

		/**
		 * Adds a scene to the scene sequence array.
		 */
		public function addSceneSequence( name:String, status:String ):void
		{
			var scene:GameSceneData	= new GameSceneData();
			scene.name		= name;
			scene.status	= status;

			this.sequence.push( scene );
		}

		/**
		 * Loads the first scene of the game
		 */
		public function load():void
		{
			var scene:GameSceneData = this.sequence[ this.currentID ];
			TraceUtil.addLine( 'SceneManager load() scene: ' + scene.name );
			this.activate( scene.name );
		}

		public function addToScene( object:Sprite ):void
		{
			this.current.addChild( object );
		}

		/**
		 * Starts the next scene in the sequence of scenes
		 * predetermined in the SceneManager.sequence array.
		 */
		public function nextScene():void
		{
			this.sequence[ this.currentID++ ].status	= GameSceneData.STATUS_FINISHED;
			this.sequence[ this.currentID ].status		= GameSceneData.STATUS_STARTED;

			TraceUtil.addLine( 'SceneManager nextScene() >>> Next Scene: ' + this.sequence[ this.currentID ].name );

			this.activate( this.sequence[ this.currentID ].name );
		}

		/**
		 * Starts the specified scene without
		 * considering the scene sequence or status.
		 */
		public function startScene( scene:String ):void
		{
			TraceUtil.addLine( 'SceneManager startScene() >>> ' + scene );
			this.activate( scene );
		}

		/**
		 * Begins scene activation processing.
		 */
		private function activate( scene:String ):void
		{
			if ( GameError.hasError ) return;

			TraceUtil.addLine( 'SceneManager activate() scene: ' + scene );

			this.scene = scene;

			this.sceneMask = new GameSceneMask();

			this.previous = this.current;

			//TraceUtil.addLine( 'SceneManager activate() previous: ' + this.previous );

			this.current = this._scenes[ scene ];
			TraceUtil.addLine( 'SceneManager activate() current: ' + this.current );
			this.current.visible	= false;
			this.current.mask		= this.sceneMask;

			this.reset();
		}

		/**
		 * Resets the current scene. This is necessary since scenes
		 * may be activated many times during the game. This gives
		 * the scene a chance to reset itself before being displayed.
		 */
		private function reset():void
		{
			if ( GameError.hasError ) return;
			TraceUtil.addLine( 'SceneManager reset()' );
			this.current.addEventListener( GameEvent.RESET_COMPLETE, this.show );
			this.current.reset();
		}

		/**
		 * Displays the current scene
		 * after the scene has been reset.
		 */
		private function show( event:Event ):void
		{
			TraceUtil.addLine( 'SceneManager show()' );
			
			this.current.removeEventListener( GameEvent.RESET_COMPLETE, this.show );

			if ( GameError.hasError ) return;

			GameData.stage.addChild( this.current );

			TraceUtil.addLine( 'SceneManager show() >>> Scene Loaded' );

			this.current.visible = true;
			this.activateCurrent();

			//TraceUtil.clearText();
			//TraceUtil.addLine( 'SceneManager >>> Current Scene Set, Loaded, and Activated' );
		}

		/**
		 * The current scene is finally activated.
		 * Last step of the scene activation process.
		 */
		private function activateCurrent():void
		{
			TraceUtil.addLine( 'SceneManager activateCurrent()' );
			
			if ( GameError.hasError ) return;

			this.removePrevious();
			this.current.activate();
			this.dispatchEvent( new GameEvent( GameEvent.SCENE_LOADED ) );
			TraceUtil.addLine( 'SceneManager >>> Current Scene Activated' );
		}

		private function removePrevious():void
		{
			if ( this.previous ) {

				GameData.stage.removeChild( this.previous );
				this.previous = null;
			}
		}
	}
}
