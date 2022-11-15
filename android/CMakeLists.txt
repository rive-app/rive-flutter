cmake_minimum_required(VERSION 3.4.1) # for example

set(CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} -DWITH_RIVE_TEXT -DHAVE_OT -DHB_NO_FALLBACK_SHAPE -DHB_NO_WIN1256 -std=c++17"
)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSB_CONFIG_UNITY")

add_library(
  rive_text
  # Sets the library as a shared library.
  SHARED
  # Provides a relative path to your source file(s).
  ../ios/rive_text/rive_text.cpp
  ../ios/rive-cpp/src/math/raw_path.cpp
  ../ios/rive-cpp/src/math/mat2d.cpp
  ../ios/rive-cpp/src/rive_counter.cpp
  ../ios/rive-cpp/src/renderer.cpp
  ../ios/rive-cpp/src/text/font_hb.cpp
  ../ios/rive-cpp/src/text/line_breaker.cpp
  ../ios/harfbuzz/src/hb-aat-layout.cc
  ../ios/harfbuzz/src/hb-aat-map.cc
  ../ios/harfbuzz/src/hb-blob.cc
  ../ios/harfbuzz/src/hb-buffer-serialize.cc
  ../ios/harfbuzz/src/hb-buffer-verify.cc
  ../ios/harfbuzz/src/hb-buffer.cc
  ../ios/harfbuzz/src/hb-common.cc
  ../ios/harfbuzz/src/hb-draw.cc
  ../ios/harfbuzz/src/hb-face.cc
  ../ios/harfbuzz/src/hb-font.cc
  ../ios/harfbuzz/src/hb-map.cc
  ../ios/harfbuzz/src/hb-number.cc
  ../ios/harfbuzz/src/hb-ot-cff1-table.cc
  ../ios/harfbuzz/src/hb-ot-cff2-table.cc
  ../ios/harfbuzz/src/hb-ot-color.cc
  ../ios/harfbuzz/src/hb-ot-face.cc
  ../ios/harfbuzz/src/hb-ot-font.cc
  ../ios/harfbuzz/src/hb-ot-layout.cc
  ../ios/harfbuzz/src/hb-ot-map.cc
  ../ios/harfbuzz/src/hb-ot-math.cc
  ../ios/harfbuzz/src/hb-ot-meta.cc
  ../ios/harfbuzz/src/hb-ot-metrics.cc
  ../ios/harfbuzz/src/hb-ot-name.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-arabic.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-default.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-hangul.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-hebrew.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-indic-table.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-indic.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-khmer.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-myanmar.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-syllabic.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-thai.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-use.cc
  ../ios/harfbuzz/src/hb-ot-shape-complex-vowel-constraints.cc
  ../ios/harfbuzz/src/hb-ot-shape-fallback.cc
  ../ios/harfbuzz/src/hb-ot-shape-normalize.cc
  ../ios/harfbuzz/src/hb-ot-shape.cc
  ../ios/harfbuzz/src/hb-ot-tag.cc
  ../ios/harfbuzz/src/hb-ot-var.cc
  ../ios/harfbuzz/src/hb-set.cc
  ../ios/harfbuzz/src/hb-shape-plan.cc
  ../ios/harfbuzz/src/hb-shape.cc
  ../ios/harfbuzz/src/hb-shaper.cc
  ../ios/harfbuzz/src/hb-static.cc
  ../ios/harfbuzz/src/hb-subset-cff-common.cc
  ../ios/harfbuzz/src/hb-subset-cff1.cc
  ../ios/harfbuzz/src/hb-subset-cff2.cc
  ../ios/harfbuzz/src/hb-subset-input.cc
  ../ios/harfbuzz/src/hb-subset-plan.cc
  ../ios/harfbuzz/src/hb-subset-repacker.cc
  ../ios/harfbuzz/src/hb-subset.cc
  ../ios/harfbuzz/src/hb-ucd.cc
  ../ios/harfbuzz/src/hb-unicode.cc
  ../ios/SheenBidi/Source/SheenBidi.c)

target_include_directories(
  rive_text PRIVATE ../ios/harfbuzz/src ../ios/rive-cpp/skia/renderer/include
                    ../ios/rive-cpp/include ../ios/SheenBidi/Headers)
