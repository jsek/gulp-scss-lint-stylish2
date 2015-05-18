var gulp      = require('gulp'),
    scssLint  = require('gulp-scss-lint'),
    reporters = require('gulp-scss-lint-stylish2');

gulp.task('scsslint', function() {
    gulp.src(['./**/*.scss'])
        .pipe(scssLint({
            config: './scsslint.config.yml',
            customReport: reporters.suppress
        }))
        .pipe(reporters.stylish());
    });

gulp.task('scsslint_errors', function() {
    gulp.src(['./**/*.scss'])
        .pipe(scssLint({
            config: './scsslint.config.yml',
            customReport: reporters.suppress
        }))
        .pipe(reporters.stylish({ errorsOnly: true }));
});