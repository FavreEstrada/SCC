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
          'app.js': ['controllers/{,*/}*.js',
            //'assets/js/models/{,*/}*.js',
            //'assets/js/helpers/{,*/}*.js',
            //'assets/js/components/{,*/}*.js',
            //'assets/js/lang/{,*/}*.js'
          ],
          'libs.js': [
            'libs/jquery.js',
            'libs/angular.min.js',
            'libs/bootstrap.js',
            'libs/less.js',

          ],
          //'cvon-templates.js': ['assets/js/cvon-templates/*.js']
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
      files: ['controllers/{,*/}*.js',
        //'assets/js/models/{,*/}*.js', 'assets/js/components/{,*/}*.js'
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
        files: ['controllers/{,*/}*.js',
          //'assets/js/components/{,*/}*.js',
          //'assets/js/models/{,*/}*.js',
          //'assets/js/helpers/{,*/}*.js',
          'libs/{,*/}*.js'
        ],
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