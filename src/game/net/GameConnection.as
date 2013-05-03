package game.net
{
	import flash.utils.*;
	import flash.events.*;

	/**
	 * The GameConnection class presents a skeleton structure
	 * (as a kind of abstract class) to help standardize
	 * communication with the server. The class must be extended
	 * and the mothods overriden with an actual communication
	 * service for it to actually work.
	 */
	public class GameConnection extends EventDispatcher
	{
		protected var gateway:String;
		protected var method:String;
		protected var parm:Object;
		protected var timer:Timer;

		public function GameConnection()
		{
		}

		public function connect():void
		{
		}

		public function call():void
		{
		}

		public function killTimer():void
		{
		}

		public function timeout( event:Event ):void
		{
		}

		public function getGateway():String
		{
			return this.gateway;
		}

		public function setGateway( gateway:String ):void
		{
			this.gateway = gateway;
		}

		public function getMethod():String
		{			
			return this.method;
		}

		public function setMethod( method:String ):void
		{			
			this.method = method;
		}

		public function setParm( parm:Object ):void
		{			
			this.parm = parm;
		}
	}
}