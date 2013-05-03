package game.mouse
{
	import flash.ui.*;
	import flash.events.*;
	import flash.display.*;

	import game.data.*;
	import game.utils.*;

	public class GameCursor extends MovieClip
	{
		public var isActive:Boolean;

		public function GameCursor()
		{
			this.mouseEnabled	= false;
			this.mouseChildren	= false;

			this.deactivate();
		}

		private function mouseMoved( event:MouseEvent ):void
		{
			this.show();
			event.updateAfterEvent();
		}

		private function show():void
		{
			this.x = GameData.stage.mouseX;
			this.y = GameData.stage.mouseY;

			if ( !this.visible ) this.visible = true;
		}

		private function mouseLeft( event:Event ):void
		{
			this.deactivate();
			GameData.stage.addEventListener( MouseEvent.MOUSE_MOVE, this.mouseReturn );
		}

		private function mouseReturn( event:Event ):void
		{
			GameData.stage.removeEventListener( MouseEvent.MOUSE_MOVE, this.mouseReturn );
			this.activate();
		}

		private function updateStack( event:Event ):void
		{
			GameData.stage.addChild( this );
		}

		public function activate():void
		{
			GameData.stage.addEventListener( MouseEvent.MOUSE_MOVE, this.mouseMoved );
			GameData.stage.addEventListener( Event.MOUSE_LEAVE, this.mouseLeft );
			GameData.stage.addEventListener( Event.ADDED, this.updateStack );

			this.isActive = true;

			Mouse.hide();

			this.show();
		}

		public function deactivate():void
		{
			GameData.stage.removeEventListener( MouseEvent.MOUSE_MOVE, this.mouseMoved );
			GameData.stage.removeEventListener( Event.MOUSE_LEAVE, this.mouseLeft );
			GameData.stage.removeEventListener( Event.ADDED, this.updateStack );

			this.isActive 	= false;
			this.visible	= false;

			Mouse.show();
		}
	}
}