package controllers
{
	import game.controllers.SceneManager;

	public class SceneController extends SceneManager
	{
		private static const _instance:SceneController = new SceneController( Lock );

		public function SceneController( lock:Class )
		{
			// Verify that the lock is the correct class reference.
			if ( lock == Lock ) {

				super();

			} else {

				throw new Error( 'Invalid singleton instantiation attempt.' );
			}
		}

		public static function get instance():SceneController
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