module.exports = (grunt) ->
	grunt.initConfig
		coffee:
			unit_tests:
				expand: true
				cwd:  "test/unit/coffee"
				src: ["**/*.coffee"]
				dest: "test/unit/js/"
				ext:  ".js"

		clean:
			unit_tests: ["test/unit/js"]

		mochaTest:
			unit:
				options:
					reporter: grunt.option('reporter') or 'spec'
					grep: grunt.option("grep")

				src: ["test/unit/js/**/*.js"]

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-mocha-test'
	grunt.loadNpmTasks 'grunt-execute'
	grunt.loadNpmTasks 'grunt-bunyan'

	grunt.registerTask 'compile:unit_tests', ['clean:unit_tests', 'coffee:unit_tests']
	grunt.registerTask 'test:unit',          ['compile:unit_tests', 'mochaTest:unit']
