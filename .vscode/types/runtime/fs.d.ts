/**
 * Represents the name of a FileSystem.
 * It can be "app", "data" or any custom string.
 */

import type { FileSystemName } from "./process";

/**
 * FS class is a wrapper around the FileSystem interface,
 * providing various file system operations.
 */
export declare class FS {
  /**
   * Create a new instance of FS
   * @param root Root path for the application. should be "app" or "data". "app": the root path of the application, "data": the root path of the data.
   */
  constructor(root: FileSystemName);

  // Check file
  /**
   * Checks if a file or directory exists.
   * @param path - The path to the file or directory.
   */
  Exists(path: string): boolean;

  /**
   * Checks if the given path is a directory.
   * @param path - The path to check.
   */
  IsDir(path: string): boolean;

  /**
   * Checks if the given path is a file.
   * @param path - The path to check.
   */
  IsFile(path: string): boolean;

  /**
   * Checks if the given path is a symbolic link.
   * @param path - The path to check.
   */
  IsLink(path: string): boolean;

  // Basic file operation
  /**
   * Reads the content of a file and returns it as a string.
   * @param path - The path to the file.
   */
  ReadFile(path: string): string;

  /**
   * Reads the content of a file and returns it as a Uint8Array.
   * @param path - The path to the file.
   */
  ReadFileBuffer(path: string): Uint8Array;

  /**
   * Reads the content of a file and returns it as a base64 encoded string.
   * @param path - The path to the file.
   */
  ReadFileBase64(path: string): string;

  /**
   * Reads a file and returns a ReadCloser for streaming.
   * @param path - The path to the file.
   */
  ReadCloser(path: string): ReadableStream<Uint8Array>;

  /**
   * Writes the provided data to a file.
   * @param path - The path to the file.
   * @param data - The data to write.
   * @param perm - The permission mode (optional).
   */
  WriteFile(path: string, data: string, perm?: number): number;

  /**
   * Writes the provided Uint8Array data to a file.
   * @param path - The path to the file.
   * @param data - The data to write.
   * @param perm - The permission mode (optional).
   */
  WriteFileBuffer(path: string, data: Uint8Array, perm?: number): number;

  /**
   * Writes the provided base64 encoded data to a file.
   * @param path - The path to the file.
   * @param data - The base64 encoded data to write.
   * @param perm - The permission mode (optional).
   */
  WriteFileBase64(path: string, data: string, perm?: number): number;

  /**
   * Appends the provided data to a file.
   * @param path - The path to the file.
   * @param data - The data to append.
   * @param perm - The permission mode (optional).
   */
  AppendFile(path: string, data: string, perm?: number): number;

  /**
   * Appends the provided Uint8Array data to a file.
   * @param path - The path to the file.
   * @param data - The data to append.
   * @param perm - The permission mode (optional).
   */
  AppendFileBuffer(path: string, data: Uint8Array, perm?: number): number;

  /**
   * Appends the provided base64 encoded data to a file.
   * @param path - The path to the file.
   * @param data - The base64 encoded data to append.
   * @param perm - The permission mode (optional).
   */
  AppendFileBase64(path: string, data: string, perm?: number): number;

  /**
   * Inserts data into a file at the specified offset.
   * @param path - The path to the file.
   * @param offset - The position to insert the data.
   * @param data - The data to insert.
   * @param perm - The permission mode (optional).
   */
  InsertFile(path: string, offset: number, data: string, perm?: number): number;

  /**
   * Inserts Uint8Array data into a file at the specified offset.
   * @param path - The path to the file.
   * @param offset - The position to insert the data.
   * @param data - The data to insert.
   * @param perm - The permission mode (optional).
   */
  InsertFileBuffer(
    path: string,
    offset: number,
    data: Uint8Array,
    perm?: number
  ): number;

