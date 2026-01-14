

/**
 * Log Level enum to represent different levels of logging.
 */
export enum LogLevel {
  Trace,
  Debug,
  Info,
  Warn,
  Error,
  Fatal,
  Panic
}

/**
 * Interface for the logging functions available in the log package.
 */
export interface Log {
  /**
   * Logs a message at the trace level.
   * @param message - The message to log.
   * @param values - Additional values to log.
   */
  Trace(message: string, ...values: any[]): void;

  /**
   * Logs a message at the debug level.
   * @param message - The message to log.
   * @param values - Additional values to log.
   */
  Debug(message: string, ...values: any[]): void;

  /**
   * Logs a message at the info level.
   * @param message - The message to log.
   * @param values - Additional values to log.
   */
  Info(message: string, ...values: any[]): void;

  /**
   * Logs a message at the warning level.
   * @param message - The message to log.
   * @param values - Additional values to log.
   */
  Warn(message: string, ...values: any[]): void;

  /**
   * Logs a message at the error level.
   * @param message - The message to log.
   * @param values - Additional values to log.
   */
  Error(message: string, ...values: any[]): void;

  /**
   * Logs a message at the fatal level.
   * @param message - The message to log.
   * @param values - Additional values to log.
   */
  Fatal(message: string, ...values: any[]): void;

  /**
   * Logs a message at the panic level.
   * @param message - The message to log.
   * @param values - Additional values to log.
   */
  Panic(message: string, ...values: any[]): void;
}

/**
 * Export a singleton instance of the Log interface.
 */
export declare var log: Log;

