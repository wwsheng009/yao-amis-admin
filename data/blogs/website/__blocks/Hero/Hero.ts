export default {
  label: "Hero",
  category: "Basic",
  attributes: { class: "fa fa-text" },
  content: `
    <div data-gjs-type='Nav'></div>
    <div data-gjs-type='Card'></div>
  `,
  test: (name: string): string => {
    return name;
  },
};
