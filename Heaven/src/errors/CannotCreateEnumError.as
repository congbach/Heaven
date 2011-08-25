package errors {
	
	/**
	 * CannotCreateEnumError class
	 * @author Ken
	 * extends Error
	 * thrown when an enum class is illegally instantiated
	 */
	public class CannotCreateEnumError extends ErrorAndExit {
		
		/**
		 * Constructor
		 * @param	enumName	is the name of the enum class
		 */
		public function CannotCreateEnumError( enumName:String ) {
			super( "Enum class cannot be initialized: " + enumName );
		}
	}
}