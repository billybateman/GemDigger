package game.data
{
	public class GameSceneData
	{
		public static const STATUS_CREATED:String	= 'Created';
		public static const STATUS_STARTED:String	= 'Started';
		public static const STATUS_FINISHED:String	= 'Finished';

		public var name:String;
		public var status:String;

		public function GameSceneData()
		{
		}
	}
}