  /**
   * Inserts base64 encoded data into a file at the specified offset.
   * @param path - The path to the file.
   * @param offset - The position to insert the data.
   * @param data - The base64 encoded data to insert.
   * @param perm - The permission mode (optional).
   */
  InsertFileBase64(
    path: string,
    offset: number,
    data: string,
    perm?: number
  ): number;

  /**
   * Removes the specified file or directory.
   * @param path - The path to the file or directory.
   */
  Remove(path: string): void;

  /**
   * Removes a path and any children it contains.
   * @param path - The path to remove.
   */
  RemoveAll(path: string): void;

  // Download
  /**
   * Downloads a file and returns its MIME type and content as a ReadCloser.
   * @param path - The file path.
   */
  Download(path: string): { type: string; content: ReadableStream<Uint8Array> };

  // Directory
  /**
   * Reads a directory and returns an array of its entries.
   * @param path - The directory path.
   * @param recursive - Whether to read recursively (optional).
   */
  ReadDir(path: string, recursive?: boolean): string[];

  /**
   * Creates a new directory with the specified path and permissions.
   * @param path - The path to create.
   * @param perm - The permission mode (optional).
   */
  Mkdir(path: string, perm?: number): void;

  /**
   * Creates a directory along with any necessary parents.
   * @param path - The directory path.
   * @param perm - The permission mode (optional).
   */
  MkdirAll(path: string, perm?: number): void;

  /**
   * Creates a new temporary directory and returns its path.
   * @param path - The directory path.
   * @param pattern - The directory name pattern (optional).
   */
  MkdirTemp(path?: string, pattern?: string): string;

  // File info
  /**
   * Changes the mode of the named file or directory.
   * @param path - The file or directory path.
   * @param mode - The new mode.
   */
  Chmod(path: string, mode: number): void;

  /**
   * Returns the base name of a file or directory path.
   * @param path - The file or directory path.
   */
  BaseName(path: string): string;

  /**
   * Returns the directory name of a path.
   * @param path - The file or directory path.
   */
  DirName(path: string): string;

  /**
   * Returns the extension of the file name.
   * @param path - The file path.
   */
  ExtName(path: string): string;

  /**
   * Returns the MIME type of the file.
   * @param path - The file path.
   */
  MimeType(path: string): string;

  /**
   * Returns the mode of the file or directory.
   * @param path - The file or directory path.
   */
  Mode(path: string): number;

  /**
   * Returns the size in bytes of a file.
   * @param path - The file path.
   */
  Size(path: string): number;

  /**
   * Returns the modification time of the file or directory.
   * @param path - The file or directory path.
   */
  ModTime(path: string): number;

  // File operation
  /**
   * Moves a file or directory.
   * @param src - The source path.
   * @param dest - The destination path.
   */
  Move(src: string, dest: string): void;

  /**
   * Copies a file or directory.
   * @param src - The source path.
   * @param dest - The destination path.
   */
  Copy(src: string, dest: string): void;

  /**
   * Moves a file and appends its content to the destination.
   * @param src - The source file path.
   * @param dest - The destination file path.
   */
  MoveAppend(src: string, dest: string): void;

  /**
   * Moves a file and inserts its content into the destination at the specified offset.
   * @param src - The source file path.
   * @param dest - The destination file path.
   * @param offset - The insert offset.
   */
  MoveInsert(src: string, dest: string, offset: number): void;

  // Directory operation
  /**
   * Resolves an absolute path.
   * @param path - The relative path.
   */
  Abs(path: string): string;

  // Compression
  /**
   * Compresses directory contents into a zip file.
   * @param dir - The directory to compress.
   * @param target - The path of the target zip file.
   */
  Zip(dir: string, target: string): void;

  /**
   * Decompresses a zip file into a target directory.
   * @param zipFile - The zip file path.
   * @param target - The target directory.
   */
  Unzip(zipFile: string, target: string): string[];

  // Glob
  /**
   * Returns an array of paths matching a pattern.
   * @param pattern - The glob pattern.
   */
  Glob(pattern: string): string[];
}
