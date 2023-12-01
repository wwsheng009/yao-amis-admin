function parseUrl(urlString) {
  const url = {};

  // parse query string into query object
  const query = {};
  let queryParams = "";
  if (urlString.indexOf("?") !== -1) {
    queryParams = urlString.slice(urlString.indexOf("?") + 1);
  }
  queryParams.split("&").forEach((param) => {
    const [key, value] = param.split("=");
    const decodedKey = decodeURIComponent(key);
    const decodedValue = decodeURIComponent(value);
    if (query.hasOwnProperty(decodedKey)) {
      if (Array.isArray(query[decodedKey])) {
        query[decodedKey].push(decodedValue);
      } else {
        query[decodedKey] = [query[decodedKey], decodedValue];
      }
    } else {
      // 总是设置成数组，与yao的解析保持一致。
      query[decodedKey] = [decodedValue];
    }
  });

  // parse schema, hostname, port, and path
  let urlWithoutQuery = urlString;
  if (queryParams.length !== 0) {
    urlWithoutQuery = urlString.slice(0, urlString.indexOf("?"));
  }
  if (urlWithoutQuery.indexOf("://") !== -1) {
    url.schema = urlWithoutQuery.slice(0, urlWithoutQuery.indexOf("://"));
    urlWithoutQuery = urlWithoutQuery.slice(url.schema.length + 3);
  }
  let port = "";
  if (urlWithoutQuery.indexOf(":") !== -1) {
    const parts = urlWithoutQuery.split(":");
    url.hostname = parts[0];
    port = parts[1];
  } else {
    url.hostname = "";
  }
  if (port.indexOf("/") !== -1) {
    port = port.slice(0, port.indexOf("/"));
  }
  url.port = port;
  let path = "";
  if (urlWithoutQuery.indexOf("/") !== -1) {
    path = urlWithoutQuery.slice(urlWithoutQuery.indexOf("/"));
    if (path.indexOf("?") !== -1) {
      path = path.slice(0, path.indexOf("?"));
    }
  }
  if (path === "" && urlWithoutQuery.indexOf("/") === -1) {
    path = urlWithoutQuery;
  }
  url.path = path;

  // return URL object
  url.query = query;
  return url;
}
// const url1 =
//   "https://www.example.com:8080/path/to/page?param1=value1&param2=value2&param2=value3";
// const parsedUrl1 = parseUrl(url1);
// console.log(parsedUrl1);

// const url2 = "/path/to/page?param1=value1&param2=value2&param2=value3";
// const parsedUrl2 = parseUrl(url2);
// console.log(parsedUrl2);

// const url3 = ":8080/path/to/page?param1=value1&param2=value2";
// const parsedUrl3 = parseUrl(url3);
// console.log(parsedUrl3);

// const url4 = "?param1=value1&param2=value2";
// const parsedUrl4 = parseUrl(url4);
// console.log(parsedUrl4);

// const url5 = "table?$select=browser,engine,id,platform,version&$skip=0&$top=10";
// const parsedUrl5 = parseUrl(url5);
// console.log(parsedUrl5);

module.exports = { parseUrl };
