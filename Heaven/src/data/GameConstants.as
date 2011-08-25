package data {
	import embeded.EmbededConstants;
	
	import events.FlixelPlatformGameEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.flixel.FlxBitmapFont;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.data.FlxSize;
	
	/**
	 * GameConstants class
	 * @author Ken
	 * contains all global constants of the game
	 * like whether this version is embeded version (closed to external change)
	 * or not (open to external design)
	 */
	public class GameConstants extends Constants {
		
		/** The back ground music */
		static private var _BACKGROUND_MUSIC_URL:String;
		static public function get BACKGROUND_MUSIC_URL():String {
			return _BACKGROUND_MUSIC_URL;
		} 
		/** Total number of maps */
		static private var _TOTAL_MAPS:int;
		static public function get TOTAL_MAPS():int { return _TOTAL_MAPS; }
		
		/** Width of each tile */
		static private var _TILE_WIDTH:Number = 32;
		static public function get TILE_WIDTH():Number { return _TILE_WIDTH; }
		/** Height of each tile */
		static private var _TILE_HEIGHT:Number = TILE_WIDTH;
		static public function get TILE_HEIGHT():Number { return _TILE_HEIGHT; }
		
		override public function loadConstants():void {
			// Is the external constant file embeded?
			if ( GameConstants.EMBEDED_ALL ) {
				// Yes
				// Then just read directly from the embeded file
				readConstants( new XML( new EmbededConstants.GeneralsConstants() ) );
			} else {
				// No
				// Read from external constant file
				var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, loadConstantsComplete );
				loader.load( new URLRequest( URLs.GENERAL_CONTANTS_URL ) );
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
			readConstants( new XML( event.target.data ) );
		}
		
		/**
		 * Read the general constants
		 * 
		 * @param	constantsXML
		 * 			is the xml format of all the constants
		 */
		private function readConstants(constantsXML:XML) {
			_BACKGROUND_MUSIC_URL = constantsXML.backgroundMusic.url.text();
			_TOTAL_MAPS = Number(constantsXML.totalMaps.text());
			_TILE_WIDTH = Number(constantsXML.tileSize.width.text());
			_TILE_HEIGHT = Number(constantsXML.tileSize.height.text());
			
			// Notify that the constants are loaded successfully
			dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
		}
		
		/** The url to the root folder */
		static public const ROOT_URL:String = "../";
		/** Name of the shared object for save file */
		static public const SHARED_OBJECT_NAME:String = "RPGFantasy";
		/** Path to the save data */
		static public const SAVE_PATH:String = null;
		/** The calling function for singleton pattern */
		static public const SINGLETON_STATIC_GET_INSTANCE_CALL:String = "getInstance";
		/** Flag to indicate whether embeded mode is enable */
		static public const EMBEDED_ALL:Boolean = false;
		/**
		 * Flag to indicate whether pixel overlap is enable
		 * (default is rectangle offset overlap)
		 * Note: reduce performacne
		 */
		static public var PERFECT_PIXEL_OVERLAP:Boolean = false;
		/** Blinking time, in second */
		static public var BLINKING_TIME:Number = 0.25; 
		/** Alpha value when blinking */
		static public var BLINKING_ALPHA:Number = 0.5;
		/** Minimum damage of characters' normal attack */
		static public var MIN_NORMAL_ATTACK_DAMAGE:Number = 1;
		/** Maximum level of characters */
		static public var CHARACTERS_MAX_LEVEL:int = 99;
		/** Flag to indicate whether to show monster's hp */
		static public var SHOW_MONSTERS_hp:Boolean = true;
		/** The distance between the door and the player (in grid) */
		static public var PLAYER_DOOR_DISTANCE:Number = 0.5;
		/** Tolerable error due to float round off error */
		static public var FLOAT_ROUND_OFF_ERROR:Number = 0.01;
		
		/** Positiin of the dialog on the screen */
		static public const DIALOG_LOCATION:FlxPoint = new FlxPoint(10, 10);
		/** Size of the dialog on the screen */
		static public const DIALOG_SIZE:FlxSize = new FlxSize(FlxG.width - 20, 100);
		/** Background color of the dialog */
		static public const DIALOG_BACKGROUND_COLOR:uint = 0xffffffff;
		/** Positiin of the speaker's name in the dialog */
		static public const DIALOG_SPEAKER_NAME_LOCATION:FlxPoint = new FlxPoint(20, 20);
		/** Width of the speaker's name in the dialog */
		static public const DIALOG_SPEAKER_NAME_WIDTH:Number = 100;
		/** Color of the speaker's name in the dialog */
		static public const DIALOG_SPEAKER_NAME_COLOR:uint = 0x00000000;
		/** Positiin of the cinversatiin text in the dialog */
		static public const DIALOG_TEXT_LOCATION:FlxPoint = new FlxPoint(20, 40);
		/** Width of the conversation text in the dialog */
		static public const DIALOG_TEXT_WIDTH:Number = FlxG.width - 40;
		/** Color of the text in the dialog */
		static public const DIALOG_TEXT_COLOR:uint = 0x00000000;
		/** Speed of the text in the dialog, in second per character */
		static public const DIALOG_TEXT_SECONDS_PER_CHARACTER:Number = 0.1; 
		
		/** Position of health bar on the screen */
		static public const HEALTH_BAR_LOCATION:FlxPoint = new FlxPoint(5, 5);
		/** Color of the frame of health bar */
		static public const HEALTH_BAR_FRAME_COLOR:uint = 0xffffffff;
		/** Color of the health which is lost */
		static public const HEALTH_BAR_LOST_COLOR:uint = 0xff000000;
		/** Color of the remaining health */
		static public const HEALTH_BAR_REMAINING_COLOR:uint = 0xffff0000;
		/** Size of the health bar */
		static public const HEALTH_BAR_SIZE:FlxSize = new FlxSize(FlxG.width/2, 10);
		/** Color of the frame of attached health bar */
		static public const ATTACHED_HEALTH_BAR_FRAME_COLOR:uint = 0xffffffff;
		/** Color of the attached health which is lost */
		static public const ATTACHED_HEALTH_BAR_LOST_COLOR:uint = 0xff000000;
		/** Color of the attached remaining health */
		static public const ATTACHED_HEALTH_BAR_REMAINING_COLOR:uint = 0xffff0000;
		/** Height of the attached health bar */
		static public const ATTACHED_HEALTH_BAR_HEIGHT:Number = 8;
		/** The thickness of the attached health bar */
		static public const ATTACHED_HEALTH_BAR_THICKNESS:Number = 1;
		
		/** Position of mp bar on the screen */
		static public const MP_BAR_LOCATION:FlxPoint = new FlxPoint(5, 15);
		/** Color of the frame of mp bar */
		static public const MP_BAR_FRAME_COLOR:uint = 0xffffffff;
		/** Color of the mp which is lost */
		static public const MP_BAR_LOST_COLOR:uint = 0xff000000;
		/** Color of the remaining mp */
		static public const MP_BAR_REMAINING_COLOR:uint = 0xff0000ff;
		/** Size of the mp bar */
		static public const MP_BAR_SIZE:FlxSize = new FlxSize(FlxG.width/2, 10);
		/** Default font for the game */
		static public const FONT:int = FlxBitmapFont.ANUVVERBUBBLA_8X8;//KROMAGRAD_16X16;
		/** Default font size for the game */
		static public const FONT_SIZE:FlxSize = new FlxSize(8, 8);//16, 16);
		/** Alpha value for HUD screen item when unselected */
		static public const HUD_SCREEN_ITEM_UNSELECTED_ALPHA:Number = 0.5;
		
		
		//=============
		// HUD Screens
		//=============
		
		/** Background frame color of all the HUD screens */
		static public const HUD_SCREEN_FRAME_COLOR:uint = 0xff000000;
		/** The thickness of the frame of the HUD screens */
		static public const HUD_SCREEN_FRAME_THICKNESS:uint = 3;
		/** The back ground color of the HUD screens */
		static public const HUD_SCREEN_BACKGROUND_COLOR:uint = 0xffbdb76b;
		/** The size of the HUD menu screen */
		static public const HUD_MENU_SCREEN_SIZE:FlxSize = new FlxSize(210, 240);
		/** The location of the HUD menu screen */
		static public const HUD_MENU_SCREEN_LOCATION:FlxPoint =
			new FlxPoint(FlxG.width/2 - HUD_MENU_SCREEN_SIZE.width/2, FlxG.height/2 - HUD_MENU_SCREEN_SIZE.height/2);
		/** The location of the HUD character stats screen */
		static public const HUD_CHARACTER_STATS_SCREEN_LOCATION:FlxPoint = new FlxPoint(10, 10);
		/** The size of the HUD character stats screen */
		static public const HUD_CHARACTER_STATS_SCREEN_SIZE:FlxSize =
			new FlxSize(HUD_MENU_SCREEN_SIZE.width - 2 * HUD_CHARACTER_STATS_SCREEN_LOCATION.x, 130);
		/** Position of the first text on the character stats screen */
		static public const HUD_CHARACTER_STATS_SCREEN_TEXT_LOCATION:FlxPoint = new FlxPoint(10, 10);
		/** Distance between consecutive texts on the character stats screen */
		static public const HUD_CHARACTER_STATS_SCREEN_TEXT_SPACING:FlxPoint = new FlxPoint(0, 15);
		/** Position of the items list on the menu screen */
		static public const HUD_MENU_SCREEN_ITEMS_LIST_LOCATION:FlxPoint = new FlxPoint(10, 150);
		/** Size of the items list on the menu screen */
		static public const HUD_MENU_SCREEN_ITEMS_LIST_SIZE:FlxSize =
			new FlxSize(HUD_MENU_SCREEN_SIZE.width - 2 * HUD_MENU_SCREEN_ITEMS_LIST_LOCATION.x, 75);
		/** Line spacing between items in the items list */
		static public const HUD_SCREEN_ITEMS_LIST_LINE_SPACING:Number = 2;
		/** The loction of the HUD items screen */
		static public const HUD_ITEMS_SCREEN_LOCATION:FlxPoint = new FlxPoint(10, 10);
		/** The size of the HUD items screen */
		static public const HUD_ITEMS_SCREEN_SIZE:FlxSize =
			new FlxSize(HUD_MENU_SCREEN_SIZE.width - 2 * HUD_ITEMS_SCREEN_LOCATION.x,
						HUD_MENU_SCREEN_SIZE.height - 2 * HUD_ITEMS_SCREEN_LOCATION.y);
		/** The loction of the HUD skills screen */
		static public const HUD_SKILLS_SCREEN_LOCATION:FlxPoint = new FlxPoint(10, 10);
		/** The size of the HUD skills screen */
		static public const HUD_SKILLS_SCREEN_SIZE:FlxSize =
			new FlxSize(HUD_MENU_SCREEN_SIZE.width - 2 * HUD_SKILLS_SCREEN_LOCATION.x,
						HUD_MENU_SCREEN_SIZE.height - 2 * HUD_SKILLS_SCREEN_LOCATION.y);
		/** The location of the HUD controls screen */
		static public const HUD_CONTROLS_SCREEN_LOCATION:FlxPoint = new FlxPoint(10, 10);
		/** The size of the HUD controls screen */
		static public const HUD_CONTROLS_SCREEN_SIZE:FlxSize =
			new FlxSize(HUD_MENU_SCREEN_SIZE.width - 2 * HUD_CONTROLS_SCREEN_LOCATION.x,
				HUD_MENU_SCREEN_SIZE.height - 2 * HUD_CONTROLS_SCREEN_LOCATION.y);
		/** Position of the first text on the controls screen */
		static public const HUD_CONTROLS_SCREEN_TEXT_LOCATION:FlxPoint = new FlxPoint(10, 10);
		/** Distance between consecutive texts on the controls screen */
		static public const HUD_CONTROLS_SCREEN_TEXT_SPACING:FlxPoint = new FlxPoint(0, 15);
		
		
		//==============
		// Title screen
		//==============
		/** The position of the options list on the screen */
		static public const TITLE_SCREEN_OPTIONS_LIST_LOCATION:FlxPoint = new FlxPoint(0, 0);
		/** The size of the options list on the screen */
		static public const TITLE_SCREEN_OPTIONS_LIST_SIZE:FlxSize =
			new FlxSize(FlxG.width, 200);// FlxG.height - TITLE_SCREEN_OPTIONS_LIST_LOCATION.y);
	}
}