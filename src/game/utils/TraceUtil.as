package game.utils
{
	import game.data.*;

	import flash.display.*;

	import com.demonsters.debugger.MonsterDebugger;

	/**
	 * TraceUtil 2.0
	 * 
	 * Author:	Peter Krausche
	 * Date:	February 2012
	 * 
	 * This version of the trace utility gives the user the option to employ
	 * the Flash trace and/or the MonsterDebugger trace. Both may be active at
	 * the same time.
	 * 
	 * WARNING: GameData.main must be initialized before using this utility.
	 */
	public class TraceUtil
	{
		private static var lineNo:uint = 0;

		/**
		 * Setting this to true will activate output to the ActionScript trace statement.
		 */
		public static var flashTrace:Boolean = false;

		/**
		 * Setting this to true will activate trace output to the MonsterDebugger.
		 */
		public static var monsterTrace:Boolean = false;

		/**
		 * Setting this to true will begin each trace line with a line number.
		 */
		public static var useLineNo:Boolean = true;

		public function TraceUtil()
		{
		}

		public static function start():void
		{
			if ( TraceUtil.monsterTrace ) MonsterDebugger.initialize( GameData.main );
		}

		/**
		 * Adds a line of text to the trace field.
		 */
		public static function addLine( text:String ):void
		{
			if ( !( TraceUtil.flashTrace || TraceUtil.monsterTrace ) ) return;

			var line:String = '';

			if ( TraceUtil.useLineNo ) {

				line = ++TraceUtil.lineNo + ': ' + text;

			} else {

				line = text;
			}

			if ( TraceUtil.flashTrace ) trace( line );
			if ( TraceUtil.monsterTrace ) MonsterDebugger.trace( GameData.main, line );
		}
	}
}