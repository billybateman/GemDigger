package game.errors
{
	import game.data.*;
	import game.utils.*;
	import game.objects.*;
	import game.controllers.*;

	/**
	 * Central Error class. The class includes methods to
	 * set and catch ActionScript errors and allows a call
	 * to the server to relate error data.
	 * 
	 * All system error messages need to be defined here. When
	 * displaying an error message with GameError.setError() or
	 * GameErrorPopUp.show(), the error number and text should
	 * be passed by using the static constants below.
	 */
	public class GameError
	{
		public static const ERR_NO_1011:String = '1011';
		public static const ERR_NO_1012:String = '1012';
		public static const ERR_NO_1017:String = '1017';
		public static const ERR_NO_1018:String = '1018';
		public static const ERR_NO_1019:String = '1019';
		public static const ERR_NO_1020:String = '1020';
		public static const ERR_NO_1021:String = '1021';
		public static const ERR_NO_1025:String = '1025';
		public static const ERR_NO_1030:String = '1030';
		public static const ERR_NO_1031:String = '1031';
		public static const ERR_NO_1032:String = '1032';
		public static const ERR_NO_1040:String = '1040';
		public static const ERR_NO_1101:String = '1101';
		public static const ERR_NO_1102:String = '1102';
		public static const ERR_NO_1103:String = '1103';
		public static const ERR_NO_1104:String = '1104';
		public static const ERR_NO_1105:String = '1105';
		public static const ERR_NO_1106:String = '1106';
		public static const ERR_NO_1107:String = '1107';
		public static const ERR_NO_1108:String = '1108';
		public static const ERR_NO_1109:String = '1109';
		public static const ERR_NO_1110:String = '1110';
		public static const ERR_NO_1111:String = '1111';
		public static const ERR_NO_1112:String = '1112';
		public static const ERR_NO_1113:String = '1113';
		public static const ERR_NO_1114:String = '1114';
		public static const ERR_NO_1115:String = '1115';
		public static const ERR_NO_1116:String = '1116';
		public static const ERR_NO_1117:String = '1117';
		public static const ERR_NO_1130:String = '1130';
		public static const ERR_NO_1131:String = '1131';
		public static const ERR_NO_1132:String = '1132';
		public static const ERR_NO_1190:String = '1190';

		public static const ERR_TXT_1011:String = 'Invalid request type.';
		public static const ERR_TXT_1012:String = 'Invalid game or version.';
		public static const ERR_TXT_1017:String = 'You must be logged in to play.';
		public static const ERR_TXT_1018:String = 'The request is not for a valid game domain.';
		public static const ERR_TXT_1019:String = 'Attempted to start multiple game instances.';
		public static const ERR_TXT_1020:String = 'Connection time out.';
		public static const ERR_TXT_1021:String = 'Invalid prize allocation.';
		public static const ERR_TXT_1025:String = 'Invalid game play.';
		public static const ERR_TXT_1030:String = 'Invalid game play token.';
		public static const ERR_TXT_1031:String = 'No available game plays.';
		public static const ERR_TXT_1032:String = 'Game timer invalid. Game took too long.';
		public static const ERR_TXT_1040:String = 'Attempt to restart the game failed. Too many restarts issued.';
		public static const ERR_TXT_1101:String = 'AMF connection error: No gateway defined.';
		public static const ERR_TXT_1102:String = 'AMF connection error: Argument Error.';
		public static const ERR_TXT_1103:String = 'AMF connection error: IO Error.';
		public static const ERR_TXT_1104:String = 'AMF connection error: Security Error';
		public static const ERR_TXT_1105:String = 'AMF connection error: Unknown Error';
		public static const ERR_TXT_1106:String = 'The game controller could not navigate to the specified URL.';
		public static const ERR_TXT_1107:String = 'The game configurator\'s call to the server failed.';
		public static const ERR_TXT_1108:String = 'The game preloader encountered an error while loading the game.';
		public static const ERR_TXT_1109:String = 'The game preloader encountered an error event while loading the game.';
		public static const ERR_TXT_1110:String = 'The scene manager could not create the specified scene.';
		public static const ERR_TXT_1111:String = 'The game localizer could not load the language XML file.';
		public static const ERR_TXT_1112:String = 'The sound manager could not set the specified channel.';
		public static const ERR_TXT_1113:String = 'The sound manager could not find the specified channel during a fade process.';
		public static const ERR_TXT_1114:String = 'An asset requested fallback but no fallback URL was specified.';
		public static const ERR_TXT_1115:String = 'The asset could not be loaded.';
		public static const ERR_TXT_1116:String = 'The game could not load the gateway from the specified XML (captured error).';
		public static const ERR_TXT_1117:String = 'The game could not load the gateway from the specified XML (error event).';
		public static const ERR_TXT_1130:String = 'Attempt to export GameAssetLoader content as Bitmap failed.';
		public static const ERR_TXT_1131:String = 'Attempt to export GameAssetLoader content as BitmapData failed.';
		public static const ERR_TXT_1132:String = 'Attempt to export GameAssetLoader content as MovieClip failed.';
		public static const ERR_TXT_1190:String = 'ActionScript ';

		/**
		 * The method used when calling the server.
		 */
		private static var method:String = 'GameError.error';

		/**
		 * The hasError variable lets the application know if an error was encountered.
		 * It should be queried at relevent locations in the application and should lead
		 * to an application abort if set to true.
		 */
		public static var hasError:Boolean = false;

		public function GameError()
		{
		}

		/**
		 * Displays an error message and calls the server if a server call
		 * is requested (callServer = true). A connection to the server must
		 * already be established if a server call is requested.
		 */
		public static function setError( msgNo:String, msgTxt:String, msgData:String, callServer:Boolean = true ):void
		{
			GameErrorPopUp.show( msgNo, msgTxt, msgData );
			if ( callServer ) GameError.callServer( msgNo, msgTxt, msgData );
		}

		/**
		 * Displays the error popup when an ActionScript error has occured.
		 * The server is not called in this case.
		 */
		public static function setActionScriptError( error:Error ):void
		{
			TraceUtil.addLine( 'GameError setActionScriptError() Stack Trace: ' + error.getStackTrace() );

			var msgNo:String	= GameError.ERR_NO_1190;
			var msgTxt:String	= GameError.ERR_TXT_1190 + error.message;
			var msgData:String	= '';
			GameError.setError( msgNo, msgTxt, msgData, false );
		}

		/**
		 * Encloses the callback method in a try/catch block and catches an
		 * ActionScript error if one occurs.
		 * Usage: GameError.catchActionScriptError( method );
		 */
		public static function catchActionScriptError( callback:Function ):void
		{
			try {

				callback();

			} catch ( error:Error ) {

				GameError.setActionScriptError( error );
			}
		}

		/**
		 * Sets the error method that will be used when calling the server.
		 */
		public static function setMethod( method:String ):void
		{
			GameError.method = method;
		}

		/**
		 * Calls the server with an error object. A connection to the server must
		 * already be established to use this method.
		 */
		private static function callServer( msgNo:String, msgTxt:String, msgData:String ):void
		{
			if ( GameData.standalone ) return;

			var error:Object = { msgNo:msgNo, msgTxt:msgTxt, msgData:msgData };
			GameController.connection.setParm( error );
			GameController.connection.setMethod( GameError.method );
			GameController.connection.call();
		}
	}
}