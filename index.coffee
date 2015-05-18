###
 * @fileoverview Custom stylish reporter for gulp-scss-lint
 * @author J-Sek
###

gutil   = require('gulp-util')
table   = require('text-table')
through = require('through2')

lastFailingFile = null
cl = gutil.colors

severityColor = 
    warning : cl.yellow
    error   : cl.red 

#------------------------------------------------------------------------------
# Helpers
#------------------------------------------------------------------------------

printPath     = (path) -> '\n' + cl.magenta(path)
printPlaceRaw = (issue) -> "(#{issue.line},#{issue.column})"
printSeverity = (issue) -> severityColor[issue.severity](issue.severity)
printLinter   = (issue) -> cl.gray(issue.linter)
pluralize     = (word, count) -> if count > 1 then word + 's' else word

printPathLine = (file) ->
    if (lastFailingFile != file.path)
        lastFailingFile = file.path
        console.log printPath(lastFailingFile)

logStylish    = (issues) ->
    data = for issue in issues
        [
            ""
            issue.line
            issue.column
            printSeverity issue
            issue.reason
            printLinter issue
        ]
        
    tableOptions = 
        align: ["", "r", "l"],
        stringLength: (str) -> cl.stripColor(str).length

    results = table(data, tableOptions)
        .split '\n'
        .map (x) -> x.replace /(\d+)\s+(\d+)/, (m, p1, p2) -> cl.gray(p1 + ':' + p2)
        .join '\n'

    console.log printResults

#------------------------------------------------------------------------------
# Reporters
#------------------------------------------------------------------------------

###
 * Inspired by 'stylish' ESLint reporter
 * Usage: stream element, like for ESLint
###

stylishPrintFile = (file) ->
    if !file.scsslint.success
        printPathLine file
        logStylish file.scsslint.issues

stylishPrintErrorsInFile = (file) ->
    if file.scsslint.errors > 0
        printPathLine file
        logStylish file.scsslint.issues.filter((x) -> x.severity is 'error')
    
stylishSummary = (total, errors, warnings) ->
    if total > 0
        console.log cl.red.bold "\n\u2716  #{total} #{pluralize('problem', total)} (#{errors} #{pluralize('error', errors)}, #{warnings} #{pluralize('warning', warnings)})\n"
    
stylishErrorsSummary = (total, errors, warnings) ->
    if total > 0
        console.log cl.red.bold "\n\u2716  #{errors} #{pluralize('error', errors)}!\n"

writeStylishResults = (results, fileFormatter, summaryFormatter) ->
    total = errors = warnings = 0
    
    for result in results
        fileFormatter(result)
        total += result.scsslint.issues.length
        errors += result.scsslint.errors
        warnings += result.scsslint.warnings
        
    if total > 0 then summaryFormatter(total, errors, warnings)

reportWithSummary = (fileFormatter, summaryFormatter) ->
    results = []

    passAll = (file, enc, cb) ->
        unless file.scsslint.success then results.push(file)
        cb(null, file)

    printResults = (cb) ->
        if results.length then writeStylishResults(results, fileFormatter, summaryFormatter)
        # reset buffered results
        results = []
        cb()

    return through.obj passAll, printResults

stylishReporter = (opts) ->
    opts = opts or {}
    if opts.errorsOnly
        reportWithSummary stylishPrintErrorsInFile, stylishErrorsSummary
    else
        reportWithSummary stylishPrintFile, stylishSummary

#------------------------------------------------------------------------------

module.exports =
    suppress: -> return
    stylish: stylishReporter