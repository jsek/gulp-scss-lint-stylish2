Stylish reporter for gulp-scss-lint, following the visual style of ESLint stylish reporter

[![licence](https://img.shields.io/npm/l/gulp-scss-lint-stylish2.svg)](https://github.com/jsek/gulp-scss-lint-stylish2/blob/master/LICENSE)
[![npm version](http://img.shields.io/npm/v/gulp-scss-lint-stylish2.svg)](https://npmjs.org/package/gulp-scss-lint-stylish2) 
[![downloads](https://img.shields.io/npm/dm/gulp-scss-lint-stylish2.svg)](https://npmjs.org/package/gulp-scss-lint-stylish2) 

* [Overview](#overview)
* [Installation](#installation)
* [Usage](#usage)

## Overview

Example console output:

![screenshot](images/screenshot_1.0.0.png)

## Installation

```
npm install --save gulp-scss-lint-stylish
```

## Usage

``` javascript
var gulp      = require('gulp'),
    scssLint  = require('gulp-scss-lint'),
    reporters = require('gulp-scss-lint-stylish2');
 
gulp.task('scss-lint', function()
{
    gulp.src('/scss/*.scss')
        .pipe( scssLint({ customReport: reporters.suppress }) )
        .pipe( reporters.stylish() );
});

```

Alternative usage for errors:

``` javascript
    gulp.src('/scss/*.scss')
        .pipe( scssLint({ customReport: reporters.suppress }) )
        .pipe( reporters.stylish(errorsOnly: true) );
```
