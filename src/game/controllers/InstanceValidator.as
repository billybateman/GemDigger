package game.controllers
{
	import game.net.*;
	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;
	import game.objects.*;

	import flash.net.*;
	import flash.events.*;

	/**
	 * Validates that only one game instance is running so the user
	 * can't cheat by starting multiple game instances. The validation
	 * occurs through a LocalConnection, since only one LocalConnection
	 * with a specific name can be open at a time.
	 */
	public class InstanceValidator
	{
		private static const INSTANCE_VALIDATOR:String	= 'InstanceValidator';
		private static const CONNECTION_NAME:String		= GameData.gameName + InstanceValidator.INSTANCE_VALIDATOR;

		private var connection:LocalConnection;

		public function InstanceValidator()
		{
		}

		/**
		 * Attempts to open a LocalConnection. If the
		 * connection fails, a game instance has already
		 * been started (LocalConnection with the same name
		 * already exists).
		 */
		public function isSingleInstance():Boolean
		{
			this.connection = new LocalConnection();
			this.connection.client = GameData.main;

			try {

				TraceUtil.addLine( 'InstanceValidator setReceiver() >>> Attempting to open connection...client:' + GameData.main + ' connection:' + InstanceValidator.CONNECTION_NAME );
				this.connection.connect( InstanceValidator.CONNECTION_NAME );

			} catch ( error:Error ) {

				// The connection will throw an error if the same connection (game) is already open.
				// We use this to ensure the user can't start multiple game instances.
				TraceUtil.addLine( 'InstanceValidator setReceiver() ==> Connection ERROR -- name:' + error.name + ' ID:' + error.errorID + ' msg:' + error.message );
				this.validationError();
				return false;
			}

			return true;
		}

		private function validationError():void
		{
			var msgNo:String	= GameError.ERR_NO_1019;
			var msgTxt:String	= GameError.ERR_TXT_1019;
			GameErrorPopUp.show( msgNo, msgTxt, '' );
		}
	}
}