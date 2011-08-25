package errors {
	
	/**
	 * NonOverwriteAbstractMethod class
	 * @author Ken
	 * extends Error
	 * thrown when an abstract method which is meant to be overriden
	 * but in fact is not overriden
	 */
	public class NonOverwriteAbstractMethod extends ErrorAndExit {
		
		/**
		 * Constructor
		 */
		public function NonOverwriteAbstractMethod() {
			super( "This method must be overriden by subclasses." );
		}
	}
}