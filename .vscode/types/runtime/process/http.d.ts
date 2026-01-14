

/**
 * Represents an HTTP response.
 */
export interface HttpResponse {
  // The status code of the response.
  status: number;
  
  // The data returned by the response.
  data: any;

  // The headers returned by the response.
  headers: Record<string, string | string[]>;

  // The code of the response.
  code: number;

  // The message included in the response.
  message: string;
}

/**
 * Represents an HTTP file to be uploaded.
 */
export interface HttpFile {
  // The name of the file.
  name: string;

  // Optional path to the file.
  path?: string;

  // Optional base64 encoded data of the file.
  data?: string;
}

/**
 * Read file content
 * @param process http.Get
 * @param url string The URL to send the GET request to.
 * @param query Optional query parameters to include in the request.
 * @param headers Optional headers to include in the request.
 */
export declare function Process(
  process: `http.Get`,
  url: string,
  query?: Record<string, string> | [string, string][] | Array<Record<string, string>> | string,
  headers?: Record<string, string> | Record<string, string>[],
): HttpResponse;

/**
 * Send a POST request
 * @param process http.Post
 * @param url string The URL to send the POST request to.
 * @param payload Optional data to send in the body of the request.
 * @param files Optional files to upload with the request.
 * @param query Optional query parameters to include in the request.
 * @param headers Optional headers to include in the request.
 */
export declare function Process(
  process: `http.Post`,
  url: string,
  payload?: any,
  files?: Record<string, string>,
  query?: Record<string, string> | [string, string][] | Array<Record<string, string>> | string,
  headers?: Record<string, string> | Record<string, string>[],
): HttpResponse;

/**
 * Send a PUT request
 * @param process http.Put
 * @param url string The URL to send the PUT request to.
 * @param payload Optional data to send in the body of the request.
 * @param query Optional query parameters to include in the request.
 * @param headers Optional headers to include in the request.
 */
export declare function Process(
  process: `http.Put`,
  url: string,
  payload?: any,
  query?: Record<string, string> | [string, string][] | Array<Record<string, string>> | string,
  headers?: Record<string, string> | Record<string, string>[],
): HttpResponse;

/**
 * Send a PATCH request
 * @param process http.Patch
 * @param url string The URL to send the PATCH request to.
 * @param payload Optional data to send in the body of the request.
 * @param query Optional query parameters to include in the request.
 * @param headers Optional headers to include in the request.
 */
export declare function Process(
  process: `http.Patch`,
  url: string,
  payload?: any,
  query?: Record<string, string> | [string, string][] | Array<Record<string, string>> | string,
  headers?: Record<string, string> | Record<string, string>[],
): HttpResponse;

/**
 * Send a DELETE request
 * @param process http.Delete
 * @param url string The URL to send the DELETE request to.
 * @param payload Optional data to send in the body of the request.
 * @param query Optional query parameters to include in the request.
 * @param headers Optional headers to include in the request.
 */
export declare function Process(
  process: `http.Delete`,
  url: string,
  payload?: any,
  query?: Record<string, string> | [string, string][] | Array<Record<string, string>> | string,
  headers?: Record<string, string> | Record<string, string>[],
): HttpResponse;

/**
 * Send a HEAD request
 * @param process http.Head
 * @param url string The URL to send the HEAD request to.
 * @param payload Optional data to send in the request.
 * @param query Optional query parameters to include in the request.
 * @param headers Optional headers to include in the request.
 */
export declare function Process(
  process: `http.Head`,
  url: string,
  payload?: any,
  query?: Record<string, string> | [string, string][] | Array<Record<string, string>> | string,
  headers?: Record<string, string> | Record<string, string>[],
): HttpResponse;

/**
 * Send an HTTP request
 * @param process http.Send
 * @param method string The HTTP method to use for the request (e.g., GET, POST, etc.).
 * @param url string The URL to send the request to.
 * @param payload Optional data to send in the body of the request.
 * @param query Optional query parameters to include in the request.
 * @param headers Optional headers to include in the request.
 * @param files Optional files to upload with the request.
 */
export declare function Process(
  process: `http.Send`,
  method: string,
  url: string,
  payload?: any,
  query?: Record<string, string> | [string, string][] | Array<Record<string, string>> | string,
  headers?: Record<string, string> | Record<string, string>[],
  files?: HttpFile[],
): HttpResponse;

/**
 * Stream HTTP request
 * @param process http.Stream
 * @param method string The HTTP method to use for the request (e.g., GET, POST, etc.).
 * @param url string The URL to send the request to.
 * @param handler string The handler process name for streaming data.
 * @param payload Optional data to send in the body of the request.
 * @param query Optional query parameters to include in the request.
 * @param headers Optional headers to include in the request.
 */
export declare function Process(
  process: `http.Stream`,
  method: string,
  url: string,
  handler: string,
  payload?: any,
  query?: Record<string, string> | [string, string][] | Array<Record<string, string>> | string,
  headers?: Record<string, string> | Record<string, string>[],
): any;

