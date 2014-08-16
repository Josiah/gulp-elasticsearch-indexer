# [gulp][gulp]-[elasticsearch][es]-indexer

[![NPM Version](https://badge.fury.io/js/gulp-elasticsearch-indexer.png)](http://badge.fury.io/js/gulp-elasticsearch-indexer)

> Index json documents in [Elastic Search][es] with [Gulp][gulp]

## Usage

### Install

```sh
npm install --save-dev gulp-elasticsearch-indexer
```

### Example

```js
var gulp = require('gulp');
var gulpElasticSearchIndexer = require('gulp-elasticsearch-indexer');

gulp.task('fixtures', function () {
    return gulp.src('data/**/*.json')
        .pipe(gulpElasticSearchIndexer());
});
```

### Connection configuration

Options are passed to the elastic search client so anything which adheres to the
[official documentation][es-client-config] is supported. This includes the
defaults specified in the official configuration.

```js
var gulp = require('gulp');
var gulpElasticSearch = require('gulp-elasticsearch-indexer');

gulp.task('fixtures', function () {
    return gulp.src('data/**/*.json')
        .pipe(gulpElasticSearchIndexer());
});

// is the same as

gulp.task('fixtures', function () {
    return gulp.src('data/**/*.json')
        .pipe(gulpElasticSearchIndexer({host: 'http://localhost:9200'}));
});
```
### Document indexing

The index, type and id of the document are determined from the file path
automatically. The id is determined from the filename of the document (without
the extension) then the type is the parent folder name and the index is the
grandparent folder name.

```
**/{index}/{type}/{id}.json
```

These values can be overwritten by passing setting the `index`, `type` and `id`
options of the elastic search indexer.

```js
var gulp = require('gulp');
var gulpElasticSearch = require('gulp-elasticsearch-indexer');

gulp.task('fixtures', function () {
    return gulp.src('data/**/*.json')
        .pipe(gulpElasticSearchIndexer({index: 'foo', type: 'bar', id: 'baz'}));
});
```

Additionally all supported options for [`client.index()`][es-client-index]
passed into the constructor will be used when indexing the document.

 [gulp]: http://gulpjs.com/ "GulpJS"
 [es]: http://elasticsearch.org "Elastic Search"
 [es-type]: http://elasticsearch.org "Elastic Search"
 [es-client-config]: http://www.elasticsearch.org/guide/en/elasticsearch/client/javascript-api/current/configuration.html "Elastic Search JavaScript Client Configuration"
 [es-client-index]: http://www.elasticsearch.org/guide/en/elasticsearch/client/javascript-api/current/api-reference.html#api-index
