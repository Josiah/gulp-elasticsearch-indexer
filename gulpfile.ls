require! Gulp: 'gulp'
require! GulpBump: 'gulp-bump'
require! GulpGit: 'gulp-git'
require! GulpTagVersion: 'gulp-tag-version'
require! GulpLiveScript: 'gulp-livescript'
require! Minimist: 'minimist'
require! FileSystem: 'fs'
require! Path: 'path'
require! ChildProcess: 'child_process'

const ARGV = Minimist process.argv.slice 2
const RELEASE_TYPE = switch
  | ARGV.major => 'major'
  | ARGV.minor => 'minor'
  | ARGV.patch => 'patch'
  | otherwise => 'prerelease'


Gulp.task \package <[
  package:version
  package:files
  package:livescript
]>

Gulp.task \package:version ->
  Gulp.src 'package.json'
  .pipe GulpBump type: RELEASE_TYPE
  .pipe Gulp.dest '.'
  .pipe Gulp.dest 'pkg'

Gulp.task \package:files ->
  Gulp.src <[
    *.json
    *.md
  ]>
  .pipe Gulp.dest 'pkg'

Gulp.task \package:livescript ->
  Gulp.src <[
    index.ls
  ]>
  .pipe GulpLiveScript!
  .pipe Gulp.dest 'pkg'

Gulp.task \publish <[
  package
  publish:npm
  publish:tag
]>

Gulp.task \publish:tag <[ package:version ]> (done) !->
  (err, package-json) <-! FileSystem.read-file Path.join __dirname, 'package.json'

  if err?
    done err
    return

  package-data = JSON.parse package-json.to-string!

  (err) <-! GulpGit.tag package-data.version

  if err?
    done err
    return

  (err) <-! GulpGit.push

  if err?
    done err
    return

  done!
  return

Gulp.task \publish:npm <[ publish:tag ]> (done) !->
  ChildProcess.exec 'npm publish pkg' done
