project('libpluie-echo', 'vala', 'c')

glib_dep      = dependency('glib-2.0')
gobject_dep   = dependency('gobject-2.0')

version       = '0.1'
bindir        = join_paths(get_option('prefix'), get_option('bindir'))
datadir       = join_paths(get_option('prefix'), get_option('datadir'), 'pluie')
libdir        = join_paths(get_option('prefix'), get_option('libdir'), 'pkgconfig')
incdir        = join_paths(get_option('prefix'), get_option('includedir'), 'pluie')

conf          = configuration_data()
conf.set('VERSION'     , version)
conf.set('INSTALL_PATH', bindir)
conf.set('DATA_PATH'   , datadir)

configure_file(
  input: 'install.vala.in',
  output: 'install.vala',
  configuration: conf
)

sources       = [
    'src/Pluie.Color.vala',
    'src/Pluie.ColorConf.vala',
    'src/Pluie.Dbg.vala',
    'src/Pluie.global.vala',
    'src/Pluie.OutputFormatter.vala',
    'src/Pluie.Sys.Cmd.vala',
    'build/install.vala'
]

install_data('resources/echo.ini', install_dir : datadir)

libpluie_echo = library('pluie-echo-' + version, sources,
                  vala_header: 'pluie_echo.h',
                  vala_vapi: 'pluie-echo-' +version+'.vapi',
                  dependencies: [glib_dep, gobject_dep],
                  install: true,
                  install_dir: [get_option('libdir'), incdir, true])

pkgconfig = import('pkgconfig')
pkgconfig.generate(libraries: libpluie_echo,
                   requires: 'glib-2.0 gobject-2.0',
                   variables: 'datarootdir='+join_paths('${prefix}', get_option('datadir'))+'\ndatadir='+join_paths('${datarootdir}', 'pluie'),
                   version: version,
                   name: 'libpluie-echo',
                   filebase: 'pluie-echo-' + version,
                   subdirs: 'pluie',
                   description: 'The pluie echo library')


