function resetAndImportMenu() {
  Process("scripts.system.db.cleanTable", "system_menu");
  Process("scripts.admin.menu.saveLoadAndSaveMenus");
}
