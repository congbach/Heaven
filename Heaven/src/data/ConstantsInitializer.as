package data {
	import events.FlixelPlatformGameEvent;
	
	import flash.events.Event;
	
	/**
	 * ConstantsInitializer class
	 * @author Ken
	 * This class makes sure all constants
	 * are initialized
	 */
	public class ConstantsInitializer {
		
		/**
		 * Flag indicate whether all constants are initialized
		 */
		static private var _LOAD_COMPLETE:Boolean = false;
		
		/**
		 * Vector which contains all the constants class
		 * to call loadConstants in each class
		 */
		static private const AllConstantsClasses:Vector.< Class > = new Vector.< Class >();
		/**
		 * Index of the current constants class which is currently loaded
		 */
		static private var constantClassIndex:int;
		
		/**
		 * Start initialize all constants
		 */
		static public function initializeConstants():void {
			AllConstantsClasses.push( KeyboardConstants, GameConstants, URLs, UnitsConstants,
				SkillsConstants, CharactersConstants, ItemsConstants, MapsDesigns, ImagesBitmapConstants );
			constantClassIndex = -1;
			loadNextClassConstants();
		}
		
		/**
		 * Load the next constants class
		 * by calling method loadConstants() of one instance
		 * of the next class (if any)
		 * change _LOAD_COMPLETE to true if all constants are
		 * initialized (all constants classes are loaded)
		 */
		static private function loadNextClassConstants():void {
			// Have all the constants readed?
			if ( ++constantClassIndex >= AllConstantsClasses.length ) {
				// Yes
				_LOAD_COMPLETE = true;
				return;
			}
			
			// Load the constants of the next class
			var constantsClass:Constants = new AllConstantsClasses[ constantClassIndex ]();
			constantsClass.addEventListener( 
				FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE, classConstantsLoadComplete );
			constantsClass.loadConstants();
		}
		
		/**
		 * Event listener to indicate that the currently constants class has
		 * been successfully loaded (all relevant constants are initialized)
		 * @param	event	is FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE
		 * 					which is dispatched upon completion of initializing
		 * 					constants
		 */
		static private function classConstantsLoadComplete( event:Event ):void {
			loadNextClassConstants();
		}
		
		/**
		 * Function to check whether all constants have been initialized
		 * or all constants classes have been loaded
		 * @return	true	if all constants have been initialized
		 * 			false	otherwise
		 */
		static public function didLoadComplete():Boolean {
			if ( GameConstants.EMBEDED_ALL )
				return true;
			
			return _LOAD_COMPLETE;
		}
	}
}