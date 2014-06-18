module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        files: [
          expand: true
          cwd: 'src/'
          src: ['*.coffee']
          dest: 'js'
          ext: '.js'
        ]
    browserify:
      dist:
        files:
          'jqdap.js': ['js/jqdap.js']
    watch:
      scripts:
        files: ['src/**/*.coffee'],
        tasks: ['compile'],

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-browserify'

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'compile', ['coffee', 'browserify']
