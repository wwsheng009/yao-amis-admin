function convertToNestedArray(folderList) {
  // Initialize the root object
  const root = {
    label: "",
    value: "",
    children: [],
  };

  // Iterate through each folder path
  for (const folderPath of folderList) {
    // Split the folder path into individual parts
    const parts = folderPath.split("/").filter((part) => part !== "");

    // Initialize the current node as the root
    let currentNode = root;

    // Iterate through each part of the folder path
    for (const part of parts) {
      // Check if the current part already exists as a child
      let foundNode = currentNode.children.find((node) => node.label === part);

      // If the node does not exist, create a new one
      if (!foundNode) {
        foundNode = {
          label: part,
          value: currentNode.value ? `${currentNode.value}.${part}` : part,
          children: [],
        };
        currentNode.children.push(foundNode);
      }

      // Update the current node to the found node
      currentNode = foundNode;
    }
  }
  removeEmptyChildren(root);
  return root.children;
}

// Usage example
const folderList = [
  "/pages/admin",
  "/pages/api",
  "/pages/api/crud",
  "/pages/api/demo",
  "/pages/model",
  "/pages/studio",
];

function removeEmptyChildren(node) {
  if (node.children.length === 0) {
    delete node.children;
  } else {
    for (const child of node.children) {
      removeEmptyChildren(child);
    }
  }
}

const nestedArray = convertToNestedArray(folderList);
// console.log(JSON.stringify(nestedArray, null, 2));

// yao run scripts.system.file.normalizeFolder "../"
function normalizeFolder(folder) {
  if (folder == null) {
    return "";
  }
  if (typeof folder != "string" && typeof folder != "number") {
    return "";
  }

  // Replace occurrences of "../" and "..\\" with an empty string
  // folder = folder.replace(/(\.\.\/|\.\.\\)/g, "");

  // // Replace occurrences of "./" and ".\\" with an empty string
  // folder = folder.replace(/(\.\/|\.\\)/g, "");

  // folder = folder.replace(/[^\w\s.-]/g, "");
  folder = folder.replace(/\.\./g, "");
  folder = folder.replace(/\/+/g, "/");
  folder = folder.replace(/\\+/g, "/");

  return folder;
}
folder = normalizeFolder("//////");
folder = normalizeFolder("//");

folder = normalizeFolder("\\");
folder = normalizeFolder("\\\\\\\\");

folder = normalizeFolder("../");
folder = normalizeFolder("./");
folder = normalizeFolder("../../");
folder = normalizeFolder("../");
console.log(folder);
