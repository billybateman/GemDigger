package game.net
{
	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.events.*;
	import game.objects.*;

	import flash.net.*;
	import flash.events.*;

	public class GatewayLoader extends EventDispatcher
	{
		public function GatewayLoader()
		{
		}

		public function load():void
		{
			TraceUtil.addLine( 'GatewayLoader load() >>> Loading gateway via XML' );

			try {

				var file:String			= 'xml/gateway.xml';
				var request:URLRequest	= new URLRequest( file );
				var loader:URLLoader	= new URLLoader();

				loader.addEventListener( Event.COMPLETE, this.loaded );
				loader.addEventListener( IOErrorEvent.IO_ERROR, this.loadError );
				loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, this.loadError );
				loader.load( request );

			} catch ( error:Error ) {

				TraceUtil.addLine( 'GatewayLoader load() ==> ERROR: ' + error.message );

				var msgNo:String	= GameError.ERR_NO_1116;
				var msgTxt:String	= GameError.ERR_TXT_1116;
				var msgData:String	= 'Error: ' + error.errorID + ' ' + error.message + ' File: ' + file;

				GameErrorPopUp.show( msgNo, msgTxt, msgData );
			}
		}

		private function loaded( event:Event ):void
		{
			event.currentTarget.removeEventListener( Event.COMPLETE, this.loaded );
			event.currentTarget.removeEventListener( IOErrorEvent.IO_ERROR, this.loadError );
			event.currentTarget.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, this.loadError );

			TraceUtil.addLine( 'GatewayLoader loaded() target: ' + event.currentTarget );

			var gatewayXML:XML	= new XML( event.currentTarget.data );
			TraceUtil.addLine( 'GatewayLoader loaded() gatewayXML: ' + gatewayXML );
			var url:String		= String( gatewayXML.url );
			var gpid:String		= String( gatewayXML.gpid );
			GameData.gateway	= url + '?gpid=' + gpid;

			TraceUtil.addLine( 'GatewayLoader loaded() gateway: ' + GameData.gateway );

			this.dispatchEvent( new GameNetEvent( GameNetEvent.GATEWAY_LOADED ) );
		}

		private function loadError( event:ErrorEvent ):void
		{
			var msgNo:String	= GameError.ERR_NO_1117;
			var msgTxt:String	= GameError.ERR_TXT_1117;
			var msgData:String	= 'Error: ' + event.errorID;

			GameErrorPopUp.show( msgNo, msgTxt, msgData );
		}
	}
}