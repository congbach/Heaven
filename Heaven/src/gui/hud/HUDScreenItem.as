package gui.hud {
	import data.GameConstants;
	
	import gui.GameGroup;
	
	import org.flixel.FlxBitmapFont;
	
	/**
	 * HUDScreenItem class
	 * @author Ken
	 * 
	 * Represents a single item on the HUD screen
	 */
	public class HUDScreenItem extends GameGroup {
		
		/** Title ofthis item */
		protected var _title:String;
		public function get title():String { return _title; }
		/** Description of this item */
		protected var _description:String;
		public function get description():String { return _description; }
		/** The text which display the title of this item */
		public var titleText:FlxBitmapFont;
		/** Call back function to call when this item is selected */
		protected var _callBack:Function;
		/** Flag to indicate whether this item has callback item attached to it */
		public function get hasCallBack():Boolean { return _callBack != null; }
		/** The object which is bounded to this item */
		protected var _object:Object;
		public function get object():Object { return _object; }
		
		/**
		 * Default constructor
		 * 
		 * @param	title
		 * 			is the title of this item
		 * @param	description
		 * 			is the description of this item
		 * @param	object
		 * 			is the object which is bounded to this item
		 * @param	callBack
		 * 			is the function to call when this item is dismissed after selected
		 * @param	x
		 * 			is the x coordinate of this item
		 * @param	y
		 * 			is the y coordinate of this item
		 * @param	mouseOver
		 * 			indicated whether this item is currenly being chosen or not
		 */
		public function HUDScreenItem(title:String, description:String, object:Object = null,
										callBack:Function = null, x:int = 0, y:int = 0, mouseOver:Boolean = false) {
			super();
			this.scrollFactor.x = this.scrollFactor.y = 0;
			titleText = FlxBitmapFont.getDesignedFont(GameConstants.FONT);
			//titleText.scrollFactor.x = titleText.scrollFactor.y = 0;
			//add(titleText);
			resetItem(title, description, object, callBack, mouseOver);
			reset(x, y);
		}
		
		/**
		 * Animation when mouse over this item, bold the title text
		 */
		public function mouseOver():void {
			titleText.alpha = 1;
		}
		
		/**
		 * Animation when mouse out this item, fade the title text
		 */
		public function mouseOut():void {
			titleText.alpha = GameConstants.HUD_SCREEN_ITEM_UNSELECTED_ALPHA;
		}
		
		/**
		 * Player has selected this item, perform what it has to do
		 */
		public function selected():void {
			// Perform nothing, finish immediately
			// do not override
			finished();
		}
		
		/**
		 * Finish performing task when player selects this item, call the call
		 * back function if any
		 */
		public function finished():void {
			if (_callBack != null) {
				if (_object != null) _callBack(_object);
				else _callBack();
			}
		}
		
		/**
		 * Reset function, for recycling
		 * 
		 * @param	title
		 * 			is the title of this item
		 * @param	description
		 * 			is the description of this item
		 * @param	object
		 * 			is the object which is bounded to this item
		 * @param	callBack
		 * 			is the function to call when this item is dismissed after selected
		 * @param	x
		 * 			is the x coordinate of this item
		 * @param	y
		 * 			is the y coordinate of this item
		 * @param	mouseOver
		 * 			indicated whether this item is currenly being chosen or not
		 */
		public function resetItem(title:String, description:String, object:Object = null,
							callBack:Function = null, mouseOver:Boolean = false):void {
			//titleText.x = x; titleText.y = y;
			_callBack = callBack; _object = object;
			_title = title; _description = description;
			titleText.text = _title;
			if (! mouseOver) mouseOut();
			//reset(x, y);
		}
	}
}