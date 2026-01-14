/**
 * Namespace defining types and interfaces for SUI Templating Engine.
 */
export declare namespace sui {
  /**
   * Represents a request structure in the Sui framework.
   */
  export interface Request {
    /** The HTTP method of the request, e.g., "GET" or "POST". */
    method: string;
    /** The root URL for accessing assets, optional. */
    asset_root?: string;
    /** The referer URL, indicating the source of the request. */
    referer?: string;
    /** Payload data sent with the request. */
    payload?: Record<string, any>;
    /** Query parameters in the request URL as key-value pairs. */
    query?: Record<string, string[]>;
    /** Path parameters extracted from the URL. */
    params?: Record<string, string>;
    /** Headers included in the request as key-value pairs. */
    headers?: Record<string, string[]>;
    /** The body of the request, containing any payload data. */
    body?: any;
    /** Details about the request URL. */
    url?: URL;
    /** Session ID for the request, optional. */
    sid?: string;
    /** The theme preference associated with the request, optional. */
    theme?: string;
    /** The locale setting for the request, optional. */
    locale?: string;
  }

  /**
   * Represents the structure of a request URL in the Sui framework.
   */
  export interface URL {
    /** The host of the request, e.g., "www.example.com". */
    host?: string;
    /** The domain of the request, e.g., "example.com". */
    domain?: string;
    /** The path of the request, e.g., "/path/to/route". */
    path?: string;
    /** The scheme of the request, e.g., "http" or "https". */
    scheme?: string;
    /** The full URL of the request. */
    url?: string;
  }
}
