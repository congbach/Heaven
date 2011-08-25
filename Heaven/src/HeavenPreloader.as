package {
	import org.flixel.FlxPreloader;
	
	/**
	 * FlixelPlatformGamePreloader
	 * 
	 * Extends Preloader from flixel library
	 * Provide necessary information/library for the game
	 */
	public class HeavenPreloader extends FlxPreloader {
		public function HeavenPreloader() {
			className = "Heaven";
			super();
		}
	}
}