export function part1 (input: number[]): number {
  for (const i of input) {
    for (const j of input) {
      if (i + j === 2020) return i * j
    }
  }
  return 0
}

export function part2 (input: number[]): number {
  for (const i of input) {
    for (const j of input) {
      for (const k of input) {
        if (i + j + k === 2020) return i * j * k
      }
    }
  }
  return 0
}
