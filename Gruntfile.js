module.exports = function(grunt) {

  // Project configuration.
  require('time-grunt')(grunt);
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    pkg: '<json:package.json>',
    less: {
      dev: {
        files: [{
          expand: true,
          cwd: '.',
          src: ['app/directives/{,*/}*.less', 'app/css/{,*}*.less', 'app/login.less'],
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
          'app.js': ['app/shared/router_ctrl.js', 'app/models/{,*/}*.js', 'app/services/{,*/}*.js', 'app/filters/{,*/}*.js', 'app/controllers/{,*/}*.js', 'app/directives/{,*/}*.js', 'app/factories/{,*/}*.js'],
          'libs.js': [
            'lib/jquery/dist/jquery.min.js',
            'lib/angular/angular.min.js',
            'lib/angular-route/angular-route.min.js',
            'lib/angular-md5/angular-md5.min.js',
            'lib/AngularJS-Toaster/toaster.min.js',
            'lib/angular-cookies/angular-cookies.js',
            'lib/angular-route-styles/route-styles.js',
            'lib/d3/d3.min.js',
            'lib/bootstrap/dist/js/bootstrap.min.js',
            'lib/angular-bootstrap/ui-bootstrap.min.js',
            'lib/angular-bootstrap/ui-bootstrap-tpls.min.js'
          ]
        }
      },
      css: {
        src: ['app/css/{,*/}*.css', 'app/directives/{,*/}*.css', 'lib/AngularJS-Toaster/toaster.min.css'],
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
        //'assets/js/models/{,*/}*.js', 'assets/js/{,*/}*.js'
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
        // spawn: false,
      },
      js: {
        files: ['app/{,**/}*.js'],
        tasks: ['jshint', 'concat:js']
      },
      css: {
        files: [
          'app/css/{,*}*.css', 'app/directives/{,*/}*.css', 'app/login.css'
        ],
        tasks: ['concat:css']
      },
      less: {
        files: [
          'app/css/{,*}*.less', 'app/directives/{,*/}*.less', 'app/login.less'
        ],
        tasks: ['less', 'concat:css']
      }
    },
    run: {
      integration_server: {
        args: [
          'index.js'
        ]
      }
    },
    concurrent: {
      start: ['generate', 'watch', 'run:integration_server'],
      options: {
                logConcurrentOutput: true
            }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-run');


  grunt.registerTask("generate", ['jshint', 'concat:js', 'less', 'concat:css']);
  grunt.registerTask('livereload', 'concurrent:start');
  grunt.registerTask('gitpush', 'jshint');
  grunt.registerTask('deploy', ['jshint', 'concat']);
  grunt.registerTask('deployprod', ['jshint', 'concat', 'uglify']);
};