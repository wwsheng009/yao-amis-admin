export function isInteger(value: any): boolean {
  if (typeof value === 'number') {
    return Number.isInteger(value);
  }
  if (typeof value === 'string') {
    const parsed = Number(value);
    return !isNaN(parsed) && Number.isInteger(parsed);
  }
  return false;
}

export function isFloat(value: any): boolean {
  if (typeof value === 'number') {
    return !Number.isInteger(value);
  }
  if (typeof value === 'string') {
    const parsed = Number(value);
    return !isNaN(parsed) && !Number.isInteger(parsed);
  }
  return false;
}
