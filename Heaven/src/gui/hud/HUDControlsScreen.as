package gui.hud {
	import data.GameConstants;
	import data.KeyboardConstants;
	
	import org.flixel.FlxBitmapFont;
	import org.flixel.FlxPoint;
	import org.flixel.data.FlxSize;
	
	/**
	 * HUDControlScreen class
	 * 
	 * The HUD Screen which displays the controls of the game
	 * 
	 * @author Ken
	 */
	public class HUDControlsScreen extends HUDScreen {
		
		/** The text which displays the up direction key */
		private var _upKeyText:FlxBitmapFont;
		/** The text which displays the down direction key */
		private var _downKeyText:FlxBitmapFont;
		/** The text which displays the left direction key */
		private var _leftKeyText:FlxBitmapFont;
		/** The text which displays the right direction key */
		private var _rightKeyText:FlxBitmapFont;
		/** The text which displays the menu key */
		private var _menuKeyText:FlxBitmapFont;
		/** The text which displays the help key */
//		private var _helpKeyText:FlxBitmapFont;
		/** The text which displays the confirm/attack key */
		private var _attackConfirmKeyText:FlxBitmapFont;
		/** The text which displays the jump/cancel key */
		private var _jumpCancelKeyText:FlxBitmapFont;
//		/** The text which displays the skill-shortcut key */
//		private var _skillShortcutKeyText:FlxBitmapFont;
//		/** The text which displays the item-shortcut key */
//		private var _itemShortcutKeyText:FlxBitmapFont;
//		/** The text which displays the L key */
//		private var _LKeyText:FlxBitmapFont;
//		/** The text which displays the R key */
//		private var _RKeyText:FlxBitmapFont;
		
		/**
		 * Default constructor
		 * 
		 * @param	callBack
		 * 			is the callBack function when this screen is closed
		 */
		public function HUDControlsScreen(callBack:Function){
			super("Controls", "", callBack);
			
			var location:FlxPoint = GameConstants.HUD_CONTROLS_SCREEN_LOCATION;
			reset(location.x, location.y);
			var size:FlxSize = GameConstants.HUD_CONTROLS_SCREEN_SIZE;
			width = size.width; height = size.height;
			createBackgroundRectangle();
			
			init();
		}
		
		/**
		 * Initialize this screen
		 */
		private function init():void {
			
			var x:Number = GameConstants.HUD_CONTROLS_SCREEN_TEXT_LOCATION.x;
			var y:Number = GameConstants.HUD_CONTROLS_SCREEN_TEXT_LOCATION.y;
//			var xDistance:Number = GameConstants.HUD_CONTROLS_SCREEN_TEXT_SPACING.x;
			var yDistance:Number = GameConstants.HUD_CONTROLS_SCREEN_TEXT_SPACING.y;
			
			var font:int = GameConstants.FONT;
			
			// up key
			_upKeyText = FlxBitmapFont.getDesignedFont(font);
			_upKeyText.reset(x, y);
			_screen.add(_upKeyText, true); y += yDistance;
			
			// down key
			_downKeyText = FlxBitmapFont.getDesignedFont(font);
			_downKeyText.reset(x, y);
			_screen.add(_downKeyText, true); y += yDistance;
			
			// left key
			_leftKeyText = FlxBitmapFont.getDesignedFont(font);
			_leftKeyText.reset(x, y);
			_screen.add(_leftKeyText, true); y += yDistance;
			
			// right key
			_rightKeyText = FlxBitmapFont.getDesignedFont(font);
			_rightKeyText.reset(x, y);
			_screen.add(_rightKeyText, true); y += yDistance;
			
			// menu key
			_menuKeyText = FlxBitmapFont.getDesignedFont(font);
			_menuKeyText.reset(x, y);
			_screen.add(_menuKeyText, true); y += yDistance;
			
//			// help key
//			_helpKeyText = FlxBitmapFont.getDesignedFont(font);
//			_helpKeyText.reset(x, y);
//			_screen.add(_helpKeyText, true); y += yDistance;
			
			// attack/confirm key
			_attackConfirmKeyText = FlxBitmapFont.getDesignedFont(font);
			_attackConfirmKeyText.reset(x, y);
			_screen.add(_attackConfirmKeyText, true); y += yDistance;
			
			// jump/cancel key
			_jumpCancelKeyText = FlxBitmapFont.getDesignedFont(font);
			_jumpCancelKeyText.reset(x, y);
			_screen.add(_jumpCancelKeyText, true); y += yDistance;
			
//			// skill shortcut key
//			_skillShortcutKeyText = FlxBitmapFont.getDesignedFont(font);
//			_jumpCancelKeyText.reset(x, y);
//			_screen.add(_skillShortcutKeyText, true); y += yDistance;
//
//			// item shortcut key
//			_itemShortcutKeyText = FlxBitmapFont.getDesignedFont(font);
//			_jumpCancelKeyText.reset(x, y);
//			_screen.add(_itemShortcutKeyText, true); y += yDistance;
//			
//			// L key
//			_LKeyText = FlxBitmapFont.getDesignedFont(font);
//			_jumpCancelKeyText.reset(x, y);
//			_screen.add(_LKeyText, true); y += yDistance;
//			
//			// R key
//			_RKeyText = FlxBitmapFont.getDesignedFont(font);
//			_jumpCancelKeyText.reset(x, y);
//			_screen.add(_RKeyText, true); y += yDistance;			
		}
		
		override public function updateScreen(...optionalArgs):void {
			super.updateScreen();
			
			_upKeyText.text =				"UP             : " + KeyboardConstants.UP;
			_downKeyText.text = 			"DOWN           : " + KeyboardConstants.DOWN;
			_leftKeyText.text = 			"LEFT           : " + KeyboardConstants.LEFT;
			_rightKeyText.text = 			"RIGHT          : " + KeyboardConstants.RIGHT;
			_menuKeyText.text =				"OPEN MENU      : " + KeyboardConstants.START;
//			_helpKeyText.text =				"HELP           : " + KeyboardConstants.SELECT;
			_attackConfirmKeyText.text =	"ATTACK/CONFIRM : " + KeyboardConstants.A;
			_jumpCancelKeyText.text = 		"JUMP/CANCEL    : " + KeyboardConstants.B;
//			_skillShortcutKeyText.text =	"SKILL SHORTCUT : " + KeyboardConstants.X;
//			_itemShortcutKeyText.text =		"ITEM SHORTCUT  : " + KeyboardConstants.Y;
		}
	}
}