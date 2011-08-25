package org.flixel.data {
	
	/**
	 * FlxSize
	 * 
	 * Represents size of flx sprite (boundary rectangle)
	 */
	public class FlxSize {
		
		/** The width of this */
		public var width:Number;
		/** The height of this */
		public var height:Number;
		
		/**
		 * Default constructor
		 * 
		 * @param	width
		 * 			is the width of this
		 * @param	height
		 * 			is the height of this
		 */
		public function FlxSize(width:Number, height:Number) {
			this.width = width;
			this.height = height;
		}
	}
}