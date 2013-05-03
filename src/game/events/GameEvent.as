package game.events
{
	import flash.events.*;

	public class GameEvent extends Event
	{
		public static const GAME_LOADED:String			= 'gameLoaded';
		public static const GAME_OVER:String			= 'gameOver';
		public static const GAME_ERROR:String			= 'gameError';
		public static const NEXT_SCENE:String			= 'nextScene';
		public static const ASSET_LOADED:String			= 'assetLoaded';
		public static const SCENE_LOADED:String			= 'sceneLoaded';
		public static const CONFIG_LOADED:String		= 'configLoaded';
		public static const LANGUAGE_LOADED:String		= 'languageLoaded';
		public static const WEAPON_FIRED:String			= 'weaponFired';
		public static const ANIMATION_COMPLETE:String	= 'animationComplete';
		public static const ANIMATION_CUE_POINT:String	= 'animationCuePoint';
		public static const SOUND_COMPLETE:String		= 'soundComplete';
		public static const RESET_COMPLETE:String		= 'resetComplete';
		public static const TIMER_COMPLETE:String		= 'timerComplete';
		public static const STARLING_COMPLETE:String	= 'starlingComplete';

		public function GameEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		override public function clone():Event
		{
			return new GameEvent( this.type, this.bubbles, this.cancelable );
		}
	}
}