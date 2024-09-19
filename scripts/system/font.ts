import { Process } from '@yao/yao';

// yao run scripts.system.font.loadfont2
function loadfont2() {
  const source =
    'https://raw.githubusercontent.com/TOMIVERGARA/vscode-fontawesome-gallery/dev/webviews/data/fontawesome-5/metadata/categories.json';

  const request = Process('http.get', source);
  const jsonData = Process('encoding.base64.Decode', request.data);
  const data = JSON.parse(jsonData);
  const iconArray = [];
  for (const key in data) {
    if (Object.hasOwnProperty.call(data, key)) {
      const icons = data[key]['icons'];

      const label = data[key]['label'];
      for (const Icon of icons) {
        iconArray.push({
          name: Icon,
          category: label,
          source: 'fontawesome',
          version: 5,
        });
      }
    }
  }

  const { columns, values } = Process('utils.arr.split', iconArray);
  Process('scripts.system.db.cleanTable', 'system_font');
  Process('models.system.font.insert', columns, values);
  return { message: '加载成功' };
}

/**
 * yao migrate system.font --reset
 * yao run scripts.system.font.loadfont
 *
 * load the awesome font infomation from github file
 * @returns
 */
function loadfont() {
  //
  // "https://github.com/FortAwesome/Font-Awesome/blob/master/metadata/icons.json";

  const source =
    'https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/metadata/icons.json';
  const request = Process('http.get', source);
  const jsonData = Process('encoding.base64.Decode', request.data);
  const data = JSON.parse(jsonData);
  const iconArray = [];
  for (const key in data) {
    const icon = data[key];

    icon.styles.forEach((style) => {
      let prefix = '';
      switch (style) {
        case 'solid':
          prefix = 'fas fa-';
          break;
        case 'regular':
          prefix = 'far fa-';
          break;
        case 'brands':
          prefix = 'fab fa-';
          break;
        default:
          console.log('Unknow type:', style);
          break;
      }
      const iconObject = {
        icon: prefix + key,
        name: key,
        style: style,
        label: icon.label,
        tag: icon.search?.terms,
        version: icon.changes,
        tag_text: icon.search?.terms?.join(','),
        version_text: icon.changes?.join(','),
      };
      iconArray.push(iconObject);
    });
  }

  const { columns, values } = Process('utils.arr.split', iconArray);
  Process('scripts.system.db.cleanTable', 'system_font');
  Process('models.system.font.insert', columns, values);
  return { message: '加载成功' };
}
