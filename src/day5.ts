export function part1 (input: string): number {
  const boardingPasses = prepareInput(input)

  return boardingPasses
    .map(findSeatId)
    .sort((x, y) => x > y ? -1 : x < y ? 1 : 0)[0]
}

export function part2 (input: string): number {
  const boardingPasses = prepareInput(input)

  let ids = boardingPasses
    .map(findSeatId)
    .sort((x, y) => x > y ? -1 : x < y ? 1 : 0)

  ids = ids.filter((id, i) => id === ids[i + 1] + 2)

  return ids[0] - 1
}

function prepareInput (input: string): string[][] {
  return input.trim().split('\n').map(s => s.trim().split(''))
}

function findSeatId (boardingPass: string[]): number {
  let rowArray = new Array(128).fill(null).map((_, i) => i)
  let colArray = new Array(8).fill(null).map((_, i) => i)

  for (const command of boardingPass) {
    switch (command) {
      case 'F':
        rowArray = rowArray.slice(0, rowArray.length / 2)
        break
      case 'B':
        rowArray = rowArray.slice(rowArray.length / 2)
        break
      case 'L':
        colArray = colArray.slice(0, colArray.length / 2)
        break
      case 'R':
        colArray = colArray.slice(colArray.length / 2)
        break
    }
  }

  return rowArray[0] * 8 + colArray[0]
}
