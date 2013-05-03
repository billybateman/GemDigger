package game.buttons
{
	import game.utils.*;

	import flash.events.*;
	import flash.display.*;

	/**
	 * Defines a simple button that can be used
	 * in the game.
	 */
	public class GameSimpleButton extends Sprite
	{
		private var enabled:Boolean;

		private var stateUp:DisplayObject;
		private var stateDn:DisplayObject;
		private var stateOv:DisplayObject;
		private var state:DisplayObject;

		public var button:Sprite;

		public function GameSimpleButton( stateUp:DisplayObject, stateDn:DisplayObject, stateOv:DisplayObject )
		{
			this.mouseEnabled = false;

			this.stateUp = stateUp;
			this.stateDn = stateDn;
			this.stateOv = stateOv;

			this.addChild( this.stateUp );
			this.addChild( this.stateDn );
			this.addChild( this.stateOv );

			this.createButton();
		}

		public function showUp():void
		{
			this.stateUp.visible = true;
			this.stateDn.visible = false;
			this.stateOv.visible = false;

			this.state = this.stateUp;
		}

		public function enable():void
		{
			this.showUp();

			this.enabled = true;
			this.button.buttonMode = true;
			this.button.useHandCursor = true;
			this.button.addEventListener( MouseEvent.MOUSE_OUT, this.up );
			this.button.addEventListener( MouseEvent.MOUSE_DOWN, this.down );
			this.button.addEventListener( MouseEvent.MOUSE_OVER, this.over );
		}

		public function disable():void
		{
			this.showUp();

			this.enabled = false;
			this.button.buttonMode = false;
			this.button.useHandCursor = false;
			this.button.removeEventListener( MouseEvent.MOUSE_OUT, this.up );
			this.button.removeEventListener( MouseEvent.MOUSE_DOWN, this.down );
			this.button.removeEventListener( MouseEvent.MOUSE_OVER, this.over );
		}

		private function show( state:DisplayObject ):void
		{
			state.visible = true;
			this.state.visible = false;
			this.state = state;
		}

		private function up( event:Event=null ):void
		{
			//TraceUtil.addLine( 'GameSimpleButton up() >>> Mouse out' );
			this.show( this.stateUp );
		}

		private function down( event:Event ):void
		{
			//TraceUtil.addLine( 'GameSimpleButton up() >>> Mouse down' );
			this.show( this.stateDn );
		}

		private function over( event:Event ):void
		{
			//TraceUtil.addLine( 'GameSimpleButton up() >>> Mouse over' );
			this.show( this.stateOv );
		}

		private function createButton():void
		{
			this.button = ObjectUtils.getOverlay( this );
		}
	}
}