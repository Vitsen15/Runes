/* eslint-disable no-undef */
'use strict';

let gulp = require('gulp'),
	autoprefixer = require('gulp-autoprefixer'),
	sass = require('gulp-sass'),
	watch = require('gulp-watch'),
	wait = require('gulp-wait'),
	uglify = require('gulp-uglify-es').default,
	babel = require('gulp-babel'),
	sourcemaps = require('gulp-sourcemaps');


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

gulp.task('javascript', function () {
	gulp.src('./js/src/*.js')
		.pipe(sourcemaps.init())
		.pipe(babel({
			presets: ['es2015']
		}))
		.pipe(uglify())
		.pipe(sourcemaps.write())
		.pipe(gulp.dest('./js/min'));
});

gulp.task('watch', function () {
	watch(['stylesheets/**/*.scss'], function (event, cb) {
		gulp.start('stylesheets');
	});
	watch(['./js/src/*.js'], function (event, cb) {
		gulp.start('javascript');
	});
});

// Run
gulp.task('default', [
	'stylesheets',
	'javascript',
	'watch'
]);