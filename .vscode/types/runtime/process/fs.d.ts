
export type FileSystemName = "app" | "data" | string;

export interface UploadFile {
  Hash(): string;                 // Returns a unique identifier based on the file hash
  IsChunk(): boolean;             // Determines if the file is part of a larger chunked upload
  Name: string;                   // Original file name
  ChunkFileName(): string;        // Name of the chunk file
  TempFile: string;               // Temporary file path
  UID: string;                    // Unique Identifier for the file
  TotalSize(): number;            // Total size of the file for chunked uploads
  Sync: boolean;                  // Flag to determine if the upload is synchronous
}

export interface UploadProgress {
  Total: number;                  // Total size of the upload
  Uploaded: number;               // Amount uploaded so far
  Completed: boolean;             // Upload completion status
}

/**
 * Read file content
 * @param process fs.${FileSystemName}.ReadFile
 * @param filename string file name relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.ReadFile`,
  filename: string
): string;

/**
 * Read file content as buffer
 * @param process fs.${FileSystemName}.ReadFileBuffer
 * @param filename string file name relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.ReadFileBuffer`,
  filename: string
): Uint8Array;

/**
 * Write file content
 * @param process fs.${FileSystemName}.WriteFile
 * @param filename string file name relative to the root
 * @param content string content to write
 * @param perm number file permissions
 */
export declare function Process(
  process: `fs.${FileSystemName}.WriteFile`,
  filename: string,
  content: string,
  perm?: number
): number;

/**
 * Write file content from buffer
 * @param process fs.${FileSystemName}.WriteFileBuffer
 * @param filename string file name relative to the root
 * @param content Uint8Array content to write
 * @param perm number file permissions
 */
export declare function Process(
  process: `fs.${FileSystemName}.WriteFileBuffer`,
  filename: string,
  content: Uint8Array,
  perm?: number
): number;

/**
 * Append content to file
 * @param process fs.${FileSystemName}.AppendFile
 * @param filename string file name relative to the root
 * @param content string content to append
 * @param perm number file permissions
 */
export declare function Process(
  process: `fs.${FileSystemName}.AppendFile`,
  filename: string,
  content: string,
  perm?: number
): number;

/**
 * Append content to file from buffer
 * @param process fs.${FileSystemName}.AppendFileBuffer
 * @param filename string file name relative to the root
 * @param content Uint8Array content to append
 * @param perm number file permissions
 */
export declare function Process(
  process: `fs.${FileSystemName}.AppendFileBuffer`,
  filename: string,
  content: Uint8Array,
  perm?: number
): number;

/**
 * Insert content into file
 * @param process fs.${FileSystemName}.InsertFile
 * @param filename string file name relative to the root
 * @param offset number position to start the insert
 * @param content string content to insert
 * @param perm number file permissions
 */
export declare function Process(
  process: `fs.${FileSystemName}.InsertFile`,
  filename: string,
  offset: number,
  content: string,
  perm?: number
): number;

/**
 * Insert content into file from buffer
 * @param process fs.${FileSystemName}.InsertFileBuffer
 * @param filename string file name relative to the root
 * @param offset number position to start the insert
 * @param content Uint8Array content to insert
 * @param perm number file permissions
 */
export declare function Process(
  process: `fs.${FileSystemName}.InsertFileBuffer`,
  filename: string,
  offset: number,
  content: Uint8Array,
  perm?: number
): number;

/**
 * Read directory contents
 * @param process fs.${FileSystemName}.ReadDir
 * @param dir string directory path relative to the root
 * @param recursive boolean list directories recursively
 */
export declare function Process(
  process: `fs.${FileSystemName}.ReadDir`,
  dir: string,
  recursive?: boolean
): string[];

/**
 * Perform a glob search
 * @param process fs.${FileSystemName}.Glob
 * @param pattern string glob pattern
 */
export declare function Process(
  process: `fs.${FileSystemName}.Glob`,
  pattern: string
): string[];

/**
 * Create a directory
 * @param process fs.${FileSystemName}.Mkdir
 * @param dir string directory path relative to the root
 * @param perm number directory permissions
 */
export declare function Process(
  process: `fs.${FileSystemName}.Mkdir`,
  dir: string,
  perm?: number
): void;

/**
 * Create a directory and all necessary parents
 * @param process fs.${FileSystemName}.MkdirAll
 * @param dir string directory path relative to the root
 * @param perm number directory permissions
 */
export declare function Process(
  process: `fs.${FileSystemName}.MkdirAll`,
  dir: string,
  perm?: number
): void;

