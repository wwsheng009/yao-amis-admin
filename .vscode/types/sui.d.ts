// TypeScript Declarations for YAO Pure JavaScript SDK
// Author: Max <max@iqka.com>
// Maintainer: https://yaoapps.com

/**
 * The data fetched from the server.
 */
export declare const __sui_data: Record<string, any>;

/**
 * The localized messages and settings.
 */
export declare function __m(message: string): string;

// @ts-ignore: Ignore the specific error
export declare const arguments: any[] = [];

/**
 * Headers object for requests.
 */
export type Headers =
  | Record<string, string>
  | Record<string, string | string[]>;

/**
 * Localized messages and settings interface.
 */
export declare interface Locale {
  /**
   * Locale name, e.g., "en-US".
   */
  name?: string;

  /**
   * Key-value pairs for translations.
   */
  keys?: Record<string, string>;

  /**
   * Message templates or labels.
   */
  messages?: Record<string, string>;

  /**
   * Text direction (left-to-right or right-to-left).
   */
  direction?: "ltr" | "rtl";

  /**
   * Timezone, formatted as UTC offsets (e.g., "+05:30").
   */
  timezone?:
    | "-12:00"
    | "-11:00"
    | "-10:00"
    | "-09:30"
    | "-09:00"
    | "-08:00"
    | "-07:00"
    | "-06:00"
    | "-05:00"
    | "-04:30"
    | "-04:00"
    | "-03:30"
    | "-03:00"
    | "-02:00"
    | "-01:00"
    | "+00:00"
    | "+01:00"
    | "+02:00"
    | "+03:00"
    | "+03:30"
    | "+04:00"
    | "+04:30"
    | "+05:00"
    | "+05:30"
    | "+05:45"
    | "+06:00"
    | "+06:30"
    | "+07:00"
    | "+08:00"
    | "+08:45"
    | "+09:00"
    | "+09:30"
    | "+10:00"
    | "+10:30"
    | "+11:00"
    | "+12:00"
    | "+12:45"
    | "+13:00"
    | "+14:00";
}

/**
 * Component type definition for modular UI components.
 */
export declare type Component = {
  /**
   * The root HTML element of the component.
   */
  root: HTMLElement;

  /**
   * Component state management interface.
   */
  state: ComponentState;

  /**
   * Component store for state persistence.
   */
  store: ComponentStore;

  /**
   * Query object for DOM traversal and manipulation.
   */
  $root: SUIQuery;

  /**
   * Find an element inside the component.
   */
  find: (selector: string | HTMLElement) => SUIQuery | null;

  /**
   * Query a single matching element.
   */
  query: (selector: string) => HTMLElement | null;

  /**
   * Query all matching elements.
   */
  queryAll: (selector: string) => NodeListOf<Element> | null;

  /**
   * Emit an event.
   */
  emit: (name: string, detail?: EventData) => void;

  /**
   * Render a partial view with data.
   */
  render: (
    name: string,
    data: Record<string, any>,
    option?: RenderOption
  ) => Promise<string>;

  /**
   * Optional lifecycle method called once.
   */
  once?: () => void;

  /**
   * State watchers for reactive updates.
   */
  watch?: Record<string, (value?: any) => void>;

  /**
   * Optional constants for the component.
   */
  Constants?: Record<string, any>;

  [key: string]: any;
};

/**
 * Options for rendering components.
 */
export declare type RenderOption = {
  /**
   * Target container for rendering.
   */
  target?: HTMLElement;

  /**
   * Show loader during rendering.
   */
  showLoader?: HTMLElement | string | boolean;

  /**
   * Whether to replace the existing content.
   */
  replace?: boolean;

  /**
   * Whether to include page data in rendering.
   */
  withPageData?: boolean;
};

/**
 * Interface for managing component state.
 */
export declare type ComponentState = {
  /**
   * Set a state property.
   */
  Set: (key: string, value?: any) => void;
};

/**
 * Interface for managing component store data.
 */
export declare type ComponentStore = {
  /**
   * Get a value by key.
   */
  Get: (key: string) => string;

  /**
   * Set a value by key.
   */
  Set: (key: string, value: string) => void;

  /**
   * Get JSON data by key.
   */
  GetJSON: (key: string) => any;

  /**
   * Set JSON data by key.
   */
  SetJSON: (key: string, value: any) => void;

  /**
   * Retrieve all data.
   */
  GetData: () => Record<string, any>;
};

/**
 * Helper function to retrieve a component by root element or selector.
 */
export declare const $$: (selector: HTMLElement | string) => Component;

/**
 * Data structure for event details.
 */
