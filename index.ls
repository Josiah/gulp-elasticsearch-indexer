require! ElasticSearch: 'elasticsearch'
require! Stream: 'readable-stream'
require! GulpUtil: 'gulp-util'
require! Package: './package'
require! Path: 'path'

class GulpElasticSearchIndexer extends Stream.Transform
  (@options = {}) !~>
    super object-mode: true
    @es = @extract-es @options

  _transform: (file, , next) ->
    if file.is-null! or file.is-stream!
      @push file
      next!
      return

    try
      body = JSON.parse file.contents
    catch err
      next new GulpUtil.PluginError Package.name, err
      return

    data = @options{
      # [Generic parameters](http://www.elasticsearch.org/guide/en/elasticsearch/client/javascript-api/current/api-conventions.html#_generic_parameters)
      method
      body
      ignore

      # [Index API parameters](http://www.elasticsearch.org/guide/en/elasticsearch/client/javascript-api/current/api-reference.html#_params_17)
      consistency
      parent
      refresh
      replication
      routing
      timeout
      timestamp
      ttl
      version
      version-type
      id
      index
      type
    }

    file-defaults = @extract-file-defaults file

    data.id    ?= file-defaults.id
    data.type  ?= file-defaults.type
    data.index ?= file-defaults.index

    data.body ?= {}
    data.body <<< body

    (err) <~! @es.index data

    if err?
      next new GulpUtil.PluginError Package.name, err
      return

    @push file
    next!
    return

  extract-file-defaults: (file) ->
    extname = Path.extname file.path
    path = file.path
    id = Path.basename path, extname

    path = Path.dirname path
    type = Path.basename path

    path = Path.dirname path
    index = Path.basename path

    return {index, type, id}

  extract-es: (options = {}) ->
    return options.elasticsearch if options.elasticsearch?
    return options.es if options.es?
    return new ElasticSearch.Client options

module.exports = GulpElasticSearchIndexer
