// i have data struct like below
const data = [
  {
    id: 1,
    children: [
      {
        id: 2,
      },
      {
        id: 21,
      },
      {
        id: 3,
        children: [
          {
            id: 4,
          },
          {
            id: 6,
          },
          {
            id: 7,
            children: [
              {
                id: 16,
              },
              {
                id: 17,
                children: [
                  {
                    id: 18,
                  },
                ],
              },
            ],
          },
        ],
      },
    ],
  },
];

//   filter id = 17,6  and get its parent,and children,remove other items not in the tree,the result shold be below

const exptected = [
  {
    id: 1,
    children: [
      {
        id: 3,
        children: [
          {
            id: 6,
          },
          {
            id: 7,
            children: [
              {
                id: 17,
                children: [
                  {
                    id: 18,
                  },
                ],
              },
            ],
          },
        ],
      },
    ],
  },
];

/**
 * filter the array with function
 * @param {Array} dataArray data array to filter
 * @param {function} func filter function return true
 * @returns Array
 */
function filterTreeDataWithFun(dataArray, func) {
  return dataArray.reduce((acc, item) => {
    // Check if the current node or its children match the filter condition
    const includesFilter =
      func(item) ||
      (item.children && filterTreeDataWithFun(item.children, func).length > 0);
    if (includesFilter) {
      if (func(item)) {
        // 直接包含所有的子节点
        acc.push({ ...item });
      } else {
        const filteredChildren = item.children
          ? filterTreeDataWithFun(item.children, func)
          : undefined;
        if (filteredChildren !== undefined) {
          acc.push({ ...item, children: filteredChildren });
        } else {
          acc.push({ ...item });
        }
      }
    }
    return acc;
  }, []);
}

function filterTreeDataById(data, filterIds) {
  return data.reduce((acc, item) => {
    // Check if the current node or its children match the filter condition
    const includesFilter =
      filterIds.includes(item.id) ||
      (item.children &&
        filterTreeDataById(item.children, filterIds).length > 0);
    if (includesFilter) {
      if (filterIds.includes(item.id)) {
        acc.push({ ...item });
      } else {
        const filteredChildren = item.children
          ? filterTreeDataById(item.children, filterIds)
          : undefined;
        if (filteredChildren !== undefined) {
          acc.push({ ...item, children: filteredChildren });
        } else {
          acc.push({ ...item });
        }
      }
    }
    return acc;
  }, []);
}

function areObjectsEqual(obj1, obj2) {
  // Check if both objects are of type object
  if (typeof obj1 !== 'object' || typeof obj2 !== 'object') {
    return false;
  }

  // Get the keys of the objects
  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);

  // Check if the number of properties is the same
  if (keys1.length !== keys2.length) {
    return false;
  }

  // Iterate over the keys and compare the values
  for (const key of keys1) {
    // Check if the current key exists in both objects
    if (!obj2.hasOwnProperty(key)) {
      return false;
    }

    // Recursively compare nested objects
    if (typeof obj1[key] === 'object' && typeof obj2[key] === 'object') {
      if (!areObjectsEqual(obj1[key], obj2[key])) {
        return false;
      }
    } else {
      // Compare the values of non-nested properties
      if (obj1[key] !== obj2[key]) {
        return false;
      }
    }
  }

  // Objects are considered equal
  return true;
}
function collectFields(data, field) {
  const fields = [];

  // Recursive function to traverse the object
  function traverse(obj) {
    if (typeof obj === 'object') {
      if (obj.hasOwnProperty(field)) {
        fields.push(obj[field]);
      }

      for (const key in obj) {
        traverse(obj[key]);
      }
    }
  }

  traverse(data);

  return fields;
}

const filterIds = [17, 6];
const result = filterTreeDataById(data, filterIds);

console.log('equal?:', areObjectsEqual(exptected, result));

const isObj1EqualToObj2 = JSON.stringify(exptected) === JSON.stringify(result);

if (isObj1EqualToObj2 !== true) {
  throw new Error('Not Match');
}

const result1 = filterTreeDataWithFun(data, (item) =>
  filterIds.includes(item.id),
);
const isObj1EqualToObj3 = areObjectsEqual(exptected, result1);
if (isObj1EqualToObj3 !== true) {
  throw new Error('Not Match');
}
const ids = collectFields(data, 'id');
console.log('ids', ids);
