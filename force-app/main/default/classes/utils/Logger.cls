/**
 * @description Utility class for consistent logging across the application
 * @author Zakaria Rguibi
 */
public with sharing class Logger {
    private String className;

    /**
     * @description Constructor that takes the class name for context in log messages
     * @param className Name of the class using the logger
     */
    public Logger(String className) {
        this.className = className;
    }

    /**
     * @description Logs a debug message
     * @param message Message to log
     */
    public void debug(String message) {
        System.debug(LoggingLevel.DEBUG, className + ': ' + message);
    }

    /**
     * @description Logs an info message
     * @param message Message to log
     */
    public void info(String message) {
        System.debug(LoggingLevel.INFO, className + ': ' + message);
    }

    /**
     * @description Logs a warning message
     * @param message Message to log
     */
    public void warning(String message) {
        System.debug(LoggingLevel.WARN, className + ': ' + message);
    }

    /**
     * @description Logs an error message with exception details
     * @param message Message to log
     * @param e Exception to log details from
     */
    public void error(String message, Exception e) {
        System.debug(
            LoggingLevel.ERROR,
            className + ': ' + message + ' - Exception: ' + 
            e.getTypeName() + ': ' + e.getMessage() + '\n' + 
            e.getStackTraceString()
        );
    }
}