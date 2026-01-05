import { FS, Process } from '@yao/yao';

/**
 * After loading the application, you can do some initialization operations (optional)
 * @see app.yao afterLoad
 */
export function After(options) {
  if (options.reload) {
    // do some initialization operations when reloading
    console.log(`do some initialization Reload = ${options.reload}`, options);

    // if something goes wrong, you can throw an exception
    // throw new Exception("After Load Exception", 400);

    return;
  }
  // do some initialization operations when loading
  console.log(`do some initialization Reload = ${options.reload}`, options);

  // if something goes wrong, you can throw an exception
  // throw new Exception("After Load Exception", 400);

  // Setup default roles if not exists
  SetupRoles();
  SetupTypes();
}

function SetupRoles() {
  const fs = new FS('data');
  const raw = fs.ReadFile('roles/roles.json');
  const roles = JSON.parse(raw);
  console.log(`Setting up ${roles.length} roles`);
  for (const role of roles) {
    const id = role.role_id;
    // Check if the role already exists
    const exists = Process('models.__yao.role.Get', {
      wheres: [{ column: 'role_id', value: id }]
    });
    if (exists.length > 0) {
      continue;
    }

    Process('models.__yao.role.Create', role);
    console.log(`Created role: ${id}`);
  }
}

function SetupTypes() {
  const fs = new FS('data');
  const raw = fs.ReadFile('types/types.json');
  const types = JSON.parse(raw);
  console.log(`Setting up ${types.length} user types`);
  for (const type of types) {
    const id = type.type_id;
    // Check if the type already exists
    const exists = Process('models.__yao.user.type.Get', {
      wheres: [{ column: 'type_id', value: id }]
    });
    if (exists.length > 0) {
      continue;
    }

    Process('models.__yao.user.type.Create', type);
    console.log(`Created user type: ${id} (${type.name})`);
  }
}