export declare type EventDetail<T = HTMLElement> = {
  /**
   * Root element of the component.
   */
  rootElement: HTMLElement;

  /**
   * Event target element.
   */
  targetElement: T;
};

/**
 * Generic type for event data.
 */
export declare type EventData = Record<string, any>;

/**
 * State object for event propagation.
 */
export declare type State = {
  /**
   * Target element.
   */
  target: HTMLElement;

  /**
   * Stop event propagation.
   */
  stopPropagation(): void;
};

/**
 * Create a rendering instance for a component.
 */
export declare function $Render(
  component: Component | string,
  option?: RenderOption
): SUIRender;

/**
 * Class representing a rendering operation for components.
 */
export declare class SUIRender {
  /**
   * Create a rendering instance.
   */
  constructor(comp: Component | string, option?: RenderOption);

  /**
   * Execute a partial view render with provided data.
   */
  Exec(name: string, data: Record<string, any>): Promise<string>;
}

/**
 * Get the store associated with an element or selector.
 */
export declare function $Store(
  selector: HTMLElement | string
): ComponentStore | null;

/**
 * Query the DOM for an element or elements.
 */
export declare function $Query(selector: string | HTMLElement): SUIQuery;

/**
 * Class for DOM manipulation and traversal.
 */
export declare class SUIQuery {
  /**
   * The selector or element used for querying.
   */
  selector: string | Element;

  /**
   * The current element or null.
   */
  element: Element | null;

  /**
   * All matched elements or null.
   */
  elements: NodeListOf<Element> | null;

  /**
   * Create a query instance.
   */
  constructor(selector: string | Element);

  /**
   * Iterate over elements.
   */
  each(callback: (element: SUIQuery, index: number) => void): void;

  /**
   * Get the current element.
   */
  elm(): Element | null;

  /**
   * Get all matched elements.
   */
  elms(): NodeListOf<Element> | null;

  /**
   * Find child elements by selector.
   */
  find(selector: string): SUIQuery | null;

  /**
   * Find the closest matching ancestor.
   */
  closest(selector: string): SUIQuery | null;

  /**
   * Add event listener.
   */
  on(event: string, callback: (event: Event) => void): SUIQuery;

  /**
   * Get the associated component.
   */
  $$(): Component | null;

  /**
   * Get the associated store.
   */
  store(): ComponentStore | null;

  /**
   * Get an attribute value.
   */
  attr(name: string): string | null;

  /**
   * Get data-attribute value.
   */
  data(name: string): string | null;

  /**
   * Get JSON data.
   */
  json(name: string): any | null;

  /**
   * Check if the element has a class.
   */
  hasClass(className: string): boolean;

  /**
   * Get a property value.
   */
  prop(name: string): any | null;

  /**
   * Remove classes.
   */
  removeClass(className: string | string[]): SUIQuery;

  /**
   * Toggle classes.
   */
  toggleClass(className: string | string[]): SUIQuery;

  /**
   * Add classes.
   */
  addClass(className: string | string[]): SUIQuery;

  /**
   * Get or set inner HTML.
   */
  html(html?: string): SUIQuery | string;
}

/**
 * Create a backend request handler for calling APIs.
 */
export declare function $Backend<T = any>(
  route?: string,
  headers?: Headers
): SUIBackend<T>;

/**
 * Class for backend API calls.
 */
export declare class SUIBackend<T = any> {
  /**
   * Create a backend instance.
   */
  constructor(route?: string, headers?: Headers);

  /**
   * Call a backend API method with arguments.
   */
  Call(method: string, ...args: any): Promise<T>;
}

/**
 * Class for handling YAO API interactions.
 */
export declare class Yao {
  /**
   * Initialize Yao API client.
   */
  constructor(host?: string);

  /**
   * Perform a GET request.
   */
  Get(path: string, params?: object, headers?: Headers): Promise<any>;

  /**
   * Perform a POST request.
   */
  Post(
    path: string,
    data?: object,
    params?: object,
    headers?: Headers
  ): Promise<any>;

  /**
   * Download a file from the API.
   */
  Download(
    path: string,
    params: object,
    savefile: string,
    headers?: Headers
  ): Promise<void>;

  /**
   * Perform a fetch request to the API.
   */
  Fetch(
    method: string,
    path: string,
    params?: object,
    data?: object,
    headers?: Headers,
    isblob?: boolean
  ): Promise<any>;

  /**
   * Get the stored token.
   */
  Token(): string;

  /**
   * Get a cookie value.
   */
  Cookie(cookieName: string): string | null;

  /**
   * Set a cookie.
   */
  SetCookie(cookieName: string, cookieValue: string, expireDays?: number): void;

  /**
   * Delete a cookie.
   */
  DeleteCookie(cookieName: string): void;
}
