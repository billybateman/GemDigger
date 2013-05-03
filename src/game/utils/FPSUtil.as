package game.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	import game.data.*;
	import game.text.*;
	import game.utils.*;

	public class FPSUtil
	{
		private static const COLLECTION_DURATION:int = 500;

		private static var display:GameTextFPS;
		private static var frameCount:uint;
		private static var frameRate:Number;
		private static var fps:Number;
		private static var startTime:int;
		private static var currTime:int;
		private static var currSec:int;
		private static var lastSec:int;
		private static var isCreated:Boolean;

		public function FPSUtil()
		{
		}

		public static function start():void
		{
			TraceUtil.addLine( 'FPSUtil start() stage:' + GameData.stage );
			FPSUtil.frameRate	= GameData.stage.frameRate;
			FPSUtil.startTime	= getTimer();
			FPSUtil.lastSec		= getTimer();
			FPSUtil.frameCount	= 0;
			FPSUtil.currSec		= 0;

			if ( !FPSUtil.isCreated ) {

				FPSUtil.create();
			}

			GameData.stage.addEventListener( Event.ENTER_FRAME, FPSUtil.collect );
		}

		public static function stop():void
		{
			GameData.stage.removeEventListener( Event.ENTER_FRAME, FPSUtil.collect );
		}

		public static function getFPS():Number
		{
			TraceUtil.addLine( 'FPS: ' + FPSUtil.fps );
			return FPSUtil.fps;
		}

		private static function create():void {
			
			FPSUtil.isCreated = false;
			
			if ( GameData.stage ) {
				
				TraceUtil.addLine( '' );
				TraceUtil.addLine( 'FPSUtil v2.0' );
				TraceUtil.addLine( '' );

				FPSUtil.isCreated 	= true;
				FPSUtil.display		= new GameTextFPS();
				FPSUtil.display.x	= GameData.stage.stageWidth - FPSUtil.display.width;
				FPSUtil.display.y	= 0;
			}
		}

		private static function collect( event:Event ):void
		{
			++FPSUtil.frameCount;
			FPSUtil.currTime	= getTimer();
			FPSUtil.fps			= FPSUtil.frameCount * 1000 / ( FPSUtil.currTime - FPSUtil.startTime )
			FPSUtil.currSec		= FPSUtil.currTime - FPSUtil.lastSec

			if ( FPSUtil.currSec >= COLLECTION_DURATION ) {

				FPSUtil.display.setText(  'fps: ' + String( FPSUtil.round2Dec( FPSUtil.fps ) ), false );

				GameData.stage.addChild( FPSUtil.display );

				FPSUtil.lastSec		= getTimer();
				FPSUtil.startTime	= getTimer();
				FPSUtil.frameCount	= 0;
				//TraceUtil.addLine( 'FPSUtil collect() ' + FPSUtil.display.text );
			}
		}

		private static function round2Dec( num:Number ):Number
		{
			return int( num * 100 ) / 100;
		}
	}
}