export function part1 (input: string): number {
  const groups = prepareInput(input)

  return groups.map(x => new Set(x)).reduce((total, group) => total + group.size, 0)
}

export function part2 (input: string): number {
  const groups = prepareInput2(input)
  return groups.map(group => {
    const answerSet = new Set()
    group.forEach(g => g.split('').forEach(a => { if (group.filter(p => p.includes(a)).length === group.length) answerSet.add(a) }))
    return answerSet
  }).reduce((total, group) => total + group.size, 0)
}

function prepareInput (input: string): string[] {
  return input.trim().split('\n\n').map(s => s.trim().replace(/\s/g, ''))
}

function prepareInput2 (input: string): string[][] {
  return input.trim().split('\n\n').map(s => s.trim().split('\n'))
}
