package gui.states {
	import gui.characters.Character;
	import gui.items.Item;
	import gui.characters.PlayableCharacter;
	import gui.Door;
	import gui.characters.NonPlayableCharacter;
	import gui.FlxDialog;
	import gui.GameSprite;
	import gui.skills.Skill;
	import gui.SaveLoadManager;
	import gui.KeyboardEventsManager;
	import gui.characters.NonPlayableCharacterFactory;
	import gui.items.ItemFactory;
	import gui.GameGroup;
	
	import data.KeyboardConstants;
	import org.flixel.FlxGroup;
	import data.GameConstants;
	import data.GameDebugModeConstants;
	import data.GameFormula;
	import data.ImagesBitmapConstants;
	import data.MapsDesigns;
	import data.UnitsConstants;
	
	import embeded.EmbededImages;
	
	import enums.Action;
	
	import errors.NonStaticCallSingletonPattern;
	import errors.SingletonPatternViolatedError;
	
	import gui.hud.HUDMenuScreen;
	
	import org.flixel.FlxG;
	import org.flixel.FlxHitTest;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import org.flixel.data.FlxSize;
	import org.flixelPP.FlxUPP;
	
	/**
	 * PlayState
	 * 
	 * takes place when the game is currently playing
	 */
	public class PlayState extends FlxState {
		// Singleton pattern
		static private var instance:PlayState;
		static private var staticCall:Boolean = false;
		static private var canCreateNew:Boolean = true;
		
		/** Get the only instance of this class */
		static public function getInstance():PlayState {
			if ( instance == null ) {
				staticCall = true;
				instance = new PlayState();
				staticCall = false;
			}
			return instance;
		}
		
		/**
		 * Default constructor
		 * 
		 * Singleton pattern, will throw error if not called
		 * by the static function
		 */
		public function PlayState() {			
			super();
			
			if ( ! staticCall )
				throw new NonStaticCallSingletonPattern( "PlayState" );
			if ( ! canCreateNew )
				throw new SingletonPatternViolatedError( "PlayState" );
			
			canCreateNew = false;
			instance = this;
			
			_keyboardEventsManager = KeyboardEventsManager.getInstance();
			_characters = new Vector.<Character>();
			
			_playScreen = new GameGroup();
			add(_playScreen);
			_tileMap = new FlxTilemap();
			_playScreen.add( _tileMap );	
			_npcMap = new GameGroup();
			_playScreen.add( _npcMap );
			_itemMap = new GameGroup();
			_playScreen.add( _itemMap );
			_nonTileMap = new GameGroup();
			_specialMap = new GameGroup();
			_playScreen.add(_specialMap);
			_skills = new FlxGroup();
			_playScreen.add(_skills);
			
			_player = PlayableCharacter.initializeInstance(_skills);
			//_player = PlayableCharacter.getInstance();
			_nonTileMap.add( _player );
			_nonTileMap.add( _npcMap );
			_nonTileMap.add( _itemMap );
			
			_characterMap = new GameGroup();
			_characterMap.add(_npcMap);
			_characterMap.add(_player);
			
			// Dialog
			_dialog = new FlxDialog();
			//add(_dialog);
			
			constructHealthAndMpBar();		
			
			// HUDScreen
			_HUDMenuScreen = new HUDMenuScreen(closeHUDMenuScreen);
			add(_HUDMenuScreen);
			
		}
		
		/** Current id of the map */
		private var _mapId:uint;
		public function get mapId():uint { return _mapId; }
		/** The tile map */
		private var _tileMap:FlxTilemap;
		/** All the moving objects, i.e. non-tile map */
		private var _nonTileMap:GameGroup;
		/** The group which contains all the npc */
		private var _npcMap:GameGroup;
		/** The group which contains all the character */
		private var _characterMap:GameGroup;
		/** The group which contains all the items */
		private var _itemMap:GameGroup;
		/** The group which contains all the specials */
		private var _specialMap:GameGroup;
		/** The current player of the game */
		private var _player:PlayableCharacter;
		public function get player():PlayableCharacter { return _player; }
		/** Reference to the keyboardEventsManager */
		private var _keyboardEventsManager:KeyboardEventsManager;
		/** List of all the characters on the map */
		private var _characters:Vector.<Character>;
		/** List of all the skills which is currently on the screen */
		private var _skills:FlxGroup;
		/** The dialog on the map, if any */
		private var _dialog:FlxDialog;
		/** The health bar of the player */
		private var _healthBar:FlxSprite;
		/** The mp bar of the player */
		private var _mpBar:FlxSprite;
		/** Current position of the player */
		private var _playerRect:FlxRect;
		public function get playerRect():FlxRect { return _playerRect; }
		/** Offset of the player, converted to the world's coordinate */
		private var _playerOffset:FlxRect;
		public function get playerOffset():FlxRect { return _playerOffset; }
		/** The play screen, which contains tiles, characters, items,... */
		private var _playScreen:GameGroup;
		/** The HUD Menu screen, triggered when player presses START */
		private var _HUDMenuScreen:HUDMenuScreen;
		/** The door of the previous map which leads to current map */
		private var _previousDoor:Door;
		
		/**
		 * Create/Construct the game
		 */
		override public function create():void {
			
			// If the player is loading a save
			if (SaveLoadManager.isLoading)
				_mapId = SaveLoadManager.mapId;
			
			// If changing map
			else if (_previousDoor != null)
				_mapId = _previousDoor.desMapId;
			else _mapId = 0;			
			
			loadMap();
		}
		
		/**
		 * Reset everything, (to change map)/reset game
		 */
		private function resetState():void {			
			FlxG.unfollow();			
			_tileMap.kill();
			_tileMap.reset(0, 0);
			_npcMap.kill();
			_npcMap.reset(0, 0);
			_itemMap.kill();
			_itemMap.reset(0, 0);
			_specialMap.kill();
			_specialMap.reset(0, 0);
			_player.softReset();
			//_skills.kill();
			//_skills.reset(0, 0);
			_characters.splice(0, _characters.length);
			_HUDMenuScreen.finished();
			_playScreen.active = true;
		}
		
		/**
		 * Construct health and mp bar
		 */
		private function constructHealthAndMpBar():void {
			// Health bar
			var healthFrame:FlxSprite = 
				new FlxSprite(GameConstants.HEALTH_BAR_LOCATION.x,GameConstants.HEALTH_BAR_LOCATION.y);
			healthFrame.createGraphic(GameConstants.HEALTH_BAR_SIZE.width,
				GameConstants.HEALTH_BAR_SIZE.height, GameConstants.HEALTH_BAR_FRAME_COLOR);
			healthFrame.scrollFactor.x = healthFrame.scrollFactor.y = 0;
			_playScreen.add(healthFrame);
			
			var healthLost:FlxSprite = 
				new FlxSprite(GameConstants.HEALTH_BAR_LOCATION.x + 1,GameConstants.HEALTH_BAR_LOCATION.y + 1);
			healthLost.createGraphic(GameConstants.HEALTH_BAR_SIZE.width - 2,
				GameConstants.HEALTH_BAR_SIZE.height - 2, GameConstants.HEALTH_BAR_LOST_COLOR);
			healthLost.scrollFactor.x = healthLost.scrollFactor.y = 0;
			_playScreen.add(healthLost);
			
			_healthBar = 
				new FlxSprite(GameConstants.HEALTH_BAR_LOCATION.x + 1,
					GameConstants.HEALTH_BAR_LOCATION.y + 1);
			_healthBar.createGraphic(GameConstants.HEALTH_BAR_SIZE.width - 2,
				GameConstants.HEALTH_BAR_SIZE.height - 2, GameConstants.HEALTH_BAR_REMAINING_COLOR);
			_healthBar.scrollFactor.x = _healthBar.scrollFactor.y = 0;
			_healthBar.origin.x = _healthBar.origin.y = 0;
			_playScreen.add(_healthBar);
			
			// MP bar
			var mpFrame:FlxSprite = 
				new FlxSprite(GameConstants.MP_BAR_LOCATION.x,GameConstants.MP_BAR_LOCATION.y);
			mpFrame.createGraphic(GameConstants.MP_BAR_SIZE.width,
				GameConstants.MP_BAR_SIZE.height, GameConstants.MP_BAR_FRAME_COLOR);
			mpFrame.scrollFactor.x = mpFrame.scrollFactor.y = 0;
			_playScreen.add(mpFrame);
			
			var mpLost:FlxSprite = 
				new FlxSprite(GameConstants.MP_BAR_LOCATION.x + 1,GameConstants.MP_BAR_LOCATION.y + 1);
			mpLost.createGraphic(GameConstants.MP_BAR_SIZE.width - 2,
				GameConstants.MP_BAR_SIZE.height - 2, GameConstants.MP_BAR_LOST_COLOR);
			mpLost.scrollFactor.x = mpLost.scrollFactor.y = 0;
			_playScreen.add(mpLost);
			
			_mpBar = 
				new FlxSprite(GameConstants.MP_BAR_LOCATION.x + 1,
					GameConstants.MP_BAR_LOCATION.y + 1);
			_mpBar.createGraphic(GameConstants.MP_BAR_SIZE.width - 2,
				GameConstants.MP_BAR_SIZE.height - 2, GameConstants.MP_BAR_REMAINING_COLOR);
			_mpBar.scrollFactor.x = _mpBar.scrollFactor.y = 0;
			_mpBar.origin.x = _mpBar.origin.y = 0;
			_playScreen.add(_mpBar);
		}
		
		/**
		 * Load the map
		 */
		public function loadMap():void {
			resetState();
			
			var txtMap:Vector.<String> = MapsDesigns.getMap( _mapId );
			var txtTileMap:String = txtMap[ 0 ];
			constructTileMap( txtTileMap );
			
			var txtCharacterMap:String = txtMap[ 1 ];
			constructCharacterMap( txtCharacterMap, txtTileMap );
			
			var txtItemMap:String = txtMap[ 2 ];
			constructItemMap(txtItemMap);
			
			var mapSpecials:XML = MapsDesigns.getMapSpecials(_mapId);
			var map:Array = txtTileMap.split("\n");
			var cols:int = (map[0] as String).split(",").length;
			var rows:int = map.length;
			// If the last rows is just a blank row due to error
			if ((map[map.length - 1] as String).split(",").length < cols)
				rows--;
			constructMapSpecials(rows, cols, mapSpecials);
			
			//_HUDMenuScreen.resetScreen();
			
			// If the player is loading a save
			if (SaveLoadManager.isLoading) {
				_player.model.constructFromSaveObject(SaveLoadManager.playerModel);
				var playerLocation:FlxPoint = SaveLoadManager.playerLocation;
				_player.x = playerLocation.x; _player.y = playerLocation.y;
				// reset the save load state
				SaveLoadManager.reset();
			}
			
			// Add player to the screen
			_playScreen.add( _player );
			_characters.push(_player);
			//_characterMap.add(_player);
			
			// Reset the door
			_previousDoor = null;
			
			// make the camera follow the player
			FlxG.follow( _player );			
			FlxG.forceFollow();
			
			FlxG.stream(GameConstants.BACKGROUND_MUSIC_URL);
			//FlxG.play(EmbededMusic.BackgroundMusic, 1.0, true);
		}
		
		/**
		 * Contruct the tile map from the designed string
		 * 
		 * @param	txtTileMap
		 * 			is the tile map in text format
		 */
		private function constructTileMap( txtTileMap:String ):void {
			if ( GameConstants.EMBEDED_ALL )
				_tileMap.loadMap( 
					txtTileMap, EmbededImages.TilesImages,
					GameConstants.TILE_WIDTH, GameConstants.TILE_HEIGHT );
			else
				_tileMap.loadMapBitmapData(
					txtTileMap, ImagesBitmapConstants.TILES_IMAGES,
					GameConstants.TILE_WIDTH, GameConstants.TILE_HEIGHT );
			
			// make the camera follow the boundary of the tileMap		
			_tileMap.follow();
		}
		
		/**
		 * Contruct the characters from the designed map
		 * 
		 * @param	txtCharacterMap
		 * 			is the map (only characters) in text format
		 * @param	txtTileMap
		 * 			is the tile map in text format
		 */
		private function constructCharacterMap( txtCharacterMap:String, txtTileMap:String ):void {
			var tileMapArray:Array = new Array();
			for each ( var rowString:String in txtTileMap.split( "\n" ) ) {
				tileMapArray.push( rowString.split( "," ) );
			}
			
			var recyclableId:int = 0;
			var rows:Array = txtCharacterMap.split( "\n" );
			for ( var rowIndex:int = 0; rowIndex < rows.length; rowIndex++ ) {
				var row:Array = (rows[ rowIndex ] as String).split( "," );
				for ( var colIndex:int = 0; colIndex < row.length; colIndex++ ) {
					var unit:String = row[ colIndex ];					
					var unitCode:Number = Number( unit );
					
					// If the unit is blank, then we need to do nothing
					if (unitCode == UnitsConstants.BLANK)
						continue;
						
					// Is the unit player?
					if ( unitCode == UnitsConstants.PLAYER ) {
						// Yes
						// Only load player if this is not changing map or loading from save
						if ((! SaveLoadManager.isLoading) && _previousDoor == null) {
							//_player = Player.getInstance();
							_player.x = colIndex * GameConstants.TILE_WIDTH;
							_player.y = rowIndex * GameConstants.TILE_HEIGHT;
						}
						
					} else {
						// No
						// Get the latest npc which can be recycled
						while (_npcMap.members[recyclableId] != null &&
							   ((_npcMap.members[recyclableId] as FlxObject).exists ||
							   (! (_npcMap.members[recyclableId] is NonPlayableCharacter))))
								recyclableId++;
						var npc:NonPlayableCharacter = 
							NonPlayableCharacterFactory.createNonPlayableCharacterByCharacterCode(
								unitCode, colIndex, rowIndex, tileMapArray, _skills,
								_npcMap.members[recyclableId] );
						npc.x = colIndex * GameConstants.TILE_WIDTH;
						npc.y = ( rowIndex + 1 ) * GameConstants.TILE_HEIGHT - npc.height;
						_npcMap.add( npc );
						_characters.push(npc);
					}
				}
			}
		}

		/**
		 * Contruct the items from the designed map
		 * 
		 * @param	txtItemMap
		 * 			is the map (only items) in text format
		 */
		private function constructItemMap( txtItemMap:String ):void {
			
			var rows:Array = txtItemMap.split( "\n" );
			var recyclableId:int = 0;
			for ( var rowIndex:int = 0; rowIndex < rows.length; rowIndex++ ) {
				var row:Array = (rows[ rowIndex ] as String).split( "," );
				for ( var colIndex:int = 0; colIndex < row.length; colIndex++ ) {
					var itemString:String = row[ colIndex ];
					var itemCode:Number = Number( itemString );
					
					// If the item is blank, then we need to do nothing
					if ( itemCode == UnitsConstants.BLANK )
						continue;
					
					// Get the latest item which can be recycled
					while (_itemMap.members[recyclableId] != null &&
						   ((_itemMap.members[recyclableId] as FlxObject).exists))
						   recyclableId++;
					
					var item:Item = ItemFactory.createItemByItemCode(itemCode, _itemMap.members[recyclableId]);
					item.x = colIndex * GameConstants.TILE_WIDTH;
					item.y = ( rowIndex + 1 ) * GameConstants.TILE_HEIGHT - item.height;
					_itemMap.add( item );
				}
			}
		}
		
		/**
		 * Construct the specials part of the map
		 * 
		 * @param	rows
		 * 			is the number of rows of the current map
		 * @param	cols
		 * 			is the number of cols of the current map
		 * @param	mapSpecials
		 * 			is the specials parts of the map in xml format
		 */
		private function constructMapSpecials(rows:int, cols:int, mapSpecials:XML):void {
			// Construct all the doors
			var doors:XMLList = mapSpecials.doors;
			var tileSize:FlxSize = new FlxSize(GameConstants.TILE_WIDTH, GameConstants.TILE_HEIGHT);
			for each (var doorXml:XML in doors.children()) {
				var door:Door = new Door(Number(doorXml.id.text()),
									     Number(doorXml.destinationDoorId.text()),
										 Number(doorXml.destinationMapId.text()));
				
				var doorWidth:Number = Number(doorXml.size.width.text());
				var doorHeight:Number = Number(doorXml.size.height.text());
				door.width = doorWidth * tileSize.width;
				door.height = doorHeight * tileSize.height;
				var doorRow:Number = Number(doorXml.coordinate.row.text());
				var doorCol:Number = Number(doorXml.coordinate.col.text());
				door.x = doorCol * tileSize.width;
				door.y = doorRow * tileSize.height;
				
				// Show doors if debug mode is enabled and doors are set to be shown
				if (GameDebugModeConstants.DEBUG_MODE_ENABLED && GameDebugModeConstants.SHOW_DOORS) {
					door.createGraphic(door.width, door.height); door.visible = true;
				}
				
				_specialMap.add(door);
				
				// If player is changing the map, and this is the destination door
				if (_previousDoor != null && _previousDoor.desDoorId == door.id) {
					// Place the player right next to the door
					var x:Number = 0, y:Number = 0, playerDoorDist:Number = GameConstants.PLAYER_DOOR_DISTANCE;
					// If the door is to the left of the map
					if ((Math.floor(doorCol) as int) == 0) {
						x = (doorCol + doorWidth + playerDoorDist) * tileSize.width;
						y = door.y + _player.y - _previousDoor.y;
						//y = (doorRow + doorHeight ) * tileSize.height - _player.height;
						
					// If the door is to the right of the map
					} else if ((Math.floor(doorCol) as int) == cols - 1) {
						x = (doorCol - playerDoorDist) * tileSize.width - _player.width;
						y = door.y + _player.y - _previousDoor.y;
						//y = (doorRow + doorHeight ) * tileSize.height - _player.height;
						
					// If the door is on the top of the map
					} else if ((Math.floor(doorRow) as int) == 0) {
						//x = doorCol * tileSize.width;
						x = door.x + _player.x - _previousDoor.x;
						y = (doorRow + doorHeight + playerDoorDist ) * tileSize.height;
						
					// If the door is on the bottom of the map
					} else if ((Math.floor(doorRow) as int) == rows - 1) {
						//x = doorCol * tileSize.width;
						x = door.x + _player.x - _previousDoor.x;
						y = (doorRow - playerDoorDist ) * tileSize.height - _player.height;
						
					// Undefined case
					} else {
						trace("Undefined door position");
					}
					
					_player.x = x; _player.y = y;
				}
			}
		}
		
		/**
		 * Update the animation every frame
		 */
		override public function update():void {
			
			_keyboardEventsManager.update();
			
			// If player reach a door, then change the map
			if (_previousDoor != null) {
				// We have to collide player with the tile map so that the player
				// is properly on the floor
				FlxU.collide(_player, _tileMap);
				FlxG.state = this;
				//create();
				return;
			}
			
			// If the game is already over, player dies
			//if (_player.dead) {
				//gameLost();
			//}
			// If player is currently playing the game (not opening menu)
			if (_playScreen.active) {
				// Did player just press button to open the menu
				if (_keyboardEventsManager.justPressed(KeyboardConstants.START)) {
					// Yes
					openHUDMenuScreen();
					return;
				} else {
					// No
					// Update the position of the player
					_playerRect = new FlxRect(_player.x - _player.offset.x,
											  _player.y - _player.offset.y,
											  _player.frameWidth,
											  _player.frameHeight);
					_playerOffset = new FlxRect(_player.x,
												_player.y,
												_player.width, _player.height);
						
					// Overlap for attack detection
					// Is perfect overlapping enabled?
					if (GameConstants.PERFECT_PIXEL_OVERLAP) {
						// Yes
						FlxHitTest.overlap(_player, _npcMap, checkAttack);
						//FlxUPP.overlapPP(_player, _characterMap, checkAttack);
						FlxHitTest.overlap(_skills, _characterMap, checkSkillAttack);
						//FlxU.overlap(_skills, _characterMap, checkSkillAttack);
					} else {
						// Update all the offsets so that they reflect attaking offset 
						for each (var updateOffsetCharacter:Character in _characters)
							updateOffsetCharacter.updatePositionAndSize();
						FlxU.overlap(_player, _npcMap, checkAttack);
						
						// Reset back
						for each (var resetOffsetCharacter:Character in _characters)
							resetOffsetCharacter.resetPositionAndSize();
						
						// Update all the offsets so that they reflect attaking offset 
						for each (var updateOffsetSskill:Skill in _skills.members)
							if (updateOffsetSskill.exists)
								updateOffsetSskill.updatePositionAndSize();
						FlxU.overlap(_skills, _characterMap, checkSkillAttack);
						
						// Reset back
						for each (var resetOffsetSskill:Skill in _skills.members)
							if (resetOffsetSskill.exists)
								resetOffsetSskill.resetPositionAndSize();
					}
					
									
					// Collide
					FlxU.collide( _nonTileMap, _tileMap );
					FlxU.collide( _player, _npcMap );
					
					// Overlap player and item map to check whether player is picking up any item
					FlxU.overlap(_player, _itemMap, pickUpItem);
					// Overlap player and specials map
					FlxU.overlap(_player, _specialMap, specialEvent);
					// Destroy any sprite which collides with the tile
//					FlxU.overlap(_skills, _tileMap, destroySkill);
//					// WARNING: very expensive, must change later
//					for each (var skill:Skill in _skills)
//						if (skill.exists && _tileMap.overlaps(skill))
//							destroySkill(skill);
					FlxU.collide(_skills, _tileMap);
				}
			}
					
			// Update the health and mp bar
			_healthBar.scale.x = _player.model.stats.hp / _player.model.stats.maxHp;
			_mpBar.scale.x = _player.model.stats.mp / _player.model.stats.maxMp;
			super.update();
			
		}
		
		/**
		 * Checking two overlap object to see whether
		 * they are attacking each other
		 * 
		 * @param	obj1
		 * 			is the first object in the overlapping
		 * @param	obj2
		 * 			is the second object in the overlapping
		 */
		private function checkAttack(obj1:FlxObject, obj2:FlxObject):void {
			if (obj1 is Character && obj2 is Character) {
				var char1:Character = obj1 as Character;
				var char2:Character = obj2 as Character;
				
				// Resize to reflect the true bounds
				char1.resetPositionAndSize();
				char2.resetPositionAndSize();
				
				// If any of the characters are blinking
//				if (char1.isBlinking || char2.isBlinking)
//					// Then attack is not valid
//					return;
				
				// If both characters are attacking
				if (char1.action == Action.ATTACKING && char2.action == Action.ATTACKING) {
					
					// If both characters are facing the same direction
					// then only one character can attack
					
					// If both characters are facing left
					if (char1.facing == FlxSprite.LEFT && char2.facing == FlxSprite.LEFT) {
						// then whoever is to the right is the attacker
						// Is char 1 to the right?
						if (char1.right > char2.right) {
							// Yes
//							// Resize to reflect the true bounds
//							char1.resetPositionAndSize();
//							char2.resetPositionAndSize();
							// Attack is valid only when the sprite of attacking character
							// overlaps the rectangle bound of the attacked character
							if (FlxHitTest.overlapFlxSpritePixelsVSBound(char1, char2))
								attack(char1, char2);
//							// Resize back for next overlap detection
//							char1.updatePositionAndSize();
//							char2.updatePositionAndSize();
						} else {
							// No
//							// Resize to reflect the true bounds
//							char1.resetPositionAndSize();
//							char2.resetPositionAndSize();
							// Attack is valid only when the sprite of attacking character
							// overlaps the rectangle bound of the attacked character
							if (FlxHitTest.overlapFlxSpritePixelsVSBound(char2, char1))
								attack(char2, char1);
//							// Resize back for next overlap detection
//							char1.updatePositionAndSize();
//							char2.updatePositionAndSize();
						}
					
					// If both characters are facing right
					} else if (char1.facing == FlxSprite.RIGHT && char2.facing == FlxSprite.RIGHT) {
						// then whoever is to the left is the attacker
						// Is char 1 to the left?
						if (char1.left < char2.left) {
							// Yes
//							// Resize to reflect the true bounds
//							char1.resetPositionAndSize();
//							char2.resetPositionAndSize();
							// Attack is valid only when the sprite of attacking character
							// overlaps the rectangle bound of the attacked character
							if (FlxHitTest.overlapFlxSpritePixelsVSBound(char1, char2))
								attack(char1, char2);
//							// Resize back for next overlap detection
//							char1.updatePositionAndSize();
//							char2.updatePositionAndSize();
						} else {
							// No
//							// Resize to reflect the true bounds
//							char1.resetPositionAndSize();
//							char2.resetPositionAndSize();
							// Attack is valid only when the sprite of attacking character
							// overlaps the rectangle bound of the attacked character
							if (FlxHitTest.overlapFlxSpritePixelsVSBound(char2, char1))
								attack(char2, char1);
//							// Resize back for next overlap detection
//							char1.updatePositionAndSize();
//							char2.updatePositionAndSize();
						}
						
					// Both characters are facing each other
					} else {
						// Both images will now contains two factors: the character image, and the
						// weapon image
						// often, the character image is defined by the offset
						// Thus, if first character is attacking, but the first chracter's imag
						// does not overlap with second character's offset bound, then the attack is void
						// i.e. not valid; and vice versa.
//						// Resize to reflect the true bounds
//						char1.resetPositionAndSize();
//						char2.resetPositionAndSize();
						// Attack is valid only when the sprite of attacking character
						// overlaps the rectangle bound of the attacked character
						if (FlxHitTest.overlapFlxSpritePixelsVSBound(char1, char2))
							attack(char1, char2);
						if (FlxHitTest.overlapFlxSpritePixelsVSBound(char2, char1))
							attack(char2, char1);
//						// Resize back for next overlap detection
//						char1.updatePositionAndSize();		
//						char2.updatePositionAndSize();
					}
					
				// If first character is attacking
				} else if (char1.action == Action.ATTACKING) {
					// If first character is attacking left and second character is to the
					// left of first character
					if ((char1.facing == FlxSprite.LEFT && (char2.left < char1.left)) ||
						// If first character is attacking right and second character is to the
						// right of first character
						(char1.facing == FlxSprite.RIGHT && (char2.right > char1.right))) {
//							// Resize to reflect the true bounds
//							char1.resetPositionAndSize();
//							char2.resetPositionAndSize();
							// Attack is valid only when the sprite of attacking character
							// overlaps the rectangle bound of the attacked character
							if (FlxHitTest.overlapFlxSpritePixelsVSBound(char1, char2))
								attack(char1, char2);
//							// Resize back for next overlap detection
//							char1.updatePositionAndSize();		
//							char2.updatePositionAndSize();
					}
				
				// If second character is attacking
				} else if (char2.action == Action.ATTACKING) {
					// If second character is attacking left and first character is to the
					// left of second character
					if ((char2.facing == FlxSprite.LEFT && (char1.left < char2.left)) ||
						// If second character is attacking left and first character is to the
						// left of second character
						(char2.facing == FlxSprite.RIGHT && (char1.right > char2.right))) {
//							// Resize to reflect the true bounds
//							char1.resetPositionAndSize();
//							char2.resetPositionAndSize();
							// Attack is valid only when the sprite of attacking character
							// overlaps the rectangle bound of the attacked character
							if (FlxHitTest.overlapFlxSpritePixelsVSBound(char2, char1))
								attack(char2, char1);
//							// Resize back for next overlap detection
//							char1.updatePositionAndSize();
//							char2.updatePositionAndSize();
						}
				}
			}
			// Resize back for next overlap detection
			char1.updatePositionAndSize();
			char2.updatePositionAndSize();
		}
		
		/**
		 * Make the attacking between two character
		 * 
		 * @param	attackingCharacter
		 * 			is the character performing the attack
		 * @param	attackedCharacter
		 * 			is the character receiving the attack
		 */
		private function attack(attackingCharacter:Character, attackedCharacter:Character):void {
			var damage:Number =
				GameFormula.getNormalAttackDamage(attackingCharacter.model,
												  attackedCharacter.model);
			attackedCharacter.attacked(damage);
			
			// Gain exp if the attacked character is dead
			if (! attackedCharacter.model.isAlive)
				attackingCharacter.model.gainExp(attackedCharacter.model.stats.exp);
		}
		
		/**
		 * Checking overlapping to see whether player is picking up
		 * an item
		 * 
		 * @param	obj1
		 * 			is the first object in the overlapping
		 * @param	obj2
		 * 			is the second object in the overlapping
		 */
		private function pickUpItem(obj1:FlxObject, obj2:FlxObject):void {
			var item:Item;
			if (obj1 is Item) item = obj1 as Item;
			else if (obj2 is Item) item = obj2 as Item;
			_player.model.addItem(item.itemCode);
			item.kill();
		}
		
		/**
		 * Checking overlapping to see whether special event should happen
		 * (like changing map, allow save)
		 * 
		 * @param	obj1
		 * 			is the first object in the overlapping
		 * @param	obj2
		 * 			is the second object in the overlapping
		 */
		private function specialEvent(obj1:FlxObject, obj2:FlxObject):void {
			var door:Door;
			if (obj1 is Door) door = obj1 as Door;
			else if (obj2 is Door) door = obj2 as Door;
			
			// If player overlaps with a door
			if (door != null)
				// Change the map id
				_previousDoor = door;
		}
		
		/**
		 * Checking skill and character to see whether the skill has
		 * reached some character
		 * 
		 * @param	obj1
		 * 			is the first object in the overlapping
		 * @param	obj2
		 * 			is the second object in the overlapping
		 */
		private function checkSkillAttack(obj1:FlxObject, obj2:FlxObject):void {
			var skill:Skill, character:Character;
			if (obj1 is Skill) { skill = obj1 as Skill; character = obj2 as Character; }
			else { skill = obj2 as Skill; character = obj1 as Character; }
//			// Resize to reflect the true bounds
//			skill.resetPositionAndSize();
			// Only count if nearly perfect pixel overlap is detected
			if (FlxHitTest.overlapFlxSpritePixelsVSBound(skill, character))
				skill.hit(character);
			// Resize back for next overlap detection
//			skill.updatePositionAndSize();
			// Gain exp if the attacked character is dead
			if (! character.model.isAlive)
				skill.character.model.gainExp(character.model.stats.exp);
		}
		
//		/**
//		 * Destroy the skill when it collides with the tile
//		 * 
//		 * @param	obj1
//		 * 			is the first object in the overlapping
//		 * @param	obj2
//		 * 			is the second object in the overlapping
//		 * 
//		 */
//		private function destroySkill(obj1:FlxObject, obj2:FlxObject):void {
//			if (obj1 is Skill) obj1.kill();
//			if (obj2 is Skill) obj2.kill();
//		}

/**
		 * Destroy the skill when it collides with the tile
		 * 
		 * @param	skill
		 * 			is the skill to be destroyed
		 * 
		 */
		private function destroySkill(skill:Skill):void {
			skill.kill();
		}
		
		/**
		 * Open/display the HUD Menu screen so that player can navigate
		 */
		public function openHUDMenuScreen():void {
			_playScreen.active = false;
			_HUDMenuScreen.selected();
		}
		
		/**
		 * Open/display the HUD Menu screen so that player can navigate
		 */
		public function closeHUDMenuScreen(hudMenuScreen:HUDMenuScreen):void {
			_playScreen.active = true;
		}
		
		override public function add(Core:FlxObject):FlxObject {
			super.add(Core);
			if (Core is GameSprite)
				super.add((Core as GameSprite).attachedGroup);
			return Core;
		}
		
		override public function destroy():void {
			//super.destroy();
			resetState();
		}
	}
}