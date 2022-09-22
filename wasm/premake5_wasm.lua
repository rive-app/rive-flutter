workspace 'render_font'
configurations {'debug', 'release'}

source = '../macos/'

project 'render_font'
kind 'ConsoleApp'
language 'C++'
cppdialect 'C++17'
toolset 'clang'
targetdir('build/bin/%{cfg.buildcfg}')
objdir('build/obj/%{cfg.buildcfg}')

defines {
    'WITH_RIVE_TEXT',
    'HAVE_OT',
    'HB_NO_FALLBACK_SHAPE',
    'HB_NO_WIN1256'
}

includedirs {
    source .. 'rive-cpp/include',
    source .. 'rive-cpp/skia/renderer/include',
    source .. 'harfbuzz/src/'
}

files {
    'renderfont_bindings.cpp',
    source .. 'rive-cpp/src/renderer.cpp',
    source .. 'rive-cpp/src/math/raw_path.cpp',
    source .. 'rive-cpp/src/text/renderfont_hb.cpp',
    source .. 'harfbuzz/src/hb-aat-layout.cc',
    source .. 'harfbuzz/src/hb-aat-map.cc',
    source .. 'harfbuzz/src/hb-blob.cc',
    source .. 'harfbuzz/src/hb-buffer-serialize.cc',
    source .. 'harfbuzz/src/hb-buffer-verify.cc',
    source .. 'harfbuzz/src/hb-buffer.cc',
    source .. 'harfbuzz/src/hb-common.cc',
    source .. 'harfbuzz/src/hb-draw.cc',
    source .. 'harfbuzz/src/hb-face.cc',
    source .. 'harfbuzz/src/hb-font.cc',
    source .. 'harfbuzz/src/hb-map.cc',
    source .. 'harfbuzz/src/hb-number.cc',
    source .. 'harfbuzz/src/hb-ot-cff1-table.cc',
    source .. 'harfbuzz/src/hb-ot-cff2-table.cc',
    source .. 'harfbuzz/src/hb-ot-color.cc',
    source .. 'harfbuzz/src/hb-ot-face.cc',
    source .. 'harfbuzz/src/hb-ot-font.cc',
    source .. 'harfbuzz/src/hb-ot-layout.cc',
    source .. 'harfbuzz/src/hb-ot-map.cc',
    source .. 'harfbuzz/src/hb-ot-math.cc',
    source .. 'harfbuzz/src/hb-ot-meta.cc',
    source .. 'harfbuzz/src/hb-ot-metrics.cc',
    source .. 'harfbuzz/src/hb-ot-name.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-arabic.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-default.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-hangul.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-hebrew.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-indic-table.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-indic.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-khmer.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-myanmar.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-syllabic.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-thai.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-use.cc',
    source .. 'harfbuzz/src/hb-ot-shape-complex-vowel-constraints.cc',
    source .. 'harfbuzz/src/hb-ot-shape-fallback.cc',
    source .. 'harfbuzz/src/hb-ot-shape-normalize.cc',
    source .. 'harfbuzz/src/hb-ot-shape.cc',
    source .. 'harfbuzz/src/hb-ot-tag.cc',
    source .. 'harfbuzz/src/hb-ot-var.cc',
    source .. 'harfbuzz/src/hb-set.cc',
    source .. 'harfbuzz/src/hb-shape-plan.cc',
    source .. 'harfbuzz/src/hb-shape.cc',
    source .. 'harfbuzz/src/hb-shaper.cc',
    source .. 'harfbuzz/src/hb-static.cc',
    source .. 'harfbuzz/src/hb-subset-cff-common.cc',
    source .. 'harfbuzz/src/hb-subset-cff1.cc',
    source .. 'harfbuzz/src/hb-subset-cff2.cc',
    source .. 'harfbuzz/src/hb-subset-input.cc',
    source .. 'harfbuzz/src/hb-subset-plan.cc',
    source .. 'harfbuzz/src/hb-subset-repacker.cc',
    source .. 'harfbuzz/src/hb-subset.cc',
    source .. 'harfbuzz/src/hb-ucd.cc',
    source .. 'harfbuzz/src/hb-unicode.cc'
}

buildoptions {
    '-s STRICT=1',
    '-s DISABLE_EXCEPTION_CATCHING=1',
    '-DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0',
    '-DSINGLE',
    '-DANSI_DECLARATORS',
    '-Wno-c++17-extensions',
    '-fno-exceptions',
    '-fno-rtti',
    '-fno-unwind-tables',
    '--no-entry',
    '-Wno-deprecated-builtins'
}

linkoptions {
    '--closure 1',
    '--closure-args="--externs ./js/externs.js"',
    '--bind',
    '-s FORCE_FILESYSTEM=0',
    '-s MODULARIZE=1',
    '-s NO_EXIT_RUNTIME=1',
    '-s STRICT=1',
    '-s ALLOW_MEMORY_GROWTH=1',
    '-s DISABLE_EXCEPTION_CATCHING=1',
    '-s WASM=1',
    -- "-s EXPORT_ES6=1",
    '-s USE_ES6_IMPORT_META=0',
    '-s EXPORT_NAME="RenderFont"',
    '-DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0',
    '-DANSI_DECLARATORS',
    '-Wno-c++17-extensions',
    '-fno-exceptions',
    '-fno-rtti',
    '-fno-unwind-tables',
    '--no-entry',
    '--pre-js ./js/render_font.js'
}

filter {'options:single_file'}
do
    linkoptions {
        '-o %{cfg.targetdir}/render_font_single.js'
    }
end

filter {'options:not single_file'}
do
    linkoptions {
        '-o %{cfg.targetdir}/render_font.js'
    }
end

filter 'options:single_file'
do
    linkoptions {
        '-s SINGLE_FILE=1'
    }
end

filter 'configurations:debug'
do
    defines {'DEBUG'}
    symbols 'On'
    linkoptions {'-s ASSERTIONS=1'}
end

filter 'configurations:release'
do
    defines {'RELEASE'}
    defines {'NDEBUG'}
    optimize 'On'
    linkoptions {'-s ASSERTIONS=0'}
end

buildoptions {
    '-Oz',
    '-g0',
    '-flto'
}

linkoptions {
    '-Oz',
    '-g0',
    '-flto'
}

newoption {
    trigger = 'single_file',
    description = 'Set when the wasm should be packed in with the js code.'
}
