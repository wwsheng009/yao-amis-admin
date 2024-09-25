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
