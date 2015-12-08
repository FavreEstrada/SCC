module.exports = function(grunt) {

  // Project configuration.
  require('time-grunt')(grunt);

  grunt.initConfig({
    pkg: '<json:package.json>',
    less: {
      dev: {
        files: [{
          expand: true,
          cwd: '.',
          src: ['app/components/directives/{,*/}*.less', 'app/css/{,*}*.less', 'app/login.less'],
          dest: '.',
          ext: '.css'
        }]
      }
    },
    concat: {
      js: {
        options: {
          separator: '\n'
        },
        files: {
          'app.js': ['app/config.js', 'app/models/{,*/}*.js', 'app/services/{,*/}*.js', 'app/components/filters/{,*/}*.js', 'app/components/controllers/{,*/}*.js', 'app/components/directives/{,*/}*.js', 'app/factories/{,*/}*.js'],
          'libs.js': [
            'lib/bower_components/jquery/dist/jquery.min.js',
            'lib/bower_components/angular/angular.min.js',
            'lib/bower_components/angular-route/angular-route.min.js',
            'lib/bower_components/angular-cookies/angular-cookies.js',
            'lib/bower_components/angular-md5/angular-md5.min.js',
            'lib/bower_components/angular-route-styles/route-styles.js',
            'lib/bower_components/d3/d3.min.js',
            'lib/bower_components/underscore/underscore-min.js',
            'lib/bower_components/underscore.string/dist/underscore.string.js',
            'lib/bower_components/bootstrap/dist/js/bootstrap.min.js',
            'lib/bower_components/angular-bootstrap/ui-bootstrap.min.js',
            'lib/bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js'
          ]
        }
      },
      css: {
        src: ['app/css/{,*/}*.css', 'app/components/directives/{,*/}*.css'],
        dest: 'appCSS.css'
      }
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
      files: ['app/{,**/}*.js',
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
      options: {
        livereload: false,
        spawn: false,
        debounceDelay: 150
      },
      js: {
        files: ['app/{,**/}*.js'],
        tasks: ['jshint', 'concat:js']
      },
      css: {
        files: [
          'app/css/{,*}*.css', 'app/components/directives/{,*/}*.css', 'app/login.css'
        ],
        tasks: ['concat:css']
      },
      sass: {
        files: [
          'app/css/{,*}*.scss', 'app/components/directives/{,*/}*.scss'
        ],
        tasks: ['sass', 'concat:css']
      },
      less: {
        files: [
          'app/css/{,*}*.less', 'app/components/directives/{,*/}*.less', 'app/login.less'
        ],
        tasks: ['less', 'concat:css']
      },
      html: {
        files: ['app/**/*.html', 'index.html']
      }
    },
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-less');

  grunt.registerTask("generate", ['jshint', 'concat:js', 'less', 'concat:css']);
  grunt.registerTask('livereload', ['generate', 'watch']);
  grunt.registerTask('gitpush', 'jshint');
  grunt.registerTask('deploy', ['jshint', 'concat']);
  grunt.registerTask('deployprod', ['jshint', 'concat', 'uglify']);
};