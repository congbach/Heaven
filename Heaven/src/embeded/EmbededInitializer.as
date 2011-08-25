package embeded {
	
	
	/**
	 * EmbededInitialized class
	 * @author Ken
	 * to initialize necessary information
	 * like sort all the map design files
	 * in the right order
	 */
	public class EmbededInitializer	{
		static public function initialize():void {
			// Initialize all embeded files
			EmbededMaps.initialize();
			EmbededImages.initialize();
		}
	}
}