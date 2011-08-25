package data {
	import models.equipments.AccessoryModel;
	import models.equipments.LeggingModel;
	import models.equipments.ArmbandModel;
	import models.equipments.HelmetModel;
	import models.equipments.ArmorModel;
	import models.equipments.ShieldModel;
	import enums.WeaponType;
	import models.equipments.WeaponModel;
	import enums.EquipmentType;
	import models.items.ItemModel;
	import models.ImmutablePhysicsModel;
	import embeded.EmbededConstants;
	import enums.StatsType;
	
	import errors.IllegalArgumentException;
	
	import events.FlixelPlatformGameEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.stats.ImmutableStats;
	
	/**
	 * Items Constants class
	 * @author Ken
	 * contains data from all items
	 * read from external file (design period)
	 * or from embeded file (final version)
	 */
	public class ItemsConstants extends Constants {
		
		/**
		 * Object which stores all the base models of the items
		 */
		static private const _itemsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the swords
		 */
		static private const _swordsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the axes
		 */
		static private const _axesConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the spears
		 */
		static private const _spearsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the knuckles
		 */
		static private const _knucklesConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the rods
		 */
		static private const _rodsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the wands
		 */
		static private const _wandsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the bows
		 */
		static private const _bowsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the guns
		 */
		static private const _gunsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the shields
		 */
		static private const _shieldsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the armors
		 */
		static private const _armorsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the helmets
		 */
		static private const _helmetsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the armbands
		 */
		static private const _armbandsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the leggings
		 */
		static private const _leggingsConstants:Object = new Object();
		/**
		 * Object which stores all the base models of the accessoriess
		 */
		static private const _accessoriesConstants:Object = new Object();
		/**
		 * Array which contains all item objects
		 */
		static private const _allItems:Vector.<Object> = new Vector.<Object>();
		/**
		 * The reading mode
		 */
		static private const _TOTAL_READING_MODE:int = _READ_ACCESSORIES_CONSTANTS + 1;
		static private const _READ_ITEMS_CONSTANTS:int = 0;
		static private const _READ_SWORDS_CONSTANTS:int = 1;
		static private const _READ_AXES_CONSTANTS:int = 2;
		static private const _READ_SPEARS_CONSTANTS:int = 3;
		static private const _READ_KNUCKLES_CONSTANTS:int = 4;
		static private const _READ_RODS_CONSTANTS:int = 5;
		static private const _READ_WANDS_CONSTANTS:int = 6;
		static private const _READ_BOWS_CONSTANTS:int = 7;
		static private const _READ_GUNS_CONSTANTS:int = 8;
		static private const _READ_SHIELDS_CONSTANTS:int = 9;
		static private const _READ_ARMORS_CONSTANTS:int = 10;
		static private const _READ_HELMETS_CONSTANTS:int = 11;
		static private const _READ_ARMBANDS_CONSTANTS:int = 12;
		static private const _READ_LEGGINGS_CONSTANTS:int = 13;
		static private const _READ_ACCESSORIES_CONSTANTS:int = 14;
			
		
//		/**
//		 * Object which stores all the items stats
//		 */
//		static private const _itemsStats:Object = new Object();
//		/**
//		 * Object which stores all the images urls of items
//		 */
//		static private const _itemsImagesUrls:Object = new Object();
//		/**
//		 * Object which stores offset properties of items
//		 */
//		static private const _itemsOffsets:Object = new Object();
//		/**
//		 * Object which stores all the stats of the equipments
//		 * This will contain properties: weapons->swords/axes/...
//		 */
//		static private const _equipmentsStats:Object = new Object();
//		/**
//		 * Object which stores all the skills of the equipments
//		 */
//		static private const _equipmentsSkills:Object = new Object();
//		/**
//		 * Object which stores all the images urls of equipments
//		 */
//		static private const _equipmentsImagesUrls:Object = new Object();
//		/**
//		 * Object which stores all the offset properties of equipments
//		 */
//		static private const _equipmentsOffset:Object = new Object();
		
		/**
		 * Load/Read constants from external or embeded file
		 */
		override public function loadConstants():void {
			_allItems.push(_itemsConstants, _swordsConstants, _axesConstants, _spearsConstants,
							_knucklesConstants, _rodsConstants, _wandsConstants, _bowsConstants,
							_gunsConstants, _shieldsConstants, _armorsConstants, _helmetsConstants,
							_armbandsConstants, _leggingsConstants, _accessoriesConstants);
			// Is the external constant file embeded?
			if ( GameConstants.EMBEDED_ALL ) {
				// Yes
				// Then just read directly from the embeded file
				readItemsConstants( new XML( new EmbededConstants.ItemsConstants() ) );
			} else {
				// No
				// Read from external constant file
				var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, loadConstantsComplete );
				loader.load( new URLRequest( URLs.ITEMS_CONSTANTS_CONFIG_FILE ) );
			}
		}
		
		/**
		 * Event listener to loader of external file
		 * Read and decode the data of external file
		 * dispatch FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE
		 * when all constants are read/initialized
		 * @param	event
		 * 			is the Event.COMPLETE attached to loader
		 * 			of external file
		 */
		private function loadConstantsComplete( event:Event ):void {
			readItemsConstants( new XML( event.target.data ) );
		}
		
		/**
		 * Read the stats of all the items
		 * 
		 * @param	itemsConstantsXML
		 * 			is the details of the items' stats, in xml format 
		 */
		private function readItemsConstants(constantsXML:XML) {
			for (var readMode:int = 0; readMode < ItemsConstants._TOTAL_READING_MODE; readMode++) {			
				var list:XMLList = null;
				switch (readMode) {
					case _READ_ITEMS_CONSTANTS:
						list = constantsXML.items;
						break;
					case _READ_SWORDS_CONSTANTS:
						list = constantsXML.equipments.weapons.swords;
						break;
					case _READ_AXES_CONSTANTS:
						list = constantsXML.equipments.weapons.axes;
						break;
					case _READ_SPEARS_CONSTANTS:
						list = constantsXML.equipments.weapons.spears;
						break;
					case _READ_KNUCKLES_CONSTANTS:
						list = constantsXML.equipments.weapons.knuckles;
						break;
					case _READ_RODS_CONSTANTS:
						list = constantsXML.equipments.weapons.rods;
						break;
					case _READ_WANDS_CONSTANTS:
						list = constantsXML.equipments.weapons.wands;
						break;
					case _READ_BOWS_CONSTANTS:
						list = constantsXML.equipments.weapons.bows;
						break;
					case _READ_GUNS_CONSTANTS:
						list = constantsXML.equipments.weapons.guns;
						break;
					case _READ_SHIELDS_CONSTANTS:
						list = constantsXML.equipments.shields;
						break;
					case _READ_ARMORS_CONSTANTS:
						list = constantsXML.equipments.armors;
						break;
					case _READ_HELMETS_CONSTANTS:
						list = constantsXML.equipments.helmets;
						break;
					case _READ_ARMBANDS_CONSTANTS:
						list = constantsXML.equipments.armbands;
						break;
					case _READ_LEGGINGS_CONSTANTS:
						list = constantsXML.equipments.leggings;
						break;
					case _READ_ACCESSORIES_CONSTANTS:
						list = constantsXML.equipments.accessories;
						break;											
				}
				
				// Read constants for each items
				for each (var item:XML in list.children()) {
					var name:String = item.name.text();
					
					var stats:XMLList = item.stats;
					var maxHp:uint = Number(stats.maxHp.text());
					var hp:uint = Number(stats.hp.text());
					var maxMp:uint = Number(stats.maxMp.text());
					var mp:uint = Number(stats.mp.text());
					var atk:uint = Number(stats.atk.text());
					var def:uint = Number(stats.def.text());
					var spd:uint = Number(stats.spd.text());
					var luck:uint = Number(stats.luck.text());
					var exp:uint = Number(stats.exp.text());
					var lvl:uint = Number(stats.level.text());
					var baseStats:ImmutableStats =
						new ImmutableStats(StatsType.ABSOLUTE, maxHp, hp, maxMp, mp, atk, def, spd, luck, exp, lvl);
					
					var imageUrl:String = item.imageUrl.text();
					
					var width:int = Number(item.size.width.text());
					var height:int = Number(item.size.height.text());
					var offsetX:int = Number(item.offset.x.text());
					var offsetY:int = Number(item.offset.y.text());
					var offsetWidth:int = Number(item.offset.width.text());
					var offsetHeight:int = Number(item.offset.height.text());
					var physicsModel:ImmutablePhysicsModel =
							new ImmutablePhysicsModel(offsetX, offsetY, offsetWidth, offsetHeight, 0, 0, 0, 0, 0, 0);
					var model:GameObjectModel = null;
					
					switch (readMode) {
						case _READ_ITEMS_CONSTANTS:
							model = new ItemModel(UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_SWORDS_CONSTANTS:
							model = new WeaponModel(WeaponType.SWORD,
								UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_AXES_CONSTANTS:
							model = new WeaponModel(WeaponType.AXE,
								UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_SPEARS_CONSTANTS:
							model = new WeaponModel(WeaponType.SPEAR,
								UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_KNUCKLES_CONSTANTS:
							model = new WeaponModel(WeaponType.KNUCKLE,
								UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_RODS_CONSTANTS:
							model = new WeaponModel(WeaponType.ROD,
								UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_WANDS_CONSTANTS:
							model = new WeaponModel(WeaponType.WAND,
								UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_BOWS_CONSTANTS:
							model = new WeaponModel(WeaponType.BOW,
								UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_GUNS_CONSTANTS:
							model = new WeaponModel(WeaponType.GUN,
								UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_SHIELDS_CONSTANTS:
							model = new ShieldModel(UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_ARMORS_CONSTANTS:
							model = new ArmorModel(UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_HELMETS_CONSTANTS:
							model = new HelmetModel(UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_ARMBANDS_CONSTANTS:
							model = new ArmbandModel(UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_LEGGINGS_CONSTANTS:
							model = new LeggingModel(UnitsConstants.getItemCode(name), name, baseStats);
							break;
						case _READ_ACCESSORIES_CONSTANTS:
							model = new AccessoryModel(UnitsConstants.getItemCode(name), name, baseStats);
							break;											
					}
					
					_allItems[readMode][name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//					switch (readMode) {
//						case _READ_ITEMS_CONSTANTS:
//							_itemsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_SWORDS_CONSTANTS:
//							_swordsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_AXES_CONSTANTS:
//							_axesConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_SPEARS_CONSTANTS:
//							_spearsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_KNUCKLES_CONSTANTS:
//							_knucklesConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_RODS_CONSTANTS:
//							_rodsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_WANDS_CONSTANTS:
//							_wandsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_BOWS_CONSTANTS:
//							_bowsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_GUNS_CONSTANTS:
//							_gunsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_SHIELDS_CONSTANTS:
//							_shieldsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_ARMORS_CONSTANTS:
//							_armorsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_HELMETS_CONSTANTS:
//							_helmetsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_ARMBANDS_CONSTANTS:
//							_armbandsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_LEGGINGS_CONSTANTS:
//							_leggingsConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//						case _READ_ACCESSORIESS_CONSTANTS:
//							_accessoriesConstants[name] = new ImmutableGameObjectData(imageUrl, width, height, physicsModel, null, model);
//							break;
//							
//					}
				}
			}
			
			// Notify that the constants are loaded successfully
			dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
		}
		
		
//		/**
//		 * Get the data of one item based on the code of that item
//		 * @param	itemCode					is the code (encoded) of the item
//		 * @return	Stats						which contains the stats of the item associated
//		 * 										with the given item code
//		 * @throw	IllegalArgumentException	if the itemCode given does not match any
//		 * 										particular type/class of item
//		 */
//		static public function getItemStatsByItemCode( itemCode:int ):ImmutableStats {
//			return getItemStatsByItemName( UnitsConstants.getItemName( itemCode ) );
//		}
//		
//		/**
//		 * Get the data of the item based on the item code
//		 * @param	itemName					is the name of the item
//		 * @return	Stats						which contains the stats of the item
//		 * @throw	IllegalArgumentException	if the itemName given does not match any
//		 * 										particular item
//		 */
//		static public function getItemStatsByItemName( itemName:String ):ImmutableStats {
//			if ( _itemsStats[ itemName ] == undefined
//				|| _itemsStats[ itemName ] == null )
//				throw new IllegalArgumentException( "itemName", itemName );
//			return _itemsStats[ itemName ];
//		}
//		
//		/**
//		 * Get the image url of the item based on the code of that item
//		 * 
//		 * @param	itemCode
//		 * 			is the code of the item
//		 * @return	url to the image of that item, in string format
//		 * @throw	IllegalArgumentException
//		 * 			is there is no item with the given code
//		 */
//		static public function getItemImageUrlByItemCode(itemCode:int):String {
//			return getItemImageUrlByItemName(UnitsConstants.getItemName(itemCode));
//		}
//		
//		/**
//		 * Get the image url of the item based on the name of that item
//		 * 
//		 * @param	itemName
//		 * 			is the name of the item
//		 * @return	url to the image of that item, in string format
//		 * @throw	IllegalArgumentException
//		 * 			is there is no item with the given name
//		 */
//		static public function getItemImageUrlByItemName(itemName:String):String {
//			if ( _itemsImagesUrls[ itemName ] == undefined
//				|| _itemsImagesUrls[ itemName ] == null )
//				throw new IllegalArgumentException( "itemName", itemName );
//			return _itemsImagesUrls[ itemName ];
//		}
//		
		/**
		 * Get urls of images of all the items
		 * For safety return value is only a copy version of itemsUrls
		 * @return	Object	which contains urls to images of all the items
		 */
		static public function getAllItemsImagesUrls():Object {
			var itemsImagesUrls:Object = new Object();
//			for ( var constants:Object in _allItems )
			for (var i:int = 0; i < _allItems.length; i++) {
				var constants:Object = _allItems[i];
				for (var key:String in constants) {
					var gameObj:ImmutableGameObjectData = constants[key];
					itemsImagesUrls[key] = gameObj.imageUrl;
				}
			}
			return itemsImagesUrls;
		}
		
		/**
		 * Return the game object data of the item based on the given code
		 * 
		 * @param	itemCode
		 * 			is the code of the item to retrieve game object data
		 * 			
		 * @return	ImmutableGameObjectData
		 * 			of the item with the given code
		 * 			
		 * @throws	IllegalArgumentException
		 * 			is there is no item with the given code
		 */
		static public function getItemByItemCode(itemCode:int):ImmutableGameObjectData {
			return getItemByItemName(UnitsConstants.getItemName(itemCode));
		}
		
		/**
		 * Return the game object data of the item based on the given name
		 * 
		 * @param	itemName
		 * 			is the name of the item to retrieve game object data
		 * 			
		 * @return	ImmutableGameObjectData
		 * 			of the item with the given name
		 * 			
		 * @throws	IllegalArgumentException
		 * 			is there is no item with the given name
		 */
		static public function getItemByItemName(itemName:String):ImmutableGameObjectData {
			
			if ( _itemsConstants[ itemName ] == undefined
				|| _itemsConstants[ itemName ] == null )
				throw new IllegalArgumentException( "itemName", itemName );

			return _itemsConstants[itemName];
		}
//		
//		/**
//		 * Get the offset of a item based on its code
//		 * 
//		 * @param	itemCode
//		 * 			is the code of the item
//		 * @return	offset of the item with the given code
//		 * @throw	IllegalArgumentException
//		 * 			is there is no item with the given code
//		 */
//		static public function getItemOffsetByItemCode(itemCode:int):Object {
//			return getItemOffsetByItemName(UnitsConstants.getItemName(itemCode));
//		}
//		
//		/**
//		 * Get the offset of a item based on its name
//		 * 
//		 * @param	itemName
//		 * 			is the name of the item
//		 * @return	offset of the item with the given name
//		 * @throw	IllegalArgumentException
//		 * 			is there is no item with the given name
//		 */
//		static public function getItemOffsetByItemName(itemName:String):Object {
//			if ( _itemsOffsets[ itemName ] == undefined
//				|| _itemsOffsets[ itemName ] == null )
//				throw new IllegalArgumentException( "itemName", itemName );
//			var itemOffset:Object = _itemsOffsets[ itemName ];
//			var itemOffsetClone:Object = new Object();
//			for (var key:String in itemOffset)
//				itemOffsetClone[key] = itemOffset[key];
//			return itemOffsetClone;
//		}
	}
}