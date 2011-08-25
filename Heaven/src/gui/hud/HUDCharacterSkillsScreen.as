package gui.hud {
	import gui.characters.PlayableCharacter;
	import data.GameConstants;
	
	import models.skills.SkillModel;
	
	/**
	 * HUDCharacterSkillsScreen class
	 * @author Ken
	 * 
	 * Represent the HUD screen which display all the skills
	 * of the character, and player can choose to use/enable
	 * them
	 */
	public class HUDCharacterSkillsScreen extends HUDScreen {
		
		/** The character whose skills are being displayed */
		private var _character:PlayableCharacter;
		/** The confirmation screen when player selects a skill */
		private var _confirmScreen:HUDScreen;
		
		/**
		 * Default constructor
		 * 
		 * @param	character
		 * 			is the character whose skills will be displayed
		 * @param	callBack
		 * 			is the callback function when this screen is dismissed 
		 */
		public function HUDCharacterSkillsScreen(character:PlayableCharacter, callBack:Function) {
			super("Skills", "", callBack);
			
			_character = character;
			
			var x:Number = GameConstants.HUD_SKILLS_SCREEN_LOCATION.x;
			var y:Number = GameConstants.HUD_SKILLS_SCREEN_LOCATION.y;
			reset(x, y);
			width = GameConstants.HUD_SKILLS_SCREEN_SIZE.width;
			height = GameConstants.HUD_SKILLS_SCREEN_SIZE.height;
			if (width > 0 && height > 0)
				createBackgroundRectangle();
			
			//_itemsList; = new HUDScreenItemsList(0, 0, width, height, selectSkill);
			//_itemsList.active = false;
			_itemsList.width = width, _itemsList.height = height;
			_screen.remove(_itemsList);
			_screen.add(_itemsList, true);
			//_itemsList.selected();
			
			_confirmScreen = new HUDScreen("Nil", "", closeSubScreen, width/4, height/4, width/2, height/2);
//			_confirmScreen.reset(width/4, height/4);
//			_confirmScreen.width = width/2; _confirmScreen.height = height/2;
//			_confirmScreen.createBackgroundRectangle();
			_subScreen.add(_confirmScreen, true);
//			_confirmScreen.remove(_confirmScreen.itemsList, true);
//			_confirmScreen.itemsList.reset(0, 0);
//			_confirmScreen.itemsList.width = width/2;
//			_confirmScreen.itemsList.height = height/2;
//			_confirmScreen.itemsList.createBackgroundRectangle();
//			_confirmScreen.add(_confirmScreen.itemsList, true);
//			trace(_confirmScreen.x, _confirmScreen.itemsList.x);
			//_confirmScreen.itemsList.width = width/2;
			//_confirmScreen.itemsList.height = height/2;
			//_confirmItemsList.active = false;
			
			//_confirmScreen.itemsList.reset(0, 0);
			_confirmScreen.itemsList.reset(_confirmScreen.x, _confirmScreen.y);
			_confirmScreen.hideBackground();
			// Create blank item, so that no-recreatio is needed
			_confirmScreen.itemsList.addItem(new HUDScreenItem("Use", "", null, null));
			_confirmScreen.itemsList.addItem(new HUDScreenItem("Disable", "", null, null));
			_confirmScreen.itemsList.addItem(new HUDScreenItem("Shortcut", "", null, null));
			_confirmScreen.itemsList.addItem(new HUDScreenItem("Cancel", "", null, null));
			//_confirmScreen.itemsList.autoAlign();
		}
		
		override public function updateScreen(... optionalArgs):void {
				
			var currentItemsList:Vector.<HUDScreenItem> = _itemsList.itemsList;
			var characterSkills:Vector.<SkillModel> = _character.model.skillsModels;
			
			var i:int = 0;
			var skill:HUDScreenItem;
			var skillModel:SkillModel;
			while (i < Math.min(currentItemsList.length, characterSkills.length)) {
				skill = currentItemsList[i];
				skillModel = characterSkills[i++];
				skill.exists = true;
				skill.titleText.exists = true;
				skill.resetItem(skillModel.skillName, skillModel.description, skillModel, selectSkill);				
			}
			
			// Fade out those exceeds player's items
			while (i < currentItemsList.length) {
				currentItemsList[i].exists = false;
				currentItemsList[i++].titleText.exists = false;
			}
			
			// Add items if there was not enough space
			while (i < characterSkills.length) {
				skillModel = characterSkills[i++];
				skill = new HUDScreenItem(skillModel.skillName, skillModel.description, skillModel, selectSkill);
				_itemsList.addItem(skill);
			}
			
			super.updateScreen(false);
			//super.updateScreen.apply(this, optionalArgs);
			//			if (optionalArgs.length > 0) _itemsList.updateScreen(optionalArgs[0]);
			//			else	_itemsList.updateScreen();
		}
		
		/**
		 * Player has selected a certain skill
		 * 
		 * @param	skillModel
		 * 			is the model of the skill which is selected
		 */
		public function selectSkill(skillModel:SkillModel):void {
			var currentItemsList:Vector.<HUDScreenItem> = _confirmScreen.itemsList.itemsList;
			currentItemsList[0].resetItem("Use", "", skillModel, useSkill);
			currentItemsList[1].resetItem("Disable", "", skillModel, disableSkill);
			currentItemsList[2].resetItem("Shortcut", "", skillModel, shortcutSkill);
			currentItemsList[3].resetItem("Cancel", "", null, cancel);
			//trace(_confirmItemsList.canListenKeyboardEvents);
			//_confirmScreen.updateScreen();
			openSubScreen(_confirmScreen);
			//trace(_confirmItemsList.canListenKeyboardEvents);
//			_screen.active = false;
//			_subScreen.visible = true;
//			_subScreen.active = true;
//			_confirmItemsList.active = true;
//			if (_itemsList != null) _itemsList.active = false;
		}
		
		/**
		 * Use a certain skill
		 * 
		 * @param	skillModel
		 * 			is the model of the skill to use
		 */
		public function useSkill(skillModel:SkillModel):void {
			_character.useSkill(skillModel);
			cancel();
		}
		
		/**
		 * Disable a certain skill
		 * 
		 * * @param	skillModel
		 * 			is the model of the skill to disable
		 */
		public function disableSkill(skillModeL:SkillModel):void {
			_character.unuseSkill(skillModeL);
			cancel();
		}
		
		/**
		 * Bind a skill to the shortcut key
		 * 
		 * @param	skillModel
		 * 			is the model of the skill to bind
		 */
		public function shortcutSkill(skillModel:SkillModel):void {
			_character.bindShortcutSkill(skillModel);
			cancel();
		}
		
		/**
		 * Player cancels after selects a skill, return to the screen
		 */
		public function cancel():void {
			_confirmScreen.finished();
			closeSubScreen(_confirmScreen);
		}
		
	}
}