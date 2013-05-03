package game.utils
{
	import flash.display.*;
	import flash.system.*;
	import flash.events.*;
	import flash.utils.*;

	import game.data.*;
	import game.text.*;

	public class MemUtil
	{
		private static const SLEEP_DURATION:int = 1000;

		private static var display:GameTextMem;
		private static var memory:uint;
		private static var startTime:int;
		private static var currTime:int;
		private static var currSec:int;
		private static var lastSec:int;
		private static var isCreated:Boolean;

		public function MemUtil()
		{
		}

		public static function start():void
		{
			MemUtil.startTime	= getTimer();
			MemUtil.lastSec		= getTimer();
			MemUtil.currSec		= 0;
			MemUtil.memory		= 0;

			if ( !MemUtil.isCreated ) {

				MemUtil.create();
			}

			GameData.stage.addEventListener( Event.ENTER_FRAME, MemUtil.checkTime );
		}

		public static function stop():void
		{
			GameData.stage.removeEventListener( Event.ENTER_FRAME, MemUtil.checkTime );
		}

		public static function getMem():Number
		{
			TraceUtil.addLine( 'mem: ' + MemUtil.memory );
			return MemUtil.memory;
		}

		private static function create():void
		{
			MemUtil.isCreated = false;

			if ( GameData.stage ) {
				
				TraceUtil.addLine( '' );
				TraceUtil.addLine( 'MemUtil v2.0' );
				TraceUtil.addLine( '' );

				MemUtil.isCreated 	= true;
				MemUtil.display		= new GameTextMem();

				MemUtil.display.setText(  'mem: ' + String( MemUtil.memory ) + ' KB', false );

				MemUtil.display.x	= GameData.stage.stageWidth - MemUtil.display.width;
				MemUtil.display.y	= GameData.stage.stageHeight - MemUtil.display.height;
			}
		}

		private static function checkTime( event:Event ):void
		{
			MemUtil.currTime	= getTimer();
			MemUtil.currSec		= MemUtil.currTime - MemUtil.startTime

			if ( MemUtil.currSec >= SLEEP_DURATION ) {

				MemUtil.memory = MemUtil.roundKB( System.totalMemory )

				MemUtil.display.setText(  'mem: ' + String( MemUtil.memory ) + ' KB', false );
				GameData.stage.addChild( MemUtil.display );

				MemUtil.startTime = getTimer();
			}
		}

		private static function roundKB( memory:uint ):uint
		{
			return uint( memory / 1024 );
		}
	}
}