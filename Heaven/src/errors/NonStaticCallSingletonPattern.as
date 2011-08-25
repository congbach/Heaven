package errors {
	
	/**
	 * NonStaticCallSingletonPattern class
	 * @author Ken
	 * extends Error
	 * thrown upon illegal (direct) call of constructor of a class to which Singleton pattern
	 * is apply
	 * legal call is via static method getInstance() only
	 */
	public class NonStaticCallSingletonPattern extends ErrorAndExit {
		
		/**
		 * Constructor
		 * @param	className	is the name of the class to which Singleton
		 * 						pattern is applied
		 */
		public function NonStaticCallSingletonPattern( className:String ) {
			super( "Illegal call of constructor of singleton-pattern class: " + className
				+ ". Please use " + className + ".getInstance() instead." );
		}
	}
}