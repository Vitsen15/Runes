'use strict';

var gulp = require('gulp'),
	autoprefixer = require('gulp-autoprefixer'),
	sass = require('gulp-sass'),
	watch = require('gulp-watch'),
	wait = require('gulp-wait'),
	uglify = require('gulp-uglifyjs'),
	babel = require('gulp-babel');


// Scss stylesheets
gulp.task('stylesheets', function () {
	return gulp.src('stylesheets/**/*.scss')
		.pipe(wait(150))
		.pipe(sass({
			outputStyle: 'compressed'
		})).on('error', sass.logError)
		.pipe(autoprefixer({
			browsers: ['last 15 version', '> 1%', 'ie 8']
		}))
		.pipe(gulp.dest('css/'));
});

gulp.task('watch', function () {
	watch(['stylesheets/**/*.scss'], function (event, cb) {
		gulp.start('stylesheets');
	});
	watch(['./js/*.js'], function (event, cb) {
		gulp.start('uglify');
	});
});

gulp.task('uglify', function () {
	gulp.src('./js/*.js')
		.pipe(babel({
			presets: ['es2015']
		}))
		.pipe(uglify())
		.pipe(gulp.dest('./js/min'));
});

// Run
gulp.task('default', [
	'stylesheets',
	'uglify',
	'watch'
]);

gulp.task('wp', [
	'stylesheets',
	'watch'
]);