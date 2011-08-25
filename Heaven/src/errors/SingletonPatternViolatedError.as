package errors {
	
	/**
	 * SingletonPatternViolatedError class
	 * @author Ken
	 * extends Error
	 * thrown when a second instance of a class to which Singleton pattern
	 * is applied is created
	 */
	public class SingletonPatternViolatedError extends ErrorAndExit	{
		
		/**
		 * Constructor
		 * @param	className	is the name of the class to which Singleton
		 * 						pattern is applied
		 */
		public function SingletonPatternViolatedError( className:String ) {
			super( "Singleton pattern: Only one instance of " + className + " is allowed." );
		}
	}
}