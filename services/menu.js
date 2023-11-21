function resetMenu() {
  Process("scripts.system.db.cleanTable", "system_menu");
}

function importMenu() {
  Process("scripts.admin.menu.reLoadAndSaveMenus");
}
