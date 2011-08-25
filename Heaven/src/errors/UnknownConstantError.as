package errors {
	
	/**
	 * UnknownConstantError class
	 * @author Ken
	 * extends Error
	 * thrown when an unknown constant is read from external file
	 */
	public class UnknownConstantError extends ErrorAndExit {
		
		/**
		 * Constructor
		 * @param	constantName	is the name of the unknown constant
		 */
		public function UnknownConstantError( constantName:String ) {
			super( "Unknown constant: " + constantName );
		}
	}
}