/**
 * Create a temporary directory
 * @param process fs.${FileSystemName}.MkdirTemp
 * @param dir string base directory
 * @param pattern string pattern for the directory name
 */
export declare function Process(
  process: `fs.${FileSystemName}.MkdirTemp`,
  dir?: string,
  pattern?: string
): string;

/**
 * Remove a file or directory
 * @param process fs.${FileSystemName}.Remove
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Remove`,
  name: string
): void;

/**
 * Remove a directory and its contents
 * @param process fs.${FileSystemName}.RemoveAll
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.RemoveAll`,
  name: string
): void;

/**
 * Check existence of a file or directory
 * @param process fs.${FileSystemName}.Exists
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Exists`,
  name: string
): boolean;

/**
 * Check if path is a directory
 * @param process fs.${FileSystemName}.IsDir
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.IsDir`,
  name: string
): boolean;

/**
 * Check if path is a file
 * @param process fs.${FileSystemName}.IsFile
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.IsFile`,
  name: string
): boolean;

/**
 * Check if path is a symbolic link
 * @param process fs.${FileSystemName}.IsLink
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.IsLink`,
  name: string
): boolean;

/**
 * Change file mode
 * @param process fs.${FileSystemName}.Chmod
 * @param name string path relative to the root
 * @param perm number file mode
 */
export declare function Process(
  process: `fs.${FileSystemName}.Chmod`,
  name: string,
  perm: number
): void;

/**
 * Get file size
 * @param process fs.${FileSystemName}.Size
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Size`,
  name: string
): number;

/**
 * Get file mode
 * @param process fs.${FileSystemName}.Mode
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Mode`,
  name: string
): number;

/**
 * Get file modification time
 * @param process fs.${FileSystemName}.ModTime
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.ModTime`,
  name: string
): number;

/**
 * Get base name of a file path
 * @param process fs.${FileSystemName}.BaseName
 * @param name string file path
 */
export declare function Process(
  process: `fs.${FileSystemName}.BaseName`,
  name: string
): string;

/**
 * Get directory name of a file path
 * @param process fs.${FileSystemName}.DirName
 * @param name string file path
 */
export declare function Process(
  process: `fs.${FileSystemName}.DirName`,
  name: string
): string;

/**
 * Get extension of a file
 * @param process fs.${FileSystemName}.ExtName
 * @param name string file path
 */
export declare function Process(
  process: `fs.${FileSystemName}.ExtName`,
  name: string
): string;

/**
 * Get the MIME type of a file
 * @param process fs.${FileSystemName}.MimeType
 * @param name string path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.MimeType`,
  name: string
): string;

/**
 * Move a file
 * @param process fs.${FileSystemName}.Move
 * @param src string source path relative to the root
 * @param dst string destination path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Move`,
  src: string,
  dst: string
): void;

/**
 * Append and move a file
 * @param process fs.${FileSystemName}.MoveAppend
 * @param src string source path relative to the root
 * @param dst string destination path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.MoveAppend`,
  src: string,
  dst: string
): void;

/**
 * Insert and move a file
 * @param process fs.${FileSystemName}.MoveInsert
 * @param src string source path relative to the root
 * @param dst string destination path relative to the root
 * @param offset number position to insert data
 */
export declare function Process(
  process: `fs.${FileSystemName}.MoveInsert`,
  src: string,
  dst: string,
  offset: number
): void;

/**
 * Zip directories
 * @param process fs.${FileSystemName}.Zip
 * @param src string source path relative to the root
 * @param dst string destination path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Zip`,
  src: string,
  dst: string
): void;

/**
 * Unzip a file
 * @param process fs.${FileSystemName}.Unzip
 * @param src string source path relative to the root
 * @param dst string destination path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Unzip`,
  src: string,
  dst: string
): string[];

/**
 * Copy a file
 * @param process fs.${FileSystemName}.Copy
 * @param src string source path relative to the root
 * @param dst string destination path relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Copy`,
  src: string,
  dst: string
): void;

/**
 * Handle file uploads
 * @param process fs.${FileSystemName}.Upload
 * @param file UploadFile upload file information
 * @param props any properties for validation (e.g., maxFilesize, accept)
 */
export declare function Process(
  process: `fs.${FileSystemName}.Upload`,
  file: UploadFile,
  props?: { [key: string]: any }
): string | { path: string; uid: string; progress: UploadProgress };

/**
 * Handle file downloads
 * @param process fs.${FileSystemName}.Download
 * @param file string file to download relative to the root
 */
export declare function Process(
  process: `fs.${FileSystemName}.Download`,
  file: string
): { content: any; type: string };

