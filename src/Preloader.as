package
{
	import data.*;
	import scenes.*;

	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.controllers.*;

	import flash.display.*;

	/**
	 * New Game
	 * 
	 * Author:		Billy Bateman
	 * Date:		April 2012
	 * Description:	Default skelton to begin a new game.
	 */
	public class Preloader extends GamePreloader
	{
		public function Preloader()
		{
			try {

				this.construct();
				super();

			} catch ( error:Error ) {

				GameError.setActionScriptError( error );
			}
		}

		private function construct():void
		{
			MainData.initMain( this );
			if ( GameError.hasError ) return;
			TraceUtil.addLine( 'Preloader construct() main: ' + GameData.main + ', stage:' + GameData.stage );
			this.scene = new PreloaderScene();
			if ( GameError.hasError ) return;
			this.addChild( this.scene );
		}

		override protected function endPreloader():void
		{
			var scene:PreloaderScene = this.scene as PreloaderScene;
			scene.stop();
			super.endPreloader();
		}
	}
}