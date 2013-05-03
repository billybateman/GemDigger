package game.data
{
	import game.utils.*;
	import game.events.*;
	import game.errors.*;

	import flash.net.*;
	import flash.events.*;
	import flash.display.*;

	/**
	 * The GameAssetLoader class contains methods to load and manage an asset
	 * that is stored in an external location. The class is usually used to
	 * load images or SWFs that are language- or site-dependent so they can
	 * be loaded only when actually needed. A fallback can be specified if the
	 * image cannot be loaded from the originally specified URL, usually the
	 * default language URL.
	 */
	public class GameAssetLoader extends Sprite
	{
		/**
		 * The ID by which the image will be identified in the game.
		 */
		public var id:String;

		/**
		 * The URL from which the image file will be loaded 
		 */
		public var url:String;

		/**
		 * The image's file name.
		 */
		public var file:String;

		/**
		 * The Loader that contains the DisplayObject.
		 */
		public var loader:Loader;

		/**
		 * If the asset cannot be loaded, should a
		 * fallbackURL be used?
		 */
		public var fallback:Boolean;

		/**
		 * The fallback URL to be used if the asset
		 * cannot be loaded from the original URL. This
		 * is usually the default language URL.
		 */
		public var fallbackURL:String;

		/**
		 * Set to true if the asset has been loaded and
		 * the content is available. Otherwise set to false.
		 */
		public var contentAvailable:Boolean;

		/**
		 * The URL currently being used to load the asset
		 */
		public var loadURL:String;

		public function GameAssetLoader( id:String, file:String, url:String, fallback:Boolean = false, fallbackURL:String = '' )
		{
			this.init( id, file, url, fallback, fallbackURL );
		}

		/**
		 * Loads the asset from its external location.
		 * 
		 * @param useFallback:	Use the fallback URL to load the asset? If set to true
		 * 						the fallbackURL is used to load the asset, otherwise
		 * 						the url is used to load the asset. Default is false.
		 */
		public function load( useFallback:Boolean = false ):void
		{
			//TraceUtil.addLine( 'GameLoader load() >>> loading image...id:' + this.id + ' file:' + this.file + ' url:' + this.url + ' useFallback:' + useFallback );

			this.loadURL			= ( useFallback ) ? this.fallbackURL : this.url;
			var url:String			= URLUtils.join( this.loadURL, this.file );
			var request:URLRequest	= new URLRequest( url );

			this.loader = new Loader();
			this.addListeners();
			this.loader.contentLoaderInfo.addEventListener( Event.COMPLETE, this.loadComplete );
			this.loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, this.ioError );
			this.loader.load( request );

			this.addChild( this.loader );
		}

		/**
		 * Attempts to stop and unload a loaded SWF file.
		 */
		public function unload():void
		{
			this.loader.unloadAndStop();
		}

		/**
		 * Sets the x/y coordinates of the Loader DisplayObject,
		 * which is a child of the GameAssetLoader object.
		 */
		public function setAssetCoords( x:Number, y:Number ):void
		{
			this.loader.x = x;
			this.loader.y = y;
		}

		/**
		 * Returns the content of the loaded asset without making
		 * any distinction regarding the content's datatype.
		 */
		public function getContent():DisplayObject
		{
			return this.loader.content;
		}

		/**
		 * If the loaded asset is an image (Bitmap), this method
		 * returns the content as a Bitmap.
		 */
		public function getBitmap( smoothing:Boolean = true ):Bitmap
		{
			if ( this.loader.content is Bitmap ) {

				var bitmap:Bitmap = this.loader.content as Bitmap;
				bitmap.smoothing = smoothing;
				return bitmap;

			} else {

				var msgNo:String	= GameError.ERR_NO_1130;
				var msgTxt:String	= GameError.ERR_TXT_1130;
				var msgData:String	= 'ID: ' + this.id + ' file: ' + this.file + ' content:' + this.loader.content;
				GameError.setError( msgNo, msgTxt, msgData );

				return null;
			}
		}

		/**
		 * If the loaded asset is an image (Bitmap), the BitmapData
		 * of the image can be retrieved with this method.
		 */
		public function getBitmapData():BitmapData
		{
			if ( this.loader.content is Bitmap ) {

				var bitmap:Bitmap = this.loader.content as Bitmap;
				return bitmap.bitmapData;

			} else {

				var msgNo:String	= GameError.ERR_NO_1131;
				var msgTxt:String	= GameError.ERR_TXT_1131;
				var msgData:String	= 'ID: ' + this.id + ' file: ' + this.file + ' content:' + this.loader.content;
				GameError.setError( msgNo, msgTxt, msgData );

				return null;
			}
		}

		/**
		 * If the loaded asset is a SWF file, this method
		 * returns the content as a MovieClip.
		 */
		public function getMovieClip():MovieClip
		{
			if ( this.loader.content is MovieClip ) {

				return this.loader.content as MovieClip;

			} else {

				var msgNo:String	= GameError.ERR_NO_1132;
				var msgTxt:String	= GameError.ERR_TXT_1132;
				var msgData:String	= 'ID: ' + this.id + ' file: ' + this.file + ' content:' + this.loader.content;
				GameError.setError( msgNo, msgTxt, msgData );

				return null;
			}
		}

		protected function addListeners():void
		{
			this.loader.contentLoaderInfo.addEventListener( Event.COMPLETE, this.loadComplete );
			this.loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, this.ioError );
		}

		protected function removeListeners():void
		{
			this.loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, this.loadComplete );
			this.loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, this.ioError );
		}

		protected function loadComplete( event:Event ):void
		{
			this.removeListeners();
			this.contentAvailable = true;
			this.dispatchEvent( new GameEvent( GameEvent.ASSET_LOADED ) );
			TraceUtil.addLine( 'GameLoader loadComplete() >>> Asset successfully loaded...id:' + this.id + ' file:' + this.file + ' content:' + this.loader.content );
		}

		protected function init( id:String, file:String, url:String, fallback:Boolean, fallbackURL:String ):void
		{
			this.id				= id;
			this.url			= url;
			this.file			= file;
			this.fallback		= fallback;
			this.fallbackURL	= fallbackURL;
			this.contentAvailable		= false;

			if ( fallback && !fallbackURL ) {

				var msgNo:String	= GameError.ERR_NO_1114;
				var msgTxt:String	= GameError.ERR_TXT_1114;
				var msgData:String	= 'ID: ' + this.id + ', File: ' + this.file;

				GameError.setError( msgNo, msgTxt, msgData );
			}
		}

		protected function ioError( event:IOErrorEvent ):void
		{
			this.removeListeners();
			TraceUtil.addLine( 'GameLoader ioError() ==> ERROR id:' + this.id + ' text:' + event.text + ' File:' + this.file + ' URL:' + this.loadURL );

			if ( this.fallback && ( this.url != this.fallbackURL ) && ( this.loadURL == this.url ) ) {

				this.load( true );

			} else {

				var msgNo:String	= GameError.ERR_NO_1115;
				var msgTxt:String	= GameError.ERR_TXT_1115;
				var msgData:String	= 'ID: ' + this.id + ', File: ' + this.file + ', URL: ' + this.loadURL;

				GameError.setError( msgNo, msgTxt, msgData );
			}
		}
	}
}