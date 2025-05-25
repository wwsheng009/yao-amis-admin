function Hello() {
  console.log(__m('system failed to start') + name);
  console.log(__m("system start success") + name);
}

function Index() {
  return {
    title: 'Customers',
    rows: [
      { name: 'John', age: 30, city: 'New York' },
      { name: 'Mary', age: 20, city: 'Paris' },
      { name: 'Peter', age: 40, city: 'London' }
    ]
  };
}
