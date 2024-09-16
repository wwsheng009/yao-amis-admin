function resetMenu() {
  Process('scripts.system.db.cleanTable', 'admin_menu');
}

function importMenu() {
  Process('scripts.admin.menu.reLoadAndSaveMenus');
}
