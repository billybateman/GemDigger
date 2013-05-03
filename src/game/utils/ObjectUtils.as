﻿package game.utils{	import game.data.*;		import flash.display.*;	public class ObjectUtils	{		public function ObjectUtils()		{		}		/**		 * Strips the object.toString() (which is in the format		 * [object ObjectName]) of everything but the ObjectName.		 */		public static function getName( object:Object ):String		{			if ( object == null ) return null;						var sub:String	= object.toString().substr( 8 );			var name:String	= sub.substr( 0, sub.length - 1 );						return name;		}		/**		 * Centers a DisplayObject on the stage.		 */		public static function center( object:DisplayObject ):void		{			ObjectUtils.centerX( object );			ObjectUtils.centerY( object );		}		/**		 * Centers a DisplayObject's x-coordinate on the stage.		 */		public static function centerX( object:DisplayObject ):void		{			object.x = ( GameData.stage.stageWidth - object.width ) / 2;		}		/**		 * Centers a DisplayObject's y-coordinate on the stage.		 */		public static function centerY( object:DisplayObject ):void		{			object.y = ( GameData.stage.stageHeight - object.height ) / 2;		}		/**		 * Creates an invisible overlay object for custom buttons.		 */		public static function getOverlay( object:DisplayObjectContainer ):Sprite		{			var overlay:Sprite;			overlay = new Sprite();			overlay.buttonMode = true;			overlay.graphics.beginFill( 0x000000, 0 );			overlay.graphics.drawRect( 0, 0, object.width, object.height );			overlay.graphics.endFill();			object.addChild( overlay );			return overlay;		}		/**		 * Creates an invisible overlay object for clickable areas.		 */		public static function getAreaOverlay( width:Number, height:Number ):Sprite		{			var overlay:Sprite;			overlay = new Sprite();			overlay.buttonMode = true;			overlay.graphics.beginFill( 0x000000, 0 );			overlay.graphics.drawRect( 0, 0, width, height );			overlay.graphics.endFill();			return overlay;		}		/**		 * Creates an invisible overlay circle for clickable areas.		 * The registration point is at the center of the circle.		 */		public static function getCircleOverlay( radius:Number ):Sprite		{			var overlay:Sprite;			overlay = new Sprite();			overlay.buttonMode = true;			overlay.graphics.beginFill( 0x000000, 0 );			overlay.graphics.drawCircle( 0, 0, radius );			overlay.graphics.endFill();			return overlay;		}		/**		 * Creates an invisible overlay object for icons.		 */		public static function getIconOverlay():Sprite		{			var overlay:Sprite;			overlay = new Sprite();			overlay.buttonMode = true;			overlay.graphics.beginFill( 0x000000, 0 );			overlay.graphics.drawRect( 0, 0, 100, 100 );			overlay.graphics.endFill();			return overlay;		}				/**		 * Renders a display object to bitmap data.		 */		public static function getBitmapData( object:DisplayObject ):BitmapData		{			var bitmapData:BitmapData = new BitmapData( object.width, object.height, true, 0x00000000 );			bitmapData.draw( object );						return bitmapData;		}					}}