// atob	Decodes a base64-encoded string to its original form.
// btoa	Encodes a string to base64 format.

/**
 * Encodes a string to base64 format.
 *
 * @param string The string to encode.
 * @returns The base64-encoded string.
 */
export declare function atob(encodedString: string): string;

/**
 * Decodes a base64-encoded string to its original form.
 *
 * @param base64String The base64-encoded string to decode.
 * @returns The original string.
 */
export declare function btoa(string: string): string;

/**
 * The engine load options.
 */
export type LoadOption = {
  /**
   * The action to perform.
   */
  action: "start" | "run" | "migrate";

  /**
   * The mode to run the action in.
   */
  ignoredAfterLoad: boolean;

  /**
   * Is reloading the environment required?
   */
  reload: boolean;
};

/**
 * The migration options.
 */
export type MigrateOption = {
  /**
   * YAO_ENV environment variable.
   */
  mode: "production" | "development";

  /**
   * Is the force flag set?
   */
  force: boolean;

  /**
   * Is the reset flag set?
   */
  reset: boolean;
};

/**
 * Represents a dataset with pagination information.
 * This type is commonly used for paginated data retrieval,
 * such as search results or lists with multiple pages.
 */
export type PagedData = {
  /**
   * The data items.
   */
  data: Record<string, any>[];

  /**
   * The next page number. -1 no next page.
   */
  next: number;

  /**
   * The current page number.
   */
  page: number;

  /**
   * The total number of pages.
   */
  pagecnt: number;

  /**
   * The number of items per page.
   */
  pagesize: number;

  /**
   * The previous page number. -1 no previous page.
   */
  prev: number;

  /**
   * The total number of items.
   */
  total: number;
};
