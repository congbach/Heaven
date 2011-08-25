package errors {
	import flash.system.fscommand;
	
	/**
	 * ErrorAndExit class
	 * @author Ken
	 * extends Error
	 * throw error and exit the flash (not working right now)
	 */
	public class ErrorAndExit extends Error {
		
		/**
		 * Constructor
		 * @param	desc	is the description of the error
		 */
		public function ErrorAndExit( desc:String ) {
			super( desc );
			fscommand( "quit" );
		}
	}
}