/**
 * Namespace defining I/O-related types and interfaces.
 */
export declare namespace io {
  /**
   * Represents a generic writer interface.
   */
  export type Writer = object;

  /**
   * Represents a generic reader interface.
   */
  export type Reader = object;

  /**
   * Represents a combined reader and closer interface.
   */
  export type ReadCloser = object;

  /**
   * Represents a combined writer and closer interface.
   */
  export type WriteCloser = object;

  /**
   * Represents a response writer for handling output.
   */
  export type ResponseWriter = object;
}
