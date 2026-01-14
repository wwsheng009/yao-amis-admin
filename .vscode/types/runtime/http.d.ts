import { HttpFile, HttpResponse } from "./process";

/**
 * Interface for the HTTP operations.
 * Provides methods to make HTTP requests using various methods like GET, POST, etc.
 */
export interface HTTP {
  /**
   * Sends a GET request.
   * @param url - The URL to send the request to.
   * @param query - Optional query parameters.
   * @param headers - Optional headers for the request.
   * @returns HttpResponse - The HTTP response from the GET request.
   */
  Get(
    url: string,
    query?:
      | Record<string, string>
      | [string, string][]
      | Array<Record<string, string>>
      | string,
    headers?: Record<string, string> | Record<string, string>[]
  ): HttpResponse;

  /**
   * Sends a POST request.
   * @param url - The URL to send the request to.
   * @param payload - Optional payload for the POST request.
   * @param files - Optional files for multipart/form-data requests.
   * @param query - Optional query parameters.
   * @param headers - Optional headers for the request.
   * @returns HttpResponse - The HTTP response from the POST request.
   */
  Post(
    url: string,
    payload?: any,
    files?: Record<string, string>,
    query?:
      | Record<string, string>
      | [string, string][]
      | Array<Record<string, string>>
      | string,
    headers?: Record<string, string> | Record<string, string>[]
  ): HttpResponse;

  /**
   * a PUT request.
   * @param url - The URL to send the request to.
   * @param payload - Optional payload for the PUT request.
   * @param query - Optional query parameters.
   * @param headers - Optional headers for the request.
   * @returns HttpResponse - The HTTP response from the PUT request.
   */
  Put(
    url: string,
    payload?: any,
    query?:
      | Record<string, string>
      | [string, string][]
      | Array<Record<string, string>>
      | string,
    headers?: Record<string, string> | Record<string, string>[]
  ): HttpResponse;

  /**
   * Sends a PATCH request.
   * @param url - The URL to send the request to.
   * @param payload - Optional payload for the PATCH request.
   * @param query - Optional query parameters.
   * @param headers - Optional headers for the request.
   * @returns HttpResponse - The HTTP response from the PATCH request.
   */
  Patch(
    url: string,
    payload?: any,
    query?:
      | Record<string, string>
      | [string, string][]
      | Array<Record<string, string>>
      | string,
    headers?: Record<string, string> | Record<string, string>[]
  ): HttpResponse;

  /**
   * Sends a DELETE request.
   * @param url - The URL to send the request to.
   * @param payload - Optional payload for the DELETE request.
   * @param query - Optional query parameters.
   * @param headers - Optional headers for the request.
   * @returns HttpResponse - The HTTP response from the DELETE request.
   */
  Delete(
    url: string,
    payload?: any,
    query?:
      | Record<string, string>
      | [string, string][]
      | Array<Record<string, string>>
      | string,
    headers?: Record<string, string> | Record<string, string>[]
  ): HttpResponse;

  /**
   * Sends an HTTP request with a specified method.
   * @param method - The HTTP method to use (GET, POST, PUT, etc.).
   * @param url - The URL to send the request to.
   * @param payload - Optional payload for the request.
   * @param query - Optional query parameters.
   * @param headers - Optional headers for the request.
   * @param files - Optional files for multipart requests.
   * @returns HttpResponse - The HTTP response from the request.
   */
  Send(
    method: string,
    url: string,
    payload?: any,
    query?:
      | Record<string, string>
      | [string, string][]
      | Array<Record<string, string>>
      | string,
    headers?: Record<string, string> | Record<string, string>[],
    files?: HttpFile[]
  ): HttpResponse;

  /**
   * Streams the HTTP response.
   * @param method - The HTTP method to use (GET, POST, PUT, etc.).
   * @param url - The URL to send the request to.
   * @param callback - Callback function to handle stream data.
   * @param payload - Optional payload for the request.
   * @param query - Optional query parameters.
   * @param headers - Optional headers for the request.
   * @returns void
   */
  Stream(
    method: string,
    url: string,
    callback: (data: string) => number,
    payload?: any,
    query?:
      | Record<string, string>
      | [string, string][]
      | Array<Record<string, string>>
      | string,
    headers?: Record<string, string> | Record<string, string>[]
  ): void;
}

export interface UploadFile {
  /**
   * Content-Uid: The unique identifier of the file (for chunk upload)
   */
  uid?: string;

  /**
   * Content-Range: bytes start-end/total (for chunk upload)
   */
  range?: string;

  /**
   * Content-Sync: sync upload or not. Default is false (for chunk upload)
   */
  sync?: boolean;

  /**
   * The name of the file
   */
  name: string;

  /**
   * The temporary file path
   */
  tempFile: string;

  /**
   * The size of the file
   */
  size: number;

  /**
   * The MIME type of the file
   */
  header: { [key: string]: string[] }; // Equivalent to textproto.MIMEHeader in Go

  /**
   * Error message
   */
  error?: string;
}

export interface UploadProgress {
  /**
   * Total bytes to upload
   */
  total: number;

  /**
   * Bytes uploaded
   */
  uploaded: number;

  /**
   * Upload is completed
   */
  completed: boolean;
}

/**
 * Upload File Response
 */
export type UploadFileResponse =
  | string
  | {
      /**
       * File path or URL
       */
      path: string; // File path

      /**
       * Upload progress
       */
      progress?: UploadProgress;

      /**
       * Content-Uid: The unique identifier of the file (for chunk upload)
       */
      uid?: string;

      /**
       * additional information, can be used to previewURL, etc.
       */
      [key: string]: any;
    };
/**
 * Http Exception
 */
export type HttpException = {
  /**
   * The error code.
   */
  code: number;

  /**
   * The error message.
   */
  message: string;
};

/**
 * Declaration of the HTTP object.
 */
export declare var http: HTTP;
