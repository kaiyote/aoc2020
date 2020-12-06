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

function prepareInput (input: string): string[] {
  return input.trim().split('\n').map(s => s.trim())
}

function findSeatId (boardingPass: string): number {
  return Number.parseInt(boardingPass.replace(/(F|L)/g, '0').replace(/(B|R)/g, '1'), 2)
}
