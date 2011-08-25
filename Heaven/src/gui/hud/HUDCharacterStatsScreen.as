package gui.hud {
	import data.GameConstants;
	
	import errors.IllegalArgumentException;
	
	import gui.characters.Character;
	
	import org.flixel.FlxBitmapFont;
	
	/**
	 * HUDCharacterStatsScreen
	 * @author Ken
	 * 
	 * The HUDScreen which displays the stats of the character
	 */
	public class HUDCharacterStatsScreen extends HUDScreen {
		
		/** The character whose stats are being displayed */
		private var _character:Character;
		/** The text which display the lvl of the character */
		private var _lvlText:FlxBitmapFont;
		/** The text which display the hp of the character */
		private var _hpText:FlxBitmapFont;
		/** The text which display the mp of the character */
		private var _mpText:FlxBitmapFont;
		/** The text which display the atk of the character */
		private var _atkText:FlxBitmapFont;
		/** The text which display the def of the character */
		private var _defText:FlxBitmapFont;
		/** The text which display the exp of the character */
		private var _expText:FlxBitmapFont;
		/** The text which display the exp to proceed to next lvl of the character */
		private var _expNextLvlText:FlxBitmapFont;
		
		/**
		 * Default constructor
		 * 
		 * @param	character
		 * 			is the character to display the stats
		 * @param	callBack
		 * 			is the call back function to call when this item is dismissed
		 * 
		 * @throws	IllegalArgumentException
		 * 			if the character given is null
		 */
		public function HUDCharacterStatsScreen(character:Character, callBack:Function) {
			super("Stats", "", callBack);
			if (character == null)
				throw new IllegalArgumentException("character", character);
				
			_character = character;
			var x:Number = GameConstants.HUD_CHARACTER_STATS_SCREEN_LOCATION.x;
			var y:Number = GameConstants.HUD_CHARACTER_STATS_SCREEN_LOCATION.y;
			reset(x, y);
			width = GameConstants.HUD_CHARACTER_STATS_SCREEN_SIZE.width;
			height = GameConstants.HUD_CHARACTER_STATS_SCREEN_SIZE.height;
			createBackgroundRectangle();
			
			init();
		}
		
		override public function resetScreen(...args):void {
			super.resetScreen();
			_character = args[0];
		}
		
		/**
		 * Initialize this screen
		 */
		private function init():void {
			
			var font:int = GameConstants.FONT;
			
			var x:Number = GameConstants.HUD_CHARACTER_STATS_SCREEN_TEXT_LOCATION.x;
			var y:Number = GameConstants.HUD_CHARACTER_STATS_SCREEN_TEXT_LOCATION.y;
//			var xDistance:Number = GameConstants.HUD_CHARACTER_STATS_SCREEN_TEXT_SPACING.x;
			var yDistance:Number = GameConstants.HUD_CHARACTER_STATS_SCREEN_TEXT_SPACING.y;
			
			// level
			_lvlText = FlxBitmapFont.getDesignedFont(font);
			_lvlText.reset(x, y);
			//_lvlText.scrollFactor.x = _lvlText.scrollFactor.y = 0;
			_screen.add(_lvlText, true); y += yDistance;
			
			
			// hp
			_hpText = FlxBitmapFont.getDesignedFont(font);
			_hpText.reset(x, y);
			//_hpText.scrollFactor.x = _hpText.scrollFactor.y = 0;
			_screen.add(_hpText, true); y += yDistance;
			
			// mp
			_mpText = FlxBitmapFont.getDesignedFont(font);
			_mpText.reset(x, y);
			//_mpText.scrollFactor.x = _mpText.scrollFactor.y = 0;
			_screen.add(_mpText, true); y += yDistance;
			
			// atk
			_atkText = FlxBitmapFont.getDesignedFont(font);
			_atkText.reset(x, y);
			//_atkText.scrollFactor.x = _atkText.scrollFactor.y = 0;
			_screen.add(_atkText, true); y += yDistance;
			
			// def
			_defText = FlxBitmapFont.getDesignedFont(font);
			_defText.reset(x, y);
			//_defText.scrollFactor.x = _defText.scrollFactor.y = 0;
			_screen.add(_defText, true); y += yDistance;
			
			// exp
			_expText = FlxBitmapFont.getDesignedFont(font);
			_expText.reset(x, y);
			//_expText.scrollFactor.x = _expText.scrollFactor.y = 0;
			_screen.add(_expText, true); y += yDistance;
			
			// next level exp
			_expNextLvlText = FlxBitmapFont.getDesignedFont(font);
			_expNextLvlText.reset(x, y);
			//_expNextLvlText.scrollFactor.x = _expNextLvlText.scrollFactor.y = 0;
			_screen.add(_expNextLvlText, true);
			
				
		}
		
		override public function selected():void {
			_screen.visible = true;
			updateScreen();
		}
		
		override public function updateScreen(... optionalArgs):void {
			super.updateScreen();
			_lvlText.text = 		
				"LEVEL     : " + Math.ceil(_character.model.stats.level);
			_hpText.text =
				"HP        : " + Math.ceil(_character.model.stats.hp) + "/" + Math.ceil(_character.model.stats.maxHp);
			_mpText.text = 			
				"MP        : " + Math.ceil(_character.model.stats.mp) + "/" + Math.ceil(_character.model.stats.maxMp);
			_atkText.text = 
				"ATK       : " + Math.ceil(_character.model.stats.atk);
			_defText.text = 
				"DEF       : " + Math.ceil(_character.model.stats.def);
			_expText.text =
				"EXP       : " + Math.ceil(_character.model.stats.exp);
			_expNextLvlText.text =
				"NEXT LEVEL: " + Math.ceil(_character.model.stats.nextLevelExp);
			
		}
	}
}