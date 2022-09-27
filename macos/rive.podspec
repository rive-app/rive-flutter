Pod::Spec.new do |s|
  s.name = "rive"
  s.version = "0.0.1"
  s.summary = "Rive font abstraction."
  s.description = <<-DESC
Rive 2 Flutter Runtime. This package provides runtime functionality for playing back and interacting with animations built with the Rive editor available at https://rive.app.
                       DESC
  s.homepage = "https://rive.app"
  s.license = { :file => "../LICENSE" }
  s.author = { "Rive" => "hello@rive.app" }

  s.source = { :path => "." }
  s.source_files = [
    "Classes/**/*",
    "renderfont/**/*.{cpp,hpp,c,h}",
    "rive-cpp/src/math/raw_path.cpp",
    "rive-cpp/src/math/mat2d.cpp",
    "rive-cpp/src/rive_counter.cpp",
    "rive-cpp/src/renderer.cpp",
    "rive-cpp/src/text/renderfont_hb.cpp",
    "rive-cpp/src/text/line_breaker.cpp",
    "harfbuzz/src/hb-aat-layout.cc",
    "harfbuzz/src/hb-aat-map.cc",
    "harfbuzz/src/hb-blob.cc",
    "harfbuzz/src/hb-buffer-serialize.cc",
    "harfbuzz/src/hb-buffer-verify.cc",
    "harfbuzz/src/hb-buffer.cc",
    "harfbuzz/src/hb-common.cc",
    "harfbuzz/src/hb-draw.cc",
    "harfbuzz/src/hb-face.cc",
    "harfbuzz/src/hb-font.cc",
    "harfbuzz/src/hb-map.cc",
    "harfbuzz/src/hb-number.cc",
    "harfbuzz/src/hb-ot-cff1-table.cc",
    "harfbuzz/src/hb-ot-cff2-table.cc",
    "harfbuzz/src/hb-ot-color.cc",
    "harfbuzz/src/hb-ot-face.cc",
    "harfbuzz/src/hb-ot-font.cc",
    "harfbuzz/src/hb-ot-layout.cc",
    "harfbuzz/src/hb-ot-map.cc",
    "harfbuzz/src/hb-ot-math.cc",
    "harfbuzz/src/hb-ot-meta.cc",
    "harfbuzz/src/hb-ot-metrics.cc",
    "harfbuzz/src/hb-ot-name.cc",
    "harfbuzz/src/hb-ot-shape-complex-arabic.cc",
    "harfbuzz/src/hb-ot-shape-complex-default.cc",
    "harfbuzz/src/hb-ot-shape-complex-hangul.cc",
    "harfbuzz/src/hb-ot-shape-complex-hebrew.cc",
    "harfbuzz/src/hb-ot-shape-complex-indic-table.cc",
    "harfbuzz/src/hb-ot-shape-complex-indic.cc",
    "harfbuzz/src/hb-ot-shape-complex-khmer.cc",
    "harfbuzz/src/hb-ot-shape-complex-myanmar.cc",
    "harfbuzz/src/hb-ot-shape-complex-syllabic.cc",
    "harfbuzz/src/hb-ot-shape-complex-thai.cc",
    "harfbuzz/src/hb-ot-shape-complex-use.cc",
    "harfbuzz/src/hb-ot-shape-complex-vowel-constraints.cc",
    "harfbuzz/src/hb-ot-shape-fallback.cc",
    "harfbuzz/src/hb-ot-shape-normalize.cc",
    "harfbuzz/src/hb-ot-shape.cc",
    "harfbuzz/src/hb-ot-tag.cc",
    "harfbuzz/src/hb-ot-var.cc",
    "harfbuzz/src/hb-set.cc",
    "harfbuzz/src/hb-shape-plan.cc",
    "harfbuzz/src/hb-shape.cc",
    "harfbuzz/src/hb-shaper.cc",
    "harfbuzz/src/hb-static.cc",
    "harfbuzz/src/hb-subset-cff-common.cc",
    "harfbuzz/src/hb-subset-cff1.cc",
    "harfbuzz/src/hb-subset-cff2.cc",
    "harfbuzz/src/hb-subset-input.cc",
    "harfbuzz/src/hb-subset-plan.cc",
    "harfbuzz/src/hb-subset-repacker.cc",
    "harfbuzz/src/hb-subset.cc",
    "harfbuzz/src/hb-ucd.cc",
    "harfbuzz/src/hb-unicode.cc",
  ]
  s.dependency "FlutterMacOS"

  s.platform = :osx, "10.11"
  s.pod_target_xcconfig = {
    "DEFINES_MODULE" => "YES",
    "OTHER_CFLAGS" => "-DWITH_RIVE_TEXT -DHAVE_OT -DHB_NO_FALLBACK_SHAPE -DHB_NO_WIN1256 -Wno-documentation -Wno-comma -Wno-unreachable-code  -Wno-shorten-64-to-32",
    "OTHER_CPLUSPLUSFLAGS" => "-DWITH_RIVE_TEXT -DHAVE_OT -DHB_NO_FALLBACK_SHAPE -DHB_NO_WIN1256 -Wno-documentation -Wno-comma -Wno-unreachable-code -Wno-shorten-64-to-32 -std=c++17",
    "USER_HEADER_SEARCH_PATHS" => '"$(PODS_TARGET_SRCROOT)/harfbuzz/src" "$(PODS_TARGET_SRCROOT)/rive-cpp/include" "$(PODS_TARGET_SRCROOT)/rive-cpp/skia/renderer/include"',
    "OTHER_CPLUSPLUSFLAGS[config=Release]" => "-DNDEBUG",
  }
  s.swift_version = "5.0"
end
