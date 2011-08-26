package editor;

import java.awt.Component;

import javax.swing.JOptionPane;

/**
 * ErrorLog class
 * 
 * @author Ken
 * 
 * This class display error messages to the user.
 *
 */
class ErrorLog {
	
	/**
	 * Display error message to the user
	 * 
	 * @param	parent
	 * 			is the parent in which the error occurs
	 * 
	 * @param	message
	 * 			is the message to show in the error message dialog
	 * 
	 * @param	title
	 * 			is the title of the error message dialog
	 */
	static void showError( Component parent, String message, String title ) {
		JOptionPane.showMessageDialog( JOptionPane.getFrameForComponent(parent), message, title, JOptionPane.ERROR_MESSAGE );
	}

}
