type Slope = {
  x: number,
  y: number
}

export function traverse (input: string, slope: Slope): number {
  const field = prepareInput(input)
  let treeCounter = 0
  const pos = { x: 0, y: 0 }
  while (pos.y + slope.y < field.length) {
    pos.x = (pos.x + slope.x) % field[0].length
    pos.y += slope.y
    if (field[pos.y][pos.x] === '#') treeCounter++
  }
  return treeCounter
}

function prepareInput (input: string): string[] {
  return input.trim().split('\n').map(l => l.trim())
}
