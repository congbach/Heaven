package errors {
	
	/**
	 * IllegalArgumentException class
	 * @author Ken
	 * extends Error
	 * thrown an argument does not satisfy pre-condition for that argument
	 */
	public class IllegalArgumentException extends ErrorAndExit {
		
		/**
		 * Constructor
		 * @param	name	is the name of the argument
		 * @param	value	is the value of the argument
		 */
		public function IllegalArgumentException( name:String = "", value:* = null ) {
			super( "Illegal Argument Exception: " + name + " - " + value /*.toString()*/ );
		}
	}
}