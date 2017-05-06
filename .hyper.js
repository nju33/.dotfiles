module.exports = {
  config: {
    shell: '/usr/local/bin/fish',
    // default font size in pixels for all tabs
    fontSize: 8.75,

    // font family with optional fallbacks
    // fontFamily: 'SourceHanCodeJP-Normal',
    fontFamily: 'Menlo, Consolas, \'DejaVu Sans Mono\', monospacel',

    // terminal cursor background color (hex)
    cursorColor: '#bd4a4d',

    // color of the text
    foregroundColor: '#fff',

    // terminal background color
    backgroundColor: '#111',

    // border color (window, tabs)
    borderColor: '#bd4a4d',

    // custom css to embed in the main window
    css: ``,

    // custom css to embed in the terminal window
    termCSS: ``,

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '1em',

    // some color overrides. see http://bit.ly/29k1iU2 for
    // the full list
    colors: [
      '#000000',
      '#ff0000',
      '#33ff00',
      '#ffff00',
      '#0066ff',
      '#cc00ff',
      '#00ffff',
      '#d0d0d0',
      '#808080',
      '#ff0000',
      '#33ff00',
      '#ffff00',
      '#0066ff',
      '#cc00ff',
      '#00ffff',
      '#ffffff'
    ]
  },

  bell: false,

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
    'hyperterm-atom-dark',
    'hyperterm-alternatescroll',
    'hyper-always-on-top',
  ],

  // in development, you can create a directory under
  // `~/.hyperterm_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [
    // 'test'
  ]

};
