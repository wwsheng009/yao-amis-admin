
/**
 * Represents a map of options for store configuration.
 */
export type Option = { [key: string]: any };

/**
 * Represents the store instance configuration.
 */
export interface Instance {
  /** Store name */
  name: string;
  /** Optional store description */
  description?: string;
  /** Optional connector */
  connector?: string;
  /** Store type (deprecated in new versions) */
  type?: string;
  /** Store options */
  option?: Option;
}

/**
 * Represents the Store class for interacting with the key-value store.
 */
export declare class Store {
  /**
   * Create a new instance of Store
   * @param widgetID - The Store Widget ID
   */
  constructor(widgetID: string);

  /**
   * Sets a value in the store.
   * @param key - The key for the store item
   * @param value - The value to store
   * @param ttl - Time to live in seconds
   */
  Set(key: string, value: any, ttl?: number): void;

  /**
   * Gets a value from the store.
   * @param key - The key for the store item to get
   * @returns The value from the store or undefined if not found
   */
  Get(key: string): any;

  /**
   * Gets a value from the store, or sets it using the provided function if not found.
   * @param key - The key for the store item
   * @param getValue - Function to get the value if not found
   * @param ttl - Time to live in seconds
   * @returns The value from the store
   */
  GetSet(key: string, getValue: (key: string) => any, ttl?: number): any;

  /**
   * Gets a value from the store and deletes it.
   * @param key - The key for the store item
   * @returns The value from the store or undefined if not found
   */
  GetDel(key: string): any;

  /**
   * Checks if a key exists in the store.
   * @param key - The key to check
   * @returns True if the key exists, otherwise false
   */
  Has(key: string): boolean;

  /**
   * Deletes a key from the store.
   * @param key - The key to delete
   */
  Del(key: string): void;

  /**
   * Retrieves all keys in the store.
   * @returns An array of keys in the store
   */
  Keys(): string[];

  /**
   * Retrieves the number of items in the store.
   * @returns The number of items in the store
   */
  Len(): number;

  /**
   * Clears all items in the store.
   */
  Clear(): void;
}
