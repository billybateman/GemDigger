package game.controllers
{
	import data.*;
	
	
	import game.net.*;
	import game.data.*;
	import game.utils.*;
	import game.events.*;

	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;

	public class PrizeManager extends EventDispatcher
	{
		public static const TYPE_TOKEN:String		= 'Token';
		public static const TYPE_PRIZE:String		= 'Prize';
		public static const TYPE_BONUS:String		= 'Bonus';
		public static const TYPE_OFFER:String		= 'Offer';
		public static const TYPE_DESTRUCTOR:String	= 'Destructor';

		public static const STATUS_CREATED:String	= 'Created';
		public static const STATUS_WON:String		= 'Won';
		public static const STATUS_USED:String		= 'Used';
		public static const STATUS_OPENED:String	= 'Opened';
		public static const STATUS_DESTROYED:String	= 'Destroyed';
		public static const STATUS_HIDDEN:String	= 'Hidden';
		public static const STATUS_AVAILABLE:String	= 'Available';
		public static const STATUS_SELECTED:String	= 'Selected';

		private const ICON_PREFIX:String			= 'icons.';

		/**
		 * Holds the prizes per scene.
		 */
		private var _prize:Array;

		private var prize:GamePrize;
		//private var request:GameRequest;

		private var id:String;
		private var text:String;
		private var file:String;
		private var scene:String;

		public function PrizeManager():void
		{
			_prize = new Array();
		}

		public function setScene( scene:String ):void
		{
			this.scene = scene;

			if ( !_prize[ this.scene ] ) {

				_prize[ this.scene ] = new Array();
			}
		}

		public function getPrize( container:int, confirm:Boolean=true ):GamePrize
		{
			var prizes:Array = this.getCreatedPrizes( this.scene );

			TraceUtil.addLine( 'PrizeManager getPrize() prizes.length: ' + prizes.length );

			if ( prizes.length == 0 ) return null;

			this.prize = prizes[ 0 ];
			return this.winPrize( container, confirm );
		}

		public function winPrizeBySeq( sequence:int, container:int, confirm:Boolean=true ):GamePrize
		{
			this.prize = this.getPrizeBySequence( this.scene, sequence );
			return this.winPrize( container, confirm );
		}

		public function winPrize( container:int, confirm:Boolean=true ):GamePrize
		{
			this.prize.container = container;
			this.prize.status = PrizeManager.STATUS_WON;

			//TraceUtil.addLine( 'PrizeManager winPrize() id: ' + this.prize.id );
			//TraceUtil.addLine( 'PrizeManager winPrize() status: ' + this.prize.status );
			//TraceUtil.addLine( 'PrizeManager winPrize() text: ' + this.prize.text );
			//TraceUtil.addLine( 'PrizeManager winPrize() type: ' + this.prize.type );
			//TraceUtil.addLine( 'PrizeManager winPrize() qty: ' + this.prize.qty );
			//TraceUtil.addLine( 'PrizeManager winPrize() sequence: ' + this.prize.sequence );
			//TraceUtil.addLine( 'PrizeManager winPrize() container: ' + this.prize.container );

			if ( confirm ) this.confirmPrize( container );

			return this.prize;
		}

		public function selectPrize( container:int, confirm:Boolean=true ):GamePrize
		{
			var prizes:Array = this.getAvailablePrizes( this.scene );

			//TraceUtil.addLine( 'PrizeManager selectPrize() prizes.length: ' + prizes.length );

			if ( prizes.length == 0 ) return null;

			this.prize				= prizes[ 0 ];
			this.prize.container	= container;
			this.prize.status 		= PrizeManager.STATUS_SELECTED;

			//TraceUtil.addLine( 'PrizeManager selectPrize() id: ' + this.prize.id );
			//TraceUtil.addLine( 'PrizeManager selectPrize() status: ' + this.prize.status );
			//TraceUtil.addLine( 'PrizeManager selectPrize() text: ' + this.prize.text );
			//TraceUtil.addLine( 'PrizeManager selectPrize() type: ' + this.prize.type );
			//TraceUtil.addLine( 'PrizeManager selectPrize() qty: ' + this.prize.qty );
			//TraceUtil.addLine( 'PrizeManager selectPrize() sequence: ' + this.prize.sequence );
			//TraceUtil.addLine( 'PrizeManager selectPrize() container: ' + this.prize.container );

			if ( confirm ) this.confirmPrize( container );

			return this.prize;
		}

		public function selectPrizeBySeq( sequence:int, container:int, confirm:Boolean=true ):GamePrize
		{
			this.prize				= this.getPrizeBySequence( this.scene, sequence );
			this.prize.container	= container;
			this.prize.status 		= PrizeManager.STATUS_SELECTED;

			//TraceUtil.addLine( 'PrizeManager selectPrizeBySeq() id: ' + this.prize.id );
			//TraceUtil.addLine( 'PrizeManager selectPrizeBySeq() status: ' + this.prize.status );
			//TraceUtil.addLine( 'PrizeManager selectPrizeBySeq() text: ' + this.prize.text );
			//TraceUtil.addLine( 'PrizeManager selectPrizeBySeq() type: ' + this.prize.type );
			//TraceUtil.addLine( 'PrizeManager selectPrizeBySeq() qty: ' + this.prize.qty );
			//TraceUtil.addLine( 'PrizeManager selectPrizeBySeq() sequence: ' + this.prize.sequence );
			//TraceUtil.addLine( 'PrizeManager selectPrizeBySeq() container: ' + this.prize.container );

			if ( confirm ) this.confirmPrize( container );

			return this.prize;
		}

		public function confirmPrize( data:int ):void
		{
			TraceUtil.addLine( 'PrizeManager confirmPrize() data: ' + data );
			//this.request = new GameRequest( GameRequest.REQUEST_PRIZE, String( data ) );
			//this.request.addEventListener( PrizeEvent.PRIZE_RECEIVED, this.prizeReceived );
		}

		public function confirmPrizeData( data:String, encrypt:Boolean = false ):void
		{
			TraceUtil.addLine( 'PrizeManager confirmPrizeData() data: ' + data );
			
			this.prizeReceived();
				
			
			//this.request = new GameRequest( GameRequest.REQUEST_PRIZE, data, encrypt );
			//this.request.addEventListener( PrizeEvent.PRIZE_RECEIVED, this.prizeReceived );
		}

		public function setPrize(	id:String,
									status:String,
									type:String,
									text:String,
									qty:int,
									sequence:int = -1,
									container:int = -1 ):GamePrize
		{
			var prize:GamePrize	= new GamePrize();

			prize.id			= id;
			prize.status		= status;
			prize.type			= type;
			prize.text			= text;
			prize.qty			= qty;
			prize.sequence		= sequence;
			prize.container		= container;

			_prize[ this.scene ].push( prize );

			return prize;
		}

		public function getPrizeBySequence( scene:String, sequence:int ):GamePrize
		{
			var prizes:Array = this.getPrizes( scene );

			for each ( var prize:GamePrize in prizes ) {

				if ( prize.sequence == sequence ) {

					return prize;
				}
			}

			return null;
		}

		public function getScenePrizes( scene:String ):Array
		{
			TraceUtil.addLine( 'PrizeManager getScenePrizes().' );
			
			if ( _prize[ scene ] ) {

				var prizes:Array = new Array();

				for each ( var prize:GamePrize in _prize[ scene ] ) {

					prizes.push( prize );
				}

				return prizes;

			} else {

				return new Array();
			}
		}

		public function getPrizes( scene:String ):Array
		{
			var all:Array		= this.getScenePrizes( scene );
			var prizes:Array	= new Array();

			for each ( var prize:GamePrize in all ) {

				if ( prize.status != PrizeManager.STATUS_HIDDEN ) {

					prizes.push( prize );
				}
			}

			return prizes;
		}

		public function getPrizesByStatus( status:String, scene:String ):Array
		{
			var all:Array		= this.getScenePrizes( scene );
			var prizes:Array	= new Array();

			for each ( var prize:GamePrize in all ) {

				if ( prize.status == status ) {

					prizes.push( prize );
				}
			}

			return prizes;
		}

		public function getCreatedPrizes( scene:String ):Array
		{
			return this.getPrizesByStatus( PrizeManager.STATUS_CREATED, scene );
		}

		public function getWonPrizes( scene:String ):Array
		{
			return this.getPrizesByStatus( PrizeManager.STATUS_WON, scene );
		}

		public function getAvailablePrizes( scene:String ):Array
		{
			return this.getPrizesByStatus( PrizeManager.STATUS_AVAILABLE, scene );
		}

		public function getHiddenPrizes( scene:String ):Array
		{
			return this.getPrizesByStatus( PrizeManager.STATUS_HIDDEN, scene );
		}

		public function getHiddenPrizesBySequence( sequence:int ):Array
		{
			var all:Array		= this.getScenePrizes( this.scene );
			var prizes:Array	= new Array();

			//TraceUtil.addLine( 'PrizeManager getHiddenPrizesBySequence() scene: ' + this.scene );
			//TraceUtil.addLine( 'PrizeManager getHiddenPrizesBySequence() all.length: ' + all.length );

			for each ( var prize:GamePrize in all ) {

				if ( ( prize.status == PrizeManager.STATUS_HIDDEN ) && ( prize.sequence == sequence ) ) {

					prizes.push( prize );
				}
			}

			return prizes;
		}

		public function getContainerStatus( scene:String, container:String ):String
		{
			//TraceUtil.addLine( 'PrizeManager getContainerStatus() scene: ' + scene + ' container: ' + container );

			var all:Array		= this.getScenePrizes( scene );
			var prizes:Array	= new Array();

			for each ( var prize:GamePrize in all ) {

				if ( prize.container == int( container ) ) return prize.status;
			}

			return null;
		}

		/**
		 * Gets the number of prizes the user has already won.
		 */
		public function getNumPrizes( scene:String ):uint
		{
			var won:Array = this.getWonPrizes( scene );
			return won.length;
		}

		private function prizeReceived(  ):void
		{
			TraceUtil.addLine( 'PrizeManager prizeReceived() >>> Prize confirmation has been received' );
			this.dispatchEvent( new PrizeEvent( PrizeEvent.PRIZE_RECEIVED ) );
		}
	}
}
