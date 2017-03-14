module.exports = {
  config: {
    shell: 'zsh',
    // default font size in pixels for all tabs
    fontSize: 11,

    // font family with optional fallbacks
    fontFamily: 'SourceHanCodeJP-Normal',

    // terminal cursor background color (hex)
    cursorColor: '#bd4a4d',

    // color of the text
    foregroundColor: '#fff',

    // terminal background color
    backgroundColor: '#111',

    // border color (window, tabs)
    borderColor: '#bd4a4d',

    // custom css to embed in the main window
    css: `
    //   .hyperterm_main:before {
    //     content: "";
    //     position: fixed;
    //     right: 20px;
    //     bottom: 0;
    //     height: 70vh;
    //     width: 30vw;
    //     background-image: url(/Users/nju33/hyperterm/images/amami-haruka/kimono.png);
    //     background-position: right bottom;
    //     background-size: contain;
    //     background-repeat: no-repeat;
    //     border-bottom: 1px solid #bd4a4d;
    //     transform: rotateY(180deg);
    //   }
     //
    //   .tabs_nav {
    //     font-weight: bold;
    //     font-size: 10px;
    //     font-family: 'SourceHanCodeJP-Normal';
    //   }
     //
    //  .tabs_title {
    //    color: #bd4a4d;
    //    font-size: 1.2em;
    //  }
     //
    //  .tab_tab {
    //    color: #888;
    //  }
     //
    //  .tab_active {
    //    font-size: 1.2em;
    //    color: #bd4a4d;
    //  }
     //
    //  .tab_active:hover {
    //    color: #bd4a4d;
    //  }
     //
    //  .tab_active .tab_icon {
    //    top: 11px;
    //    /*border: 1px solid;*/
    //    color: #bd4a4d;
    //    cursor: pointer;
    //  }
    `,

    // custom css to embed in the terminal window
    termCSS: `
      // x-row {
      //   font-weight: bolder;
      //   background: #111;
      // }
    `,

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

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
    'hyperterm-atom-dark',
    'hyperterm-alternatescroll'
  ],

  // in development, you can create a directory under
  // `~/.hyperterm_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [
    // 'test'
  ]

};
