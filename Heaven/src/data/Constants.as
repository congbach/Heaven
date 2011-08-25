package data {
	import flash.events.EventDispatcher;
	
	/**
	 * Constants class
	 * @author Ken
	 * based type for constants
	 * have method loadConstants to load/initialized
	 * constants and dispatch
	 * FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE
	 * upon completion
	 */
	public class Constants extends EventDispatcher {
		
		/** Load the necessary constants */
		public function loadConstants():void {
			
		}
	}
}