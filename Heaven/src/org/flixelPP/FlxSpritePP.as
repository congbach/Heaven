/*
 * This code is in public domain. 
 */
package org.flixelPP 
{
	import flash.display.*;
	import flash.geom.*;
	import org.flixel.*;
	
	public class FlxSpritePP extends FlxSprite
	{
		public function FlxSpritePP(X:Number=0,Y:Number=0,SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
		}
		
		/**
		 * Checks to see if some <code>FlxSpritePP</code> object overlaps this <code>FlxSpritePP</code> object. 
		 * Works on pixel perfect level.
		 * 
		 * @param	obj		The object being tested.
		 * 
		 * @return	intersection rectangle if any, or null.
		 */
		public function overlapsPP(obj:FlxSpritePP):Rectangle
		{
			//(FlxG.state as PlayState).txt.text = "";//DEBUG
			
			var bounds:Rectangle = _rectPP.intersection(obj._rectPP);
			bounds.left = Math.floor(bounds.left);
			bounds.top = Math.floor(bounds.top);
			bounds.width = Math.ceil(bounds.width);
			bounds.height = Math.ceil(bounds.height);
			
			if (bounds.width < 1 || bounds.height < 1)
				return null;
//			var rect1:Rectangle = new Rectangle(x - offset.x, y - offset.y, frameWidth, frameHeight);
//			var rect2:Rectangle = new Rectangle(obj.x - obj.offset.x, obj.y - obj.offset.y, obj.frameWidth, obj.frameHeight);
//			var bounds:Rectangle = rect1.intersection(rect2);
			
			var bmp:BitmapData = new BitmapData(bounds.width, bounds.height, false, 0);
//			var bitmap:Bitmap = new Bitmap(bmp);
//			FlxG.state.addChild(bitmap);
			
			_mtxPP.translate( -bounds.x, -bounds.y);
			// draw red
			bmp.draw(_framePixels, _mtxPP, new ColorTransform(1, 1, 1, 1, 255, -255, -255, 255));
			
			// draw green
			if(obj !== this)
				obj._mtxPP.translate( -bounds.x, -bounds.y);
			bmp.draw(obj._framePixels, obj._mtxPP, new ColorTransform(1, 1, 1, 1, -255, 255, -255, 255), BlendMode.ADD);
			
			// search for red+green
			var intersection:Rectangle = bmp.getColorBoundsRect(0xFFFFFF, 0xFFFF00);

			//(FlxG.state as PlayState).txt.text = bmp.getPixel(0, 0).toString(16) + " " + bmp.getPixel(0, 1).toString(16) 
			//	+ " " + intersection.toString();//DEBUG
			
//			FlxG.state.removeChild(bitmap);
			if (intersection.width < 1 || intersection.height < 1)
				return null;
				
			intersection.offset(bounds.x, bounds.y);
				
			return intersection;
		}
		
		/**
		 * Checks to see if a point overlaps this FlxSpritePP object.
		 * 
		 * @param	X			The X coordinate of the point.
		 * @param	Y			The Y coordinate of the point.
		 * @param	screen		Set to true to use screen coordinates, false to use space coordinates.
		 * 
		 * @return	Whether or not the point overlaps this object.
		 */
		public function overlapsPointPP(x:Number, y:Number, screen:Boolean = false):Boolean
		{
			var invMtx:Matrix = _mtxPP.clone();
			if (!screen)
				invMtx.translate( -FlxU.floor(FlxG.scroll.x * scrollFactor.x), -FlxU.floor(FlxG.scroll.y * scrollFactor.y));
			invMtx.invert();
			
			var pt:Point = invMtx.transformPoint(new Point(x, y));
			if (pt.x >= 0 && pt.x < _framePixels.width && pt.y >= 0 && pt.y < _framePixels.height)
				return 0 != (_framePixels.getPixel32(pt.x, pt.y) & 0xFF000000);
			else
				return false;
		}
		
		/**
		 * Call this before calling overlapsPP or overlapsPointPP function. 
		 * FlxUPP.overlapPP calls this function automatically.
		 */
		public function preparePP():void
		{
		// _mtxPP - transformation matrix (same as in render())
			getScreenXY(_point);
			_mtxPP.identity();
			_mtxPP.translate(-origin.x,-origin.y);
			_mtxPP.scale(scale.x,scale.y);
			if(angle != 0) _mtxPP.rotate(Math.PI * 2 * (angle / 360));
			_mtxPP.translate(_point.x + origin.x, _point.y + origin.y);
		//_rectPP - bounding box
			var p1:Point = new Point(0, 0);
			var p2:Point = new Point(frameWidth, 0);
			var p3:Point = new Point(0, frameHeight);
			var p4:Point = new Point(frameWidth, frameHeight);
			p1 = _mtxPP.transformPoint(p1);
			p2 = _mtxPP.transformPoint(p2);
			p3 = _mtxPP.transformPoint(p3);
			p4 = _mtxPP.transformPoint(p4);
			_rectPP.left = Math.min(p1.x, p2.x, p3.x, p4.x);
			_rectPP.right = Math.max(p1.x, p2.x, p3.x, p4.x);
			_rectPP.top = Math.min(p1.y, p2.y, p3.y, p4.y);
			_rectPP.bottom = Math.max(p1.y, p2.y, p3.y, p4.y);
		}

		private var _rectPP:Rectangle = new Rectangle;
		private var _mtxPP:Matrix = new Matrix;
	}

}