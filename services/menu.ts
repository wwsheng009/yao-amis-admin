import { Process } from '@yao/yao';

export function resetMenu() {
  Process('scripts.system.db.cleanTable', 'admin_menu');
}

export function importMenu() {
  Process('scripts.admin.menu.reLoadAndSaveMenus');
}
