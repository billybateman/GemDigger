package game.net
{
	import game.utils.*;
	import game.events.*;

	import flash.net.*;

	public class AMFResponder extends Responder
	{
		private var responder:GameResponder;

		public function AMFResponder( responder:GameResponder )
		{
			this.responder = responder;
			super( responder.onResponse, responder.onError );
		}
	}
}