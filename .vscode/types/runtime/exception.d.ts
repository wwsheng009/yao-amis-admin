/**
 * Represents a Javascript Exception.
 */
export declare class Exception {
  /** Exception code */
  code: number;

  /** Exception message */
  message: string;

  /**
   * Constructs a new Exception.
   *
   * @param message - The message describing the exception.
   * @param code - The code associated with the exception.
   * Additional arguments are supported to align with the Golang function signature.
   */
  constructor(message: string, code: number, ...args: any[]);

  // /**
  //  * Retrieves the code of the exception.
  //  * @returns The exception code.
  //  */
  // Code(): number;

  // /**
  //  * Retrieves the message of the exception.
  //  * @returns The exception message.
  //  */
  // Message(): string;
}
