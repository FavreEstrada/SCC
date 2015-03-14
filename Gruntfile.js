module.exports = function(grunt) {

  // Project configuration.
  require('time-grunt')(grunt);

  grunt.initConfig({
    pkg: '<json:package.json>',
    concat: {
      options: {
        separator: ';'
      },
      basic_and_extras: {
        files: {
          'app.js': ['assets/js/controllers/{,*/}*.js', 'assets/js/models/{,*/}*.js', 'assets/js/helpers/{,*/}*.js', 'assets/js/components/{,*/}*.js','assets/js/lang/{,*/}*.js'],
          'libs.js': [
            'assets/libs/jquery1.10.2.js',
            'assets/libs/can.custom.js',
            'assets/libs/d3.v2.js',
            'assets/libs/d3pie.min.js',
            'assets/libs/sap.viz.javafx.patch.js',
            'assets/libs/masonry.pkgd.min.js',
            'assets/libs/toasterNotifs.js',
            'assets/libs/moment.js',
            'assets/libs/json2.js',
            'assets/libs/canvg.js',
            'assets/libs/rgbcolor.js',
            'assets/libs/intro.min.js',
            'assets/libs/sap.viz.js',
            'assets/libs/jquery-ui.min.js',
            'assets/libs/bootstrap.min.js',
            'assets/libs/bootstrap-select.min.js',
            'assets/libs/tag-it.custom.js',
            'assets/libs/html2canvas.js',
            'assets/libs/jspdf.js',
            'assets/libs/jspdf.plugin.addimage.js',
            'assets/libs/Blob.js',
            'assets/libs/canvas-to-blob.min.js',
            'assets/libs/FileSaver.js',
            'assets/libs/daterangepicker.js',
            'assets/libs/iscroll.js',
            'assets/libs/jquery.Jcrop.min.js',
            'assets/libs/faye-browser-min.js'
          ],
          'cvon-templates.js': ['assets/js/cvon-templates/*.js']
        },
      },
    },
    uglify: {
      options: {
        compress: {
          drop_console: true
        }
      },
      my_target: {
        files: {
          'app.min.js': ['app.js']
        }
      }
    },
    jshint: {
      files: ['assets/js/controllers/{,*/}*.js',
        'assets/js/models/{,*/}*.js', 'assets/js/components/{,*/}*.js'
      ],
      options: {
        curly: true,
        eqeqeq: true,
        eqnull: true,
        browser: true,
        devel: true,
        smarttabs: true,
        maxerr: 10,
        globals: {
          exports: true,
          module: true,
          console: true,
          $: true,
          window: true
        },
      },
    },
    watch: {
      js: {
        files: ['assets/js/components/{,*/}*.js', 'assets/js/controllers/{,*/}*.js', 'assets/js/models/{,*/}*.js', 'assets/js/helpers/{,*/}*.js', 'assets/libs/{,*/}*.js'],
        tasks: ['concat'],
        options: {
          spawn: false,
          debounceDelay: 150
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('livereload', ['jshint', 'concat', 'watch']);
  grunt.registerTask('gitpush', 'jshint');
  grunt.registerTask('deploy', ['jshint', 'concat']);
  grunt.registerTask('deployprod', ['jshint', 'concat', 'uglify']);
};