package controllers
{
	import game.controllers.PrizeManager;

	public class PrizeController extends PrizeManager
	{
		private static const _instance:PrizeController = new PrizeController( Lock );

		public function PrizeController( lock:Class )
		{
			// Verify that the lock is the correct class reference.
			if ( lock == Lock ) {

				super();

			} else {

				throw new Error( 'Invalid singleton instantiation attempt.' );
			}
		}

		public static function get instance():PrizeController
		{
			return _instance;
		}
	}
}

/**
* This is a private class declared outside of the package
* that is only accessible to classes inside of this
* file.  Because of that, no outside code is able to get a
* reference to this class to pass to the constructor, which
* enables us to prevent outside instantiation.
*/
class Lock {}
