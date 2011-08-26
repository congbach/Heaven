package editor;

import java.awt.Component;

import javax.swing.JOptionPane;
import javax.swing.JTextArea;

import constants.EditorConstants;

/**
 * ExceptionHandler
 * 
 * Handle exception, show error log so that user can send
 * to developer to fix
 * 
 * @author Ken
 */
public class ExceptionHandler {
	
	/**
	 * Handle the exception
	 * Print the log message, as well as display the log to user
	 * so that he/she can send it to the developer
	 * 
	 * @param	e
	 * 			is the thrown exception
	 */
	static public void handleException(Exception e) {
		e.printStackTrace();
		if (EditorConstants.SHOW_ERRORS_MESSAGE_DIALOG) {
			String errorMessage = e.toString();
			StackTraceElement[] stackTrace = e.getStackTrace();
			for (StackTraceElement elem : stackTrace)
				errorMessage += "\n" + elem.toString();
			JTextArea errorText = new JTextArea( errorMessage );
			errorText.setEditable( false );
			JOptionPane.showMessageDialog( JOptionPane.getRootFrame(), errorText, "Error", JOptionPane.ERROR_MESSAGE );
		}
	}
	
	/**
	 * Handle the exception
	 * Print the log message, as well as display the log to user
	 * so that he/she can send it to the developer
	 * 
	 * @param	message
	 * 			is the message of the error
	 */
	static public void handleException(String message) {
		System.out.println(message);
		if (EditorConstants.SHOW_ERRORS_MESSAGE_DIALOG)
			JOptionPane.showMessageDialog( JOptionPane.getRootFrame(), message, "Error", JOptionPane.ERROR_MESSAGE );
	}
	
	

}
