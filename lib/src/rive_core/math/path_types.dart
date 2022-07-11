/*
 * Copyright 2022 Rive
 */

enum PathFillRule {
  nonZero,
  evenOdd,
}

enum PathDirection {
  clockwise,
  counterclockwise,
}

enum PathVerb {
  move,
  line,
  quad,
  conicUnused, // so we match skia's order
  cubic,
  close,
}
