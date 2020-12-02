type Rule = {
  counts: number[],
  char: string,
  pass: string,
  correctCount: number
}

type Rule2 = {
  pos: number[],
  char: string,
  pass: string
}

export function part1 (input: string[]): number {
  const rules: Rule[] = input.map(r => r.split(' ')).map(rs => ({
    counts: rs[0].split('-').map(Number),
    char: rs[1].replace(':', ''),
    pass: rs[2],
    correctCount: 0
  }))
  rules.forEach(r => r.correctCount = r.pass.length - r.pass.replace(new RegExp(r.char, 'g'), '').length)
  return rules.filter(r => r.counts[0] <= r.correctCount && r.correctCount <= r.counts[1]).length
}

export function part2 (input: string[]): number {
  const rules: Rule2[] = input.map(r => r.split(' ')).map(rs => ({
    pos: rs[0].split('-').map(Number).map(x => x - 1),
    char: rs[1].replace(':', ''),
    pass: rs[2]
  }))

  return rules
    // @ts-expect-error
    .filter(r => r.pass[r.pos[0]] === r.char ^ r.pass[r.pos[1]] === r.char)
    .length
}
