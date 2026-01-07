import { reLoadAndSaveMenus } from '@scripts/admin/menu';
import { cleanTable } from '@scripts/system/db';

export function resetMenu() {
  cleanTable('admin_menu');
}

export function importMenu() {
  reLoadAndSaveMenus();
}
