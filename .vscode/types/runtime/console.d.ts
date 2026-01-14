export interface Console {
  /**
   * [MDN Reference](https://developer.mozilla.org/docs/Web/API/console/log_static)
   * @param data Data to log
   */
  log(...data: any[]): void;
}

export declare var console: Console;
