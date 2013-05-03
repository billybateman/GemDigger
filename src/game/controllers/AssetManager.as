package game.controllers
{
	import game.data.*;
	import game.utils.*;

	/**
	 * The AssetManager class is used to manage assets
	 * loaded from external sources. These assets can
	 * be either images (png, jpg, gif) or SWF files.
	 */
	public class AssetManager
	{
		/**
		 * Holds all the assets for the manager. Each asset is
		 * accessed by the asset id.
		 */
		private var asset:Object = new Object();

		public function AssetManager()
		{
		}

		/**
		 * Adds an existing GameAssetLoader to the asset manager.
		 * 
		 * @param id	: The id by which the asset will be identified in this game.
		 * @param asset	: The actual asset as a GameAssetLoader.
		 */
		public function addGameAssetLoader( id:String, asset:GameAssetLoader ):void
		{
			this.asset[ id ] = asset;
		}

		/**
		 * Creates a GameAssetLoader and adds the asset to the asset manager.
		 * 
		 * @param id:			The id by which the asset is identified in the game.
		 * @param file:			The actual file name of the asset on the host system.
		 * @param url:			The URL where the file is stored.
		 * @param fallback:		States whether a fallback location for this asset is
		 * 						defined if the asset cannot be loaded from the original URL.
		 * 						Usually used to define a default language asset.
		 * @param fallbackURL:	Defines the fallback location used to load the asset if the
		 * 						asset cannot be loaded from the original URL.
		 */
		public function addAsset( id:String, file:String, url:String, fallback:Boolean = false, fallbackURL:String = '' ):void
		{
			//TraceUtil.addLine( 'AssetManager addAsset() >>> Adding image...id:' + id + ', file:' + file + ', url:' + url );
			var asset:GameAssetLoader = new GameAssetLoader( id, file, url, fallback, fallbackURL );
			this.addGameAssetLoader( id, asset );
		}

		/**
		 * Takes a predefined GameAsset, creates a GameAssetLoader
		 * from its poperties, and adds the GameAssetLoader to the
		 * asset manager. This is a good way to define assets during
		 * the intialization phase of the game with GameData.setAsset()
		 * and load them at a later point in the game.
		 * 
		 * Restrictions:
		 * 
		 * - Only adds assets of type GameData.ASSET_TYPE_IMAGE
		 * and GameData.ASSET_TYPE_SWF. If the asset is not of one of
		 * these types, this method does nothing.
		 * 
		 * - If the asset with the
		 * specified id does not exist, the method does nothing.
		 * 
		 * @param id: The ID of the asset defined with GameData.setAsset().
		 */
		public function addGameAsset( id:String ):void
		{
			//TraceUtil.addLine( 'AssetManager addGameAsset() >>> Adding asset from GameData...id:' + id );
			var asset:GameAsset = GameData.getAsset( id );
			var url:String;
			var defaultURL:String;

			if ( !asset ) return;

			switch ( asset.type ) {

				case GameData.ASSET_TYPE_IMAGE :
					url			= GameConfig.langImageURL;
					defaultURL	= GameConfig.defaultImageURL;
					break;

				case GameData.ASSET_TYPE_SWF :
					url			= GameConfig.langSwfURL;
					defaultURL	= GameConfig.defaultSwfURL;
					break;

				default: return;
			}

			this.addAsset( id, asset.name, url, true, defaultURL );
		}

		/**
		 * Loads an asset from it external location.
		 * 
		 * @param id: The ID by which the asset is identified.
		 */
		public function loadAsset( id:String ):void
		{
			//TraceUtil.addLine( 'AssetManager loadAsset() >>> Loading asset...id:' + id );
			var asset:GameAssetLoader = this.asset[ id ];
			asset.load();
		}

		/**
		 * Retrieves a GameAsset from the GameData asset container,
		 * creates the GameAssetLoader, and loads the asset from its
		 * external location.
		 * 
		 * @param id: The ID by which the asset is identified.
		 */
		public function loadGameAsset( id:String ):void
		{
			this.addGameAsset( id );
			this.loadAsset( id );
		}

		/**
		 * Retrieves a GameAssetLoader from the AssetManager.
		 * 
		 * @param id: The ID by which the asset is identified.
		 */
		public function getAsset( id:String ):GameAssetLoader
		{
			TraceUtil.addLine( 'AssetManager getAsset() >>> Getting asset...id:' + id );
			return ( this.asset[ id ] ) ? this.asset[ id ] as GameAssetLoader : null;
		}

		public function assetExists( id:String ):Boolean
		{
			return ( this.asset[ id ] ) ? true : false;
		}
	}
}