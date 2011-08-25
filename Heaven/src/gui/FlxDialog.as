package gui {
	
	
	import data.GameConstants;
	import data.KeyboardConstants;
	
	import org.flixel.*;
	
	public class FlxDialog extends FlxGroup {
		
		/**
		 * Use this to tell if dialog is showing on the screen or not.
		 */
		public var showing:Boolean;
		
		/**
		 * The text field which displays who is currently talking
		 */
		private var _speakerField:FlxBitmapFont;
		/**
		 * The text field used to display the text
		 */
		private var _field:FlxBitmapFont;
		
		/**
		 * Called when dialog is finished (optional)
		 */
		private var _finishCallback:Function;
		
		/**
		 * Stores all of the text to be displayed. Each "page" is a string in the array
		 */
		private var _dialogArray:Array;
		
		/**
		 * Background rect for the text
		 */
		private var _backgroundRect:FlxSprite;
		
		/** The index of the string in the array which is currently displayed */ 
		internal var _pageIndex:int;
		/** The index of the character in the string which is currently processed */
		internal var _charIndex:int;
		/** Flag to indicate whether displaying animation is enabled */
		internal var _displaying:Boolean;
		/** The speed of the display, indicates the interval between two consecutive characters */
		internal var _displaySpeed:Number;
		/** The elapsed time from the last character */
		internal var _elapsed:Number;
		/** Flag to indicate whether all the characters in the string has been displayed */
		internal var _endPage:Boolean;
		
		/**
		 * Default constructor
		 */
		public function FlxDialog()
		{
			this.scrollFactor.x = this.scrollFactor.y = 0;
			
			_backgroundRect = new FlxSprite(GameConstants.DIALOG_LOCATION.x, GameConstants.DIALOG_LOCATION.y)
				.createGraphic(GameConstants.DIALOG_SIZE.width, GameConstants.DIALOG_SIZE.height,
					GameConstants.DIALOG_BACKGROUND_COLOR);
			//_backgroundRect.scrollFactor.x = _backgroundRect.scrollFactor.y = 0;
			add(_backgroundRect);
			
			_speakerField = FlxBitmapFont.getDesignedFont(FlxBitmapFont.KROMASKY_16X16);
			_speakerField.x = GameConstants.DIALOG_SPEAKER_NAME_LOCATION.x;
			_speakerField.y = GameConstants.DIALOG_SPEAKER_NAME_LOCATION.y;
			_speakerField.width = GameConstants.DIALOG_SPEAKER_NAME_WIDTH;
			_speakerField.multiLine = true;
			//_speakerField.scrollFactor.x = _speakerField.scrollFactor.y = 0;
			add(_speakerField);
			
			_field = FlxBitmapFont.getDesignedFont(FlxBitmapFont.KROMAGRAD_16X16);
			_field.x = GameConstants.DIALOG_TEXT_LOCATION.x;
			_field.y = GameConstants.DIALOG_TEXT_LOCATION.y;
			_field.width = GameConstants.DIALOG_TEXT_WIDTH;
			_field.multiLine = true;
			//_field.scrollFactor.x = _field.scrollFactor.y = 0;
			add(_field);
			
			_elapsed = 0;			
			_displaySpeed = GameConstants.DIALOG_TEXT_SECONDS_PER_CHARACTER;
			_backgroundRect.alpha = 0;
		}
		
		/**
		 * Call this from your code to display some dialog
		 */
		public function showDialog(pages:Array):void
		{
			_pageIndex = 0;
			_charIndex = 0;
			_speakerField.text = pages[0][0];
			_field.text = (pages[0][1] as String).charAt(0);
			_dialogArray = pages;
			_displaying = true;
			_backgroundRect.alpha = 1;
			showing = true;
		}
		
		/**
		 * The meat of the class. Used to display text over time as well
		 * as control which page is 'active'
		 */
		override public function update():void
		{
			if(_displaying)
			{
				_elapsed += FlxG.elapsed;
				if(_elapsed > _displaySpeed)
				{
					_elapsed = 0;
					_charIndex++;
					if(_charIndex > (_dialogArray[_pageIndex][1] as String).length)
					{
						_endPage = true;
						_displaying = false;
					}
					_speakerField.text = _dialogArray[_pageIndex][0];
					_field.text = (_dialogArray[_pageIndex][1] as String).substr(0, _charIndex);
				}
			}
			
			if(FlxG.keys.justPressed(KeyboardConstants.A))
			{
				if(_displaying)
				{
					_displaying = false;
					_endPage = true;
					_field.text = _dialogArray[_pageIndex][1];
					_elapsed = 0;
					_charIndex = 0;
				}
				else if(_endPage)
				{
					if(_pageIndex == _dialogArray.length - 1)
					{
						// we're at the end of the pages
						_pageIndex = 0;
						_speakerField.text = "";
						_field.text = "";
						_backgroundRect.alpha = 0;
						if(_finishCallback != null)
							_finishCallback();
						showing = false;
					}
					else
					{
						_pageIndex++;
						_displaying = true;
					}
				}
			}
			
			super.update();
		}
		
		/**
		 * Called when the dialog is completely finished
		 */
		public function set finishCallback(val:Function):void
		{
			_finishCallback = val;
		}
		
	}
}