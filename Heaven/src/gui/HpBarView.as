package gui {
	import gui.characters.Character;
	import data.GameConstants;
	
	import org.flixel.FlxSprite;
	
	/**
	 * HpView class
	 * @author Ken
	 * 
	 * The hp bar on top of each character
	 */
	public class HpBarView extends GameAttachedGroup {
		
		/** The frame of the health bar */
		private var _healthFrame:FlxSprite;
		/** The health lost part */
		private var _healthLost:FlxSprite;
		/** The health bar */
		private var _healthBar:FlxSprite;
		
		/**
		 * Default constructor
		 * 
		 * @param	character
		 * 			is the character of whom hp is shown on this bar
		 */
		public function HpBarView(character:Character) {
			super(character);
			
			_healthFrame = new FlxSprite();
			_healthFrame.createGraphic(_sprite.frameWidth, GameConstants.ATTACHED_HEALTH_BAR_HEIGHT,
				GameConstants.ATTACHED_HEALTH_BAR_FRAME_COLOR);
			//healthFrame.scrollFactor.x = healthFrame.scrollFactor.y = 0;
			//_healthFrame.origin.x = _healthFrame.origin.y = 0;
			_healthFrame.solid = false;
			add(_healthFrame);
			
			_healthLost =
				new FlxSprite(GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
					GameConstants.ATTACHED_HEALTH_BAR_THICKNESS);
			_healthLost.createGraphic(_sprite.frameWidth - 2 * GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
				GameConstants.ATTACHED_HEALTH_BAR_HEIGHT - 2 * GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
				GameConstants.ATTACHED_HEALTH_BAR_LOST_COLOR);
			//healthLost.scrollFactor.x = healthLost.scrollFactor.y = 0;
			//_healthLost.origin.x = _healthLost.origin.y = 0;
			_healthLost.solid = false;
			add(_healthLost);
			
			_healthBar = 
				new FlxSprite(GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
					GameConstants.ATTACHED_HEALTH_BAR_THICKNESS);
			_healthBar.createGraphic(_sprite.frameWidth - 2 * GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
				GameConstants.ATTACHED_HEALTH_BAR_HEIGHT - 2 * GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
				GameConstants.ATTACHED_HEALTH_BAR_REMAINING_COLOR);
			//_healthBar.scrollFactor.x = _healthBar.scrollFactor.y = 0;
			_healthBar.origin.x = _healthBar.origin.y = 0;
			_healthBar.solid = false;	
			add(_healthBar);
		}
		
		/**
		 * Reset this hp bar
		 */
		public function resetHpBar():void {
			reset(0, 0);
			_healthFrame.createGraphic(_sprite.frameWidth, GameConstants.ATTACHED_HEALTH_BAR_HEIGHT,
				GameConstants.HEALTH_BAR_FRAME_COLOR);
			_healthLost.createGraphic(_sprite.frameWidth - 2 * GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
				GameConstants.ATTACHED_HEALTH_BAR_HEIGHT - 2 * GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
				GameConstants.HEALTH_BAR_LOST_COLOR);
			_healthBar.createGraphic(_sprite.frameWidth - 2 * GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
				GameConstants.ATTACHED_HEALTH_BAR_HEIGHT - 2 * GameConstants.ATTACHED_HEALTH_BAR_THICKNESS,
				GameConstants.HEALTH_BAR_REMAINING_COLOR);
			_healthBar.origin.x = _healthBar.origin.y = 0;
			_healthBar.scale.x = 1;
		}
		
		override public function reset(x:Number, y:Number):void {
			if (_healthFrame != null)	_healthFrame.reset(_healthFrame.x, _healthFrame.y);
			if (_healthLost != null)	_healthLost.reset(_healthLost.x, _healthLost.y);
			if (_healthBar != null)		_healthBar.reset(_healthBar.x, _healthBar.y);
			super.reset(x, y);
		}
		override public function update():void {
			updateHp();
			super.update();
		}
		
		/**
		 * Update the hp of the character
		 */
		private function updateHp():void {
			var character:Character = _sprite as Character;
			_healthBar.scale.x = character.model.stats.hp / character.model.stats.maxHp;
		}
	}
}