const fs = require("fs");
const initRiveText = require("../build/bin/debug/rive_text.js");

test("load render font", async () => {
  const riveText = await initRiveText();
  const fontBytes = fs.readFileSync("../test/assets/RobotoFlex.ttf");
  const font = riveText.makeFont(fontBytes);
  expect(font).not.toBe(0);
  riveText.deleteFont(font);
});

const move = 0;
const line = 1;
const quad = 2;
const cubic = 4;
const close = 5;

// function toGlyphBuffer(module, glyph) {
//   const verbCount = glyph[3];
//   const ptsPtr = glyph[1];
//   const verbPtr = glyph[2];
//   const verbs = module.HEAPU8.subarray(verbPtr, verbPtr + verbCount);

//   let pointCount = 0;
//   for (const verb of verbs) {
//     switch (verb) {
//       case move:
//       case line:
//         pointCount++;
//         break;
//       case quad:
//         pointCount += 2;
//         break;
//       case cubic:
//         pointCount += 3;
//         break;
//       default:
//         break;
//     }
//   }

//   const ptsStart = ptsPtr / 4;
//   return {
//     rawPath: glyph[0],
//     verbs: verbs,
//     points: module.HEAPF32.subarray(ptsStart, ptsStart + pointCount * 2),
//   };
// }

test("sanity checks", async () => {
  const riveText = await initRiveText();
  riveText.assertSomeAssumptions();
});

test("load glyph from font", async () => {
  const riveText = await initRiveText();
  const fontBytes = fs.readFileSync("../test/assets/RobotoFlex.ttf");
  const font = riveText.makeFont(fontBytes);

  const glyph = riveText.makeGlyphPath(font, 222);
  // const glyphBuffer = toGlyphBuffer(riveText, glyph);

  const expectedVerbs = new Uint8Array([
    move,
    quad,
    quad,
    quad,
    quad,
    line,
    line,
    line,
    line,
    quad,
    quad,
    quad,
    quad,
    line,
    quad,
    quad,
    quad,
    quad,
    line,
    quad,
    quad,
    quad,
    quad,
    line,
    close,
    move,
    line,
    quad,
    quad,
    quad,
    quad,
    line,
    quad,
    quad,
    quad,
    quad,
    close,
    move,
    quad,
    quad,
    quad,
    quad,
    line,
    quad,
    quad,
    quad,
    quad,
    line,
    close,
  ]);
  expect(glyph.verbs).toStrictEqual(expectedVerbs);

  const expectedPoints = new Float32Array([
    0.060546875, 0.138671875, 0.09765625, 0.1708984375, 0.1513671875,
    0.19189453125, 0.205078125, 0.212890625, 0.2685546875, 0.212890625,
    0.37109375, 0.212890625, 0.43505859375, 0.1552734375, 0.4990234375,
    0.09765625, 0.4990234375, -0.009765625, 0.4990234375, -0.513671875,
    0.4169921875, -0.513671875, 0.4130859375, -0.44677734375, 0.41015625,
    -0.44677734375, 0.390625, -0.478515625, 0.350341796875, -0.5009765625,
    0.31005859375, -0.5234375, 0.25634765625, -0.5234375, 0.15869140625,
    -0.5234375, 0.10009765625, -0.4501953125, 0.04150390625, -0.376953125,
    0.04150390625, -0.2646484375, 0.04150390625, -0.2490234375, 0.04150390625,
    -0.13671875, 0.10009765625, -0.0634765625, 0.15869140625, 0.009765625,
    0.25634765625, 0.009765625, 0.31005859375, 0.009765625, 0.347900390625,
    -0.009521484375, 0.3857421875, -0.02880859375, 0.408203125, -0.060546875,
    0.408203125, -0.009765625, 0.408203125, 0.05859375, 0.3701171875,
    0.09619140625, 0.33203125, 0.1337890625, 0.26611328125, 0.1337890625,
    0.21728515625, 0.1337890625, 0.17822265625, 0.114501953125, 0.13916015625,
    0.09521484375, 0.11767578125, 0.0703125, 0.060546875, 0.138671875,
    0.13427734375, -0.2490234375, 0.13427734375, -0.2646484375, 0.13427734375,
    -0.3427734375, 0.16845703125, -0.39599609375, 0.20263671875, -0.44921875,
    0.27587890625, -0.44921875, 0.32470703125, -0.44921875, 0.35888671875,
    -0.42236328125, 0.39306640625, -0.3955078125, 0.408203125, -0.361328125,
    0.408203125, -0.15234375, 0.39306640625, -0.1181640625, 0.35888671875,
    -0.09130859375, 0.32470703125, -0.064453125, 0.27587890625, -0.064453125,
    0.20263671875, -0.064453125, 0.16845703125, -0.11767578125, 0.13427734375,
    -0.1708984375, 0.13427734375, -0.2490234375, 0.404296875, -0.7412109375,
    0.38671875, -0.71142578125, 0.357421875, -0.688232421875, 0.328125,
    -0.6650390625, 0.287109375, -0.6650390625, 0.24853515625, -0.6650390625,
    0.219482421875, -0.689208984375, 0.1904296875, -0.71337890625,
    0.17333984375, -0.7412109375, 0.12255859375, -0.71533203125, 0.14306640625,
    -0.65966796875, 0.187255859375, -0.622314453125, 0.2314453125,
    -0.5849609375, 0.28662109375, -0.5849609375, 0.34814453125, -0.5849609375,
    0.390869140625, -0.625732421875, 0.43359375, -0.66650390625, 0.45068359375,
    -0.71484375, 0.404296875, -0.7412109375,
  ]);
  expect(glyph.points).toStrictEqual(expectedPoints);
  riveText.deleteGlyphPath(glyph.rawPath);
  riveText.deleteFont(font);
});
