workspace 'render_font'
configurations {'debug', 'release'}

source = '../macos/'
harfbuzz = source .. 'rive-cpp/dependencies/macosx/cache/harfbuzz/'
fribidi = source .. 'rive-cpp/dependencies/macosx/cache/fribidi/'
sheenbidi = source .. 'rive-cpp/dependencies/macosx/cache/SheenBidi/'
project 'rive_sheenbidi'
do
    kind 'StaticLib'
    language 'C'
    toolset 'clang'
    targetdir 'build/bin/%{cfg.buildcfg}/'
    objdir 'build/obj/%{cfg.buildcfg}/'

    includedirs {
        sheenbidi .. 'Headers'
    }

    filter 'configurations:debug'
    do
        files {
            sheenbidi .. 'Source/BidiChain.c',
            sheenbidi .. 'Source/BidiTypeLookup.c',
            sheenbidi .. 'Source/BracketQueue.c',
            sheenbidi .. 'Source/GeneralCategoryLookup.c',
            sheenbidi .. 'Source/IsolatingRun.c',
            sheenbidi .. 'Source/LevelRun.c',
            sheenbidi .. 'Source/PairingLookup.c',
            sheenbidi .. 'Source/RunQueue.c',
            sheenbidi .. 'Source/SBAlgorithm.c',
            sheenbidi .. 'Source/SBBase.c',
            sheenbidi .. 'Source/SBCodepointSequence.c',
            sheenbidi .. 'Source/SBLine.c',
            sheenbidi .. 'Source/SBLog.c',
            sheenbidi .. 'Source/SBMirrorLocator.c',
            sheenbidi .. 'Source/SBParagraph.c',
            sheenbidi .. 'Source/SBScriptLocator.c',
            sheenbidi .. 'Source/ScriptLookup.c',
            sheenbidi .. 'Source/ScriptStack.c',
            sheenbidi .. 'Source/StatusStack.c'
        }
    end
    filter 'configurations:release'
    do
        files {
            sheenbidi .. 'Source/SheenBidi.c'
        }
    end

    buildoptions {
        '-Wall',
        '-ansi',
        '-pedantic'
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

    filter 'configurations:debug'
    do
        defines {'DEBUG'}
        symbols 'On'
    end

    filter 'configurations:release'
    do
        defines {'RELEASE', 'NDEBUG', 'SB_CONFIG_UNITY'}
        optimize 'On'
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
    end
end

project 'rive_fribidi'
do
    kind 'StaticLib'
    language 'C++'
    cppdialect 'C++17'
    toolset 'clang'
    targetdir('build/bin/%{cfg.buildcfg}')
    objdir('build/obj/%{cfg.buildcfg}')

    defines {
        'DONT_HAVE_FRIBIDI_CONFIG_H',
        'DONT_HAVE_FRIBIDI_UNICODE_VERSION_H',
        'FRIBIDI_BUILD',
        'FRIBIDI_LIB_STATIC',
        'HAVE_MEMORY_H',
        'HAVE_STDLIB_H',
        'HAVE_STRING_H',
        'HAVE_STRINGIZE',
        'HAVE_STRINGS_H'
    }

    includedirs {
        fribidi .. 'lib',
        source .. 'rive-cpp/dependencies/fribidi/generated'
    }

    files {
        fribidi .. 'lib/fribidi.c',
        fribidi .. 'lib/fribidi-arabic.c',
        fribidi .. 'lib/fribidi-bidi.c',
        fribidi .. 'lib/fribidi-bidi-types.c',
        fribidi .. 'lib/fribidi-char-sets.c',
        fribidi .. 'lib/fribidi-char-sets-cap-rtl.c',
        fribidi .. 'lib/fribidi-char-sets-cp1255.c',
        fribidi .. 'lib/fribidi-char-sets-cp1256.c',
        fribidi .. 'lib/fribidi-char-sets-iso8859-6.c',
        fribidi .. 'lib/fribidi-char-sets-iso8859-8.c',
        fribidi .. 'lib/fribidi-char-sets-utf8.c',
        fribidi .. 'lib/fribidi-deprecated.c',
        fribidi .. 'lib/fribidi-joining.c',
        fribidi .. 'lib/fribidi-joining-types.c',
        fribidi .. 'lib/fribidi-mirroring.c',
        fribidi .. 'lib/fribidi-brackets.c',
        fribidi .. 'lib/fribidi-run.c',
        fribidi .. 'lib/fribidi-shape.c'
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

    filter 'configurations:debug'
    do
        defines {'DEBUG'}
        symbols 'On'
    end

    filter 'configurations:release'
    do
        defines {'RELEASE'}
        defines {'NDEBUG'}
        optimize 'On'
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
    end
end

project 'render_font'
do
    kind 'ConsoleApp'
    language 'C++'
    cppdialect 'C++17'
    toolset 'clang'
    targetdir('build/bin/%{cfg.buildcfg}')
    objdir('build/obj/%{cfg.buildcfg}')

    dependson {
        -- 'rive_fribidi',
        'rive_sheenbidi'
    }

    defines {
        'WITH_RIVE_TEXT',
        'HAVE_OT',
        'HB_NO_FALLBACK_SHAPE',
        'HB_NO_WIN1256'
    }

    includedirs {
        source .. 'rive-cpp/include',
        source .. 'rive-cpp/skia/renderer/include',
        harfbuzz .. 'src/',
        fribidi .. '/lib',
        sheenbidi .. 'Headers'
    }

    files {
        'renderfont_bindings.cpp',
        source .. 'rive-cpp/src/renderer.cpp',
        source .. 'rive-cpp/src/math/raw_path.cpp',
        source .. 'rive-cpp/src/text/renderfont_hb.cpp',
        source .. 'rive-cpp/src/text/line_breaker.cpp',
        harfbuzz .. 'src/hb-aat-layout.cc',
        harfbuzz .. 'src/hb-aat-map.cc',
        harfbuzz .. 'src/hb-blob.cc',
        harfbuzz .. 'src/hb-buffer-serialize.cc',
        harfbuzz .. 'src/hb-buffer-verify.cc',
        harfbuzz .. 'src/hb-buffer.cc',
        harfbuzz .. 'src/hb-common.cc',
        harfbuzz .. 'src/hb-draw.cc',
        harfbuzz .. 'src/hb-face.cc',
        harfbuzz .. 'src/hb-font.cc',
        harfbuzz .. 'src/hb-map.cc',
        harfbuzz .. 'src/hb-number.cc',
        harfbuzz .. 'src/hb-ot-cff1-table.cc',
        harfbuzz .. 'src/hb-ot-cff2-table.cc',
        harfbuzz .. 'src/hb-ot-color.cc',
        harfbuzz .. 'src/hb-ot-face.cc',
        harfbuzz .. 'src/hb-ot-font.cc',
        harfbuzz .. 'src/hb-ot-layout.cc',
        harfbuzz .. 'src/hb-ot-map.cc',
        harfbuzz .. 'src/hb-ot-math.cc',
        harfbuzz .. 'src/hb-ot-meta.cc',
        harfbuzz .. 'src/hb-ot-metrics.cc',
        harfbuzz .. 'src/hb-ot-name.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-arabic.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-default.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-hangul.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-hebrew.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-indic-table.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-indic.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-khmer.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-myanmar.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-syllabic.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-thai.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-use.cc',
        harfbuzz .. 'src/hb-ot-shape-complex-vowel-constraints.cc',
        harfbuzz .. 'src/hb-ot-shape-fallback.cc',
        harfbuzz .. 'src/hb-ot-shape-normalize.cc',
        harfbuzz .. 'src/hb-ot-shape.cc',
        harfbuzz .. 'src/hb-ot-tag.cc',
        harfbuzz .. 'src/hb-ot-var.cc',
        harfbuzz .. 'src/hb-set.cc',
        harfbuzz .. 'src/hb-shape-plan.cc',
        harfbuzz .. 'src/hb-shape.cc',
        harfbuzz .. 'src/hb-shaper.cc',
        harfbuzz .. 'src/hb-static.cc',
        harfbuzz .. 'src/hb-subset-cff-common.cc',
        harfbuzz .. 'src/hb-subset-cff1.cc',
        harfbuzz .. 'src/hb-subset-cff2.cc',
        harfbuzz .. 'src/hb-subset-input.cc',
        harfbuzz .. 'src/hb-subset-plan.cc',
        harfbuzz .. 'src/hb-subset-repacker.cc',
        harfbuzz .. 'src/hb-subset.cc',
        harfbuzz .. 'src/hb-ucd.cc',
        harfbuzz .. 'src/hb-unicode.cc'
    }

    links {
        -- 'rive_fribidi',
        'rive_sheenbidi'
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
end
newoption {
    trigger = 'single_file',
    description = 'Set when the wasm should be packed in with the js code.'
}
