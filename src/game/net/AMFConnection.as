package game.net
{
	import game.utils.*;
	import game.errors.*;
	import game.objects.*;
	import game.controllers.*;

	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.errors.*;

	/**
	 * The AMFConnection class extends the abstract GameConnection class
	 * in order to standardize the call and connect methods. The AMFConnection
	 * class allows the user to set the call method, parms, and responder before
	 * executing the actual call in order to allow the call to be prepared
	 * through a specialized class and called by a standardized class.
	 */
	public class AMFConnection extends GameConnection
	{
		public static const GATEWAY_QUIBIDS:String = 'quibids.com';
		public static const GATEWAY_SHOPPIE:String = 'shoppie.com';
		
		// Remove after moving to qb servers.
		public static const GATEWAY_THIRD_PARTY:String = 'billybateman.com';
		

		public static const TIMEOUT:Number = 8000;

		protected var connection:NetConnection;

		public function AMFConnection()
		{
			this.init();
		}

		override public function connect():void
		{
			if ( this.gateway ) {

				var gatewayLC:String = this.gateway.toLowerCase();

				if ( 	( gatewayLC.indexOf( AMFConnection.GATEWAY_QUIBIDS ) == -1 ) &&
						( gatewayLC.indexOf( AMFConnection.GATEWAY_SHOPPIE ) == -1 ) &&
						( gatewayLC.indexOf( AMFConnection.GATEWAY_THIRD_PARTY ) == -1 ) ) {

					this.processError( GameError.ERR_NO_1018, GameError.ERR_TXT_1018, null );
					return;
				}

				try {

					TraceUtil.addLine( 'AMFConnection connect() >>> Connecting to gateway ' + this.gateway );
					this.connection.connect( this.gateway );

				} catch ( error:Error ) {

					this.connectionError( error );
				}

			} else {

				TraceUtil.addLine( 'AMFConnection connect() ==> ERROR: ' + GameError.ERR_TXT_1101 );
				this.processError( GameError.ERR_NO_1101, GameError.ERR_TXT_1101, null )
			}
		}

		override public function call():void
		{
			TraceUtil.addLine( 'AMFConnection call() >>> Calling server...method:' + this.method + '; responder:' + GameController.responder + '; parm:' + this.parm );
			this.connection.call( this.method, new AMFResponder( GameController.responder ), this.parm );

			this.timer = new Timer( AMFConnection.TIMEOUT, 10 );
			this.timer.addEventListener( TimerEvent.TIMER, this.timeout );
			this.timer.start();
		}

		override public function killTimer():void
		{
			this.timer.removeEventListener( TimerEvent.TIMER, this.timeout );
			this.timer.stop();
			TraceUtil.addLine( 'AMFConnection killTimer() ==>>> Killed Timer!!!' );
		}

		override public function timeout( event:Event ):void
		{
			this.killTimer();

			TraceUtil.addLine( 'AMFConnection timeout() ==>>> Server call timeout!!!' );

			var msgNo:String	= GameError.ERR_NO_1020;
			var msgTxt:String	= GameError.ERR_TXT_1020;

			GameErrorPopUp.show( msgNo, msgTxt, '' );
		}

		private function init():void
		{
			this.gateway = '';
			this.connection = new NetConnection();
		}

		private function connectionError( error:Error ):void
		{
			TraceUtil.addLine( 'AMFConnection connectionError() ==> ERROR ID:' + error.errorID + '; name:' + error.name + '; message:' + error.message );

			switch ( true ) {

				case error is ArgumentError : this.processError( GameError.ERR_NO_1102, GameError.ERR_TXT_1102, error );	break;
				case error is IOError		: this.processError( GameError.ERR_NO_1103, GameError.ERR_TXT_1103, error );		break;
				case error is SecurityError : this.processError( GameError.ERR_NO_1104, GameError.ERR_TXT_1104, error );	break;
				default:					  this.processError( GameError.ERR_NO_1105, GameError.ERR_TXT_1105, null );
			}
		}

		private function processError( msgNo:String, msgTxt:String, error:Error ):void
		{
			var msgData:String = ( error ) ? ( 'ErrorID: ' + error.errorID + ' name: ' + error.name + ' message: ' + error.message ) : '';
			GameErrorPopUp.show( msgNo, msgTxt, msgData );
		}
	}
}