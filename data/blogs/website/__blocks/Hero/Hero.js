export default {
  label: "Hero",
  attributes: { class: "fa fa-text" },
  content: `
      <div data-gjs-type='Nav'></div>
      <div data-gjs-type='Card'></div>
    `,
  test: (name) => {
    return name;
  },
};
