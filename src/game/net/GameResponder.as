package game.net
{
	import game.utils.*;
	import game.events.*;
	import game.controllers.*;

	import flash.events.*;

	public class GameResponder extends EventDispatcher
	{
		private var response:Object;
		private var error:Object;

		public function GameResponder()
		{
		}

		public function getResponse():Object
		{
			return this.response;
		}

		public function getError():Object
		{
			return this.error;
		}

		public function onResponse( response:Object ):void
		{
			TraceUtil.addLine( 'GameResponder onResponse() ' );
			
			GameController.connection.killTimer();
			this.response = response;

			for ( var i in response ) {

				TraceUtil.addLine( 'GameResponder onResponse() ' + i + ':' + response[ i ] );
			}

			this.dispatchEvent( new GameNetEvent( GameNetEvent.RESPONSE_RECEIVED ) );
		}

		public function onError( error:Object ):void
		{
			TraceUtil.addLine( 'GameResponder onError() ' );
			
			GameController.connection.killTimer();
			this.error = error;

			for ( var i in error ) {

				TraceUtil.addLine( 'GameResponder onError() ' + i + ':' + error[ i ] );
			}

			this.dispatchEvent( new GameNetEvent( GameNetEvent.ERROR_RECEIVED ) );
		}
	}
}