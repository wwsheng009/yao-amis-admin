export interface PermissionFolder {
  operation: string[];
  folderValue?: string;
  folder?: {
    label: string;
    value: string;
    chidren: PermissionFolder[];
  };
}
export interface PermissionRoute {
  operation: string[];
  route: string;
}
export interface PermissionModel {
  operation: string[];
  model: string;
}

export interface Permission {
  id: number;
  name: string;
  desc: string;
  parent: number;
  routes?: PermissionRoute[];
  models?: PermissionModel[];
  folders?: PermissionFolder[];
}

export interface AuthMapObj {
  [key: string]: any;
}

export interface AuthObject {
  api: AuthRoute;
  menus: number[];
  folder: AuthFolder;
  model: AuthModel;
}
export interface AuthFolder {
  folder_list: PermissionFolder[];
  folder_with_method: AuthMapObj;
  method_with_folder: AuthMapObj;
}
export interface AuthModel {
  model_list: PermissionModel[];
  model_with_method: AuthMapObj;
  method_with_model: AuthMapObj;
}
export interface AuthRoute {
  api_list: PermissionRoute[];
  api_with_method: AuthMapObj;
  method_with_api: AuthMapObj;
}
