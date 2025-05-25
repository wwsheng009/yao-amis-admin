import { Locale } from '@yao/sui';
import { Process, time } from '@yaoapps/client';

export function Default(
  locale: string,
  data: Locale,
  route: string,
  tmpl: string,
  retry: number = 1
): Locale {
  const payload = {
    messages: data.messages || {},
    language: locale
  };

  if (Object.keys(payload.messages).length === 0) {
    console.log(`No translation ${route}`);
    return data;
  }

  if (retry > 3) {
    console.log(`Failed to translate ${route} with ${locale} locale`);
    return data;
  }

  console.log(
    `Translating ${route} with ${locale} locale ${
      retry > 1 ? `(${retry})` : ''
    }`
  );
  const res = Process('aigcs.translate', JSON.stringify(payload));
  try {
    const translated = JSON.parse(res);
    if (translated.messages) {
      return {
        keys: data.keys,
        messages: translated.messages
      };
    }

    time.Sleep(200);
    return Default(locale, data, route, tmpl, retry + 1);
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
  } catch (e) {
    time.Sleep(200);
    return Default(locale, data, route, tmpl, retry + 1);
  }
}
