interface Passport {
  byr?: string,
  iyr?: string,
  eyr?: string,
  hgt?: string,
  hcl?: string,
  ecl?: string,
  pid?: string,
  cid?: string
}

export function part1 (input: string): number {
  const data = prepareInput(input)
  return data.filter(p => p.ecl != null && p.byr != null && p.eyr != null && p.hcl != null && p.hgt != null && p.iyr != null && p.pid != null).length
}

export function part2 (input: string): number {
  const data = prepareInput(input)
  return data
    .filter(p => p.ecl != null && p.byr != null && p.eyr != null && p.hcl != null && p.hgt != null && p.iyr != null && p.pid != null)
    .filter(p => validateYear(p.byr!, 1920, 2002) &&
      validateYear(p.iyr!, 2010, 2020) &&
      validateYear(p.eyr!, 2020, 2030) &&
      validateHeight(p.hgt!) &&
      validateColor(p.hcl!) &&
      validateEyeColor(p.ecl!) &&
      validatePid(p.pid!)
    ).length
}

function prepareInput (input: string): Passport[] {
  return input.split('\n\n').map(p =>
    p.trim().split(/\s/).reduce((pass, field) => ({
      ...pass,
      [field.trim().split(':')[0]]: field.trim().split(':')[1]
    }), {})
  )
}

export function validateYear (year: string, min: number, max: number): boolean {
  return year.length === 4 && Boolean(year.match(/\d{4}/)) && +year >= min && +year <= max
}

export function validateColor (color: string): boolean {
  return color.length === 7 && color[0] === '#' && Boolean(color.slice(1).match(/(\d|[a-f]){6}/))
}

export function validateHeight (height: string): boolean {
  if (!height.match(/\d+(cm|in)/)) return false
  const unit = height.slice(height.length - 2)
  const value = +height.slice(0, height.length - 2)
  if (unit === 'cm') {
    return value >= 150 && value <= 193
  }
  if (unit === 'in') {
    return value >= 59 && value <= 76
  }
  return false
}

export function validateEyeColor (color: string): boolean {
  return ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].indexOf(color) >= 0
}

export function validatePid (pid: string): boolean {
  return pid.length === 9 && Boolean(pid.match(/\d{9}/))
}
