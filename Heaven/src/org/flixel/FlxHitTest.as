package org.flixel {
	import com.coreyoneil.collision.CollisionList;
	
	import errors.IllegalArgumentException;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.data.FlxSize;
	
	public class FlxHitTest {
		
		/**
		 * General function
		 * Hit test two flx objects
		 * They must be either FlxSprite, or group of FlxSprite
		 * 
		 * @param	object1
		 * 			is the first object
		 * @param	object2
		 * 			is the second object
		 * @param	callBack
		 * 			is the callback function when two object overlap
		 * @param	accuracy
		 * 			indicates the accuracy of the test; the higher the more accurate, but the slower
		 * 
		 * @return	true	if two objects overlap
		 * 			false	otherwise
		 */
		static public function overlap(object1:FlxObject, object2:FlxObject,
									   callBack:Function, accuracy:Number = 1):Boolean {
			if (object1 is FlxSprite) {
				if (object2 is FlxSprite)
					return overlapFlxSprites(object1 as FlxSprite, object2 as FlxSprite,
											callBack, accuracy);
				else if (object2 is FlxGroup)
					return overlapFlxSpriteAndFlxGroup(object1 as FlxSprite, object2 as FlxGroup,
													   callBack, accuracy);
			} else if (object2 is FlxGroup) {
				if (object2 is FlxSprite)
					return overlapFlxSpriteAndFlxGroup(object2 as FlxSprite, object1 as FlxGroup,
														callBack, accuracy);
				else if (object2 is FlxGroup)
					return overlapFlxGroups(object1 as FlxGroup, object2 as FlxGroup,
						callBack, accuracy);
			}
			return false;
		}
		
		/**
		 * Hit test a FlxSprite pixels versus another FlxSprite rectangle bound
		 * 
		 * @param	spriteForPixels
		 * 			is the sprite of which pixels is test
		 * @param	spriteForRect
		 * 			is the sprite of which the rectangle bound is test
		 * @param	accuracy
		 * 			indicates the accuracy of the test; the higher the more accurate, but the slower
		 * 
		 * @return	true	if pixels of the spriteForPixels overlaps with
		 * 					the rectangle bound of the spriteForRect
		 * 			fals	otherwise
		 */
		static public function overlapFlxSpritePixelsVSBound(spriteForPixels:FlxSprite,
															spriteForRect:FlxSprite,
															accurracy:Number = 1):Boolean {
			return overlapFlxSpriteAndRectangle(spriteForPixels,
				new Rectangle(spriteForRect.x, spriteForRect.y,
					spriteForRect.width, spriteForRect.height),
				accurracy);
//			return coreyoneilHitTestFlxSpriteAndRectangle(spriteForPixels,
//				new Rectangle(spriteForRect.x, spriteForRect.y,
//					spriteForRect.width, spriteForRect.height));
		}
		
		/**
		 * Hit test a FlxSprite versus a Rectangle
		 * 
		 * @param	sprite
		 * 			is the flixel sprite
		 * @param	rectangle
		 * 			is the rectangle to check against the flixel sprite
		 * @param	accuracy
		 * 			indicates the accuracy of the test; the higher the more accurate, but the slower
		 * 
		 * @return	true	if both objects overlap
		 * 			false	otherwise
		 */
		static private function overlapFlxSpriteAndRectangle(sprite:FlxSprite,
															 rect:Rectangle,
															 accurracy:Number = 1):Boolean {
			var bitmap1:Bitmap = flxSpriteToBitmap(sprite);
			var bitmap2:Bitmap = new Bitmap(new BitmapData(rect.width, rect.height, false));
			bitmap2.x = rect.x; bitmap2.y = rect.y;
			
			FlxG.state.addChildAt(bitmap1, 0);
			FlxG.state.addChildAt(bitmap2, 0);
			
			var result:Boolean = complexIntersectionRectangle( bitmap1, bitmap2, accurracy ).width != 0;
			
			FlxG.state.removeChild(bitmap1);
			FlxG.state.removeChild(bitmap2);
			
			return result;
		}
		
		/**
		 * Hit test a FlxSprite versus a Rectangle
		 * 
		 * @param	sprite
		 * 			is the flixel sprite
		 * @param	rectangle
		 * 			is the rectangle to check against the flixel sprite
		 * @param	accuracy
		 * 			indicates the accuracy of the test; the higher the more accurate, but the slower
		 * 
		 * @return	true	if both objects overlap
		 * 			false	otherwise
		 */
		private static function coreyoneilHitTestFlxSpriteAndRectangle(sprite:FlxSprite, rect:Rectangle):Boolean {
			var bitmap1:Bitmap = flxSpriteToBitmap(sprite);
			var bitmap2:Bitmap = new Bitmap(new BitmapData(rect.width, rect.height, false));
			bitmap2.x = rect.x; bitmap2.y = rect.y;
			
			FlxG.state.addChildAt(bitmap1, 0);
			FlxG.state.addChildAt(bitmap2, 0);
			
			var collisionCheck:CollisionList = new CollisionList(bitmap1, bitmap2);
			var collide:Boolean = collisionCheck.checkCollisions().length > 0;
			
			FlxG.state.removeChild(bitmap1);
			FlxG.state.removeChild(bitmap2);
			
			//return collisionCheck.checkCollisions().length > 0;
			return collide;
		}
	
		
		/**
		 * Hit test two FlxSprite
		 * 
		 * @param	sprite1
		 * 			is the first spriet
		 * @param	sprite2
		 * 			is the second sprite
		 * @param	callBack
		 * 			is the call back function when two objects overlaps
		 * @param	accuracy
		 * 			indicates the accuracy of the test; the higher the more accurate, but the slower
		 * 
		 * @return	true	if two sprites overlap
		 * 			false	otherwise
		 */
		static public function overlapFlxSprites(sprite1:FlxSprite, sprite2:FlxSprite,
												callBack:Function, accuracy:Number = 1):Boolean {
			if (! sprite1.exists || ! sprite2.solid ||
				! sprite2.exists || ! sprite2.solid) return false;
			
			// For performance, we test the two bounding box first, if they do not intersect, then
			// the two objects are not colliding
			
			// Remember old location of two sprite
			var oldOffsetSprite1:FlxPoint = new FlxPoint(sprite1.offset.x, sprite1.offset.y);
			var oldSizeSprite1:FlxSize = new FlxSize(sprite1.width, sprite1.height);
			var oldOffsetSprite2:FlxPoint = new FlxPoint(sprite2.offset.x, sprite2.offset.y);
			var oldSizeSprite2:FlxSize = new FlxSize(sprite2.width, sprite2.height);
			
			// Change offset and size so that they reflect the actual size of the image
			sprite1.offset.x = sprite1.offset.y = 0;
			sprite1.width = sprite1.frameWidth; sprite1.height = sprite1.frameHeight;
			sprite2.offset.x = sprite2.offset.y = 0;
			sprite2.width = sprite2.frameWidth; sprite2.height = sprite2.frameHeight;
			
			// Check for overlap with build-in flixel overlap test - fast
			var flxOverlapTest:Boolean = FlxU.overlap(sprite1, sprite2, doNothing);
			
			// Reset back to normal
			sprite1.offset.x = oldOffsetSprite1.x;
			sprite1.offset.y = oldOffsetSprite1.y;
			sprite1.width = oldSizeSprite1.width;
			sprite1.height = oldSizeSprite1.height;
			sprite2.offset.x = oldOffsetSprite2.x;
			sprite2.offset.y = oldOffsetSprite2.y;
			sprite2.width = oldSizeSprite2.width;
			sprite2.height = oldSizeSprite2.height;
			
			// If two objects do not overlap by flixel build-in test, then they will not
			// overlap for perfect pixel test
			if (! flxOverlapTest) return false;
			
			if (FlxHitTest.complexHitTestObject(sprite1, sprite2, accuracy)) {
			//if (FlxHitTest.coreyoneilHitTest(sprite1, sprite2)) {
				if (callBack != null)
					callBack(sprite1, sprite2);
				return true;
			}
			return false;
		}
		
		/**
		 * Blank function to pass to build-in flixel overlap test
		 * so that two objects does not disappear
		 * 
		 * @param	obj1
		 * 			is the first object in the overlap test
		 * @param	obj2
		 * 			is the second object in the overlap test
		 * 
		 * @return	true	always
		 */
		public static function doNothing(obj1:FlxObject, obj2:FlxObject):Boolean {
			return true;
		}
		
		/**
		 * Hit test a FlxSprite with a group of FlxSprite
		 * 
		 * @param	sprite
		 * 			is the sprite
		 * @param	group
		 * 			is the group to test overlapping versus the sprite
		 * @param	callBack
		 * 			is the callback function when two objects overlaps
		 * @param	accuracy
		 * 			indicatea the accuracy of the test; the higher the more accurate, but the slower
		 * 
		 * @return	true	if the sprite overlaps with at least one member in the group
		 * 			false	otherwise
		 */
		static public function overlapFlxSpriteAndFlxGroup(sprite:FlxSprite, group:FlxGroup,
														   callBack:Function, accuracy:Number = 1):Boolean {
			var overlapping:Boolean = false;
			for (var i:int = 0; i < group.members.length; i++)
				if (group.members[i] != null && group.members[i] is FlxSprite)
					overlapping ||= overlapFlxSprites(sprite, group.members[i] as FlxSprite, callBack, accuracy);
			return overlapping;
		}
		
		/**
		 * Hit test two groups of FlxSprite
		 * 
		 * @param	group1
		 * 			is the first group to test
		 * @param	group2
		 * 			is the second group to test vs group1
		 * @param	callBack
		 * 			is the callback function when two objects overlaps
		 * @param	accuraty
		 * 			indicate the accuracy of the test, the higher the more accurate, but the slower
		 * 
		 * @return	true	if there exists (at least) one member of first group and one member of second group
		 * 					which overlap each other
		 * 			false	otherwise
		 */
		static public function overlapFlxGroups(group1:FlxGroup, group2:FlxGroup,
										callBack:Function, accuracy:Number = 1):Boolean {
			var overlapping:Boolean = false;
			for (var i:int = 0; i < group1.members.length; i++)
				if (group1.members[i] is FlxSprite) {
					var sprite:FlxSprite = group1.members[i] as FlxSprite;
					overlapping ||= overlapFlxSpriteAndFlxGroup(sprite, group2, callBack);
				}
			return overlapping;
				
		}
		
		private static function coreyoneilHitTest(target1:FlxSprite, target2:FlxSprite):Boolean {
			var bitmap1:Bitmap = flxSpriteToBitmap(target1);
			var bitmap2:Bitmap = flxSpriteToBitmap(target2);
			
			FlxG.state.addChildAt(bitmap1, 0);
			FlxG.state.addChildAt(bitmap2, 0);
			
			var collisionCheck:CollisionList = new CollisionList(bitmap1, bitmap2);
			var collide:Boolean = collisionCheck.checkCollisions().length > 0;
			
			FlxG.state.removeChild(bitmap1);
			FlxG.state.removeChild(bitmap2);
			
			//return collisionCheck.checkCollisions().length > 0;
			return collide;
		}
		
		private static function complexHitTestObject( target1:FlxSprite, target2:FlxSprite,  accurracy:Number = 1 ):Boolean
		{
			var bitmap1:Bitmap = flxSpriteToBitmap(target1);
			var bitmap2:Bitmap = flxSpriteToBitmap(target2);
			
			FlxG.state.addChildAt(bitmap1, 0);
			FlxG.state.addChildAt(bitmap2, 0);
			
			var result:Boolean = complexIntersectionRectangle( bitmap1, bitmap2, accurracy ).width != 0;
			
			FlxG.state.removeChild(bitmap1);
			FlxG.state.removeChild(bitmap2);
			
			return result;
		}
		
//		public static function complexHitTestObject( target1:FlxObject, target2:FlxObject,  accurracy:Number = 1 ):Boolean
//		{
//			var bitmap1:Bitmap;
//			var bitmap2:Bitmap;
//			if ( target1 is FlxSprite )
//				bitmap1 = flxSpriteToBitmap(target1 as FlxSprite);
//			else if ( target1 is FlxTilemap )
//				bitmap1 = flxTileMapToBitmap( target1 as FlxTilemap );
//			else
//				throw new IllegalArgumentException( "target1", target1 );
//			
//			if ( target2 is FlxSprite )
//				bitmap2 = flxSpriteToBitmap( target2 as FlxSprite );
//			else if ( target2 is FlxTilemap )
//				bitmap2 = flxTileMapToBitmap( target2 as FlxTilemap );
//			else
//				throw new IllegalArgumentException( "target2", target2 );
//			
//			FlxG.state.addChildAt(bitmap1, 0);
//			FlxG.state.addChildAt(bitmap2, 0);
//			
//			var result:Boolean = complexIntersectionRectangle( bitmap1, bitmap2, accurracy ).width != 0;
//			
//			FlxG.state.removeChild(bitmap1);
//			FlxG.state.removeChild(bitmap2);
//			
//			return result;
//		}
		
		private static function intersectionRectangle( target1:DisplayObject, target2:DisplayObject ):Rectangle
		{
			// If either of the items don't have a reference to stage, then they are not in a display list
			// or if a simple hitTestObject is false, they cannot be intersecting.
			if( !target1.root || !target2.root || !target1.hitTestObject( target2 ) ) return new Rectangle();
			
			// Get the bounds of each DisplayObject.
			var bounds1:Rectangle = target1.getBounds( target1.root );
			var bounds2:Rectangle = target2.getBounds( target2.root );
			
			// Determine test area boundaries.
			var intersection:Rectangle = new Rectangle();
			intersection.x 		= Math.max( bounds1.x, bounds2.x );
			intersection.y		= Math.max( bounds1.y, bounds2.y );
			intersection.width 	= Math.min( ( bounds1.x + bounds1.width ) - intersection.x, ( bounds2.x + bounds2.width ) - intersection.x );
			intersection.height = Math.min( ( bounds1.y + bounds1.height ) - intersection.y, ( bounds2.y + bounds2.height ) - intersection.y );
			
			return intersection;
		}
		
		public static function complexIntersectionRectangle( target1:DisplayObject, target2:DisplayObject, accurracy:Number = 1 ):Rectangle
		{			
			
			// If a simple hitTestObject is false, they cannot be intersecting.
			if( !target1.hitTestObject( target2 ) ) return new Rectangle();
			
			var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
			// If their boundaries are no interesecting, they cannot be intersecting.
			if( hitRectangle.width * accurracy < 1 || hitRectangle.height * accurracy < 1 ) return new Rectangle();
			
			var bitmapData:BitmapData = new BitmapData( hitRectangle.width * accurracy, hitRectangle.height * accurracy, false, 0x000000 );	
			
			// Draw the first target.
			bitmapData.draw( target1, FlxHitTest.getDrawMatrix( target1, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
			// Overlay the second target.
			bitmapData.draw( target2, FlxHitTest.getDrawMatrix( target2, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );
			
			// Find the intersection.
			var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );
			
			bitmapData.dispose();
			
			// Alter width and positions to compensate for accurracy
			if( accurracy != 1 )
			{
				intersection.x /= accurracy;
				intersection.y /= accurracy;
				intersection.width /= accurracy;
				intersection.height /= accurracy;
			}
			
			intersection.x += hitRectangle.x;
			intersection.y += hitRectangle.y;
			
			return intersection;
		}
		
		private static function flxSpriteToBitmap(Graphic:FlxSprite):Bitmap
		{
			var bitmap:Bitmap = new Bitmap(Graphic._framePixels);
			
			var mtx:Matrix = new Matrix();
			mtx.translate( -Graphic.origin.x, -Graphic.origin.y);
			mtx.scale(Graphic.scale.x, Graphic.scale.y);
			mtx.rotate(Math.PI * 2 * Graphic.angle / 360);
			mtx.translate(Graphic.x - Graphic.offset.x + Graphic.origin.x, Graphic.y - Graphic.offset.y + Graphic.origin.y);
			
			bitmap.transform.matrix = mtx;
			
			return bitmap;
		}
		
//		private static function flxTileMapToBitmap(Graphic:FlxTilemap):Bitmap {
//			var bitmap:Bitmap = new Bitmap(Graphic._buffer);
//			
//			var mtx:Matrix = new Matrix();
//			mtx.translate( -Graphic.origin.x, -Graphic.origin.y);
//			mtx.rotate(Math.PI * 2 * Graphic.angle / 360);
//			mtx.translate(Graphic.x + Graphic.origin.x, Graphic.y + Graphic.origin.y);
//			
//			bitmap.transform.matrix = mtx;
//			
//			return bitmap;
//		}
		
		private static function getDrawMatrix( target:DisplayObject, hitRectangle:Rectangle, accurracy:Number ):Matrix
		{
			var localToGlobal:Point;;
			var matrix:Matrix;
			
			var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;
			
			localToGlobal = target.localToGlobal( new Point( ) );
			matrix = target.transform.concatenatedMatrix;
			matrix.tx = localToGlobal.x - hitRectangle.x;
			matrix.ty = localToGlobal.y - hitRectangle.y;
			
			matrix.a = matrix.a / rootConcatenatedMatrix.a;
			matrix.d = matrix.d / rootConcatenatedMatrix.d;
			if( accurracy != 1 ) matrix.scale( accurracy, accurracy );
			
			return matrix;
		}
	}
}