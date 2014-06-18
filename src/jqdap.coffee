parser = require '../lib/parser'
xdr = require '../lib/xdr'

getBuffer = (data) ->
    b = new Array(data.length)
    for i in [0...data.length]
        b[i] = data.charCodeAt(i) & 0xff
    b


parseArg = (arg) ->
  {username, password, withCredentials} = arg
  options = {}
  if username?
    options.username = username
  if password?
    options.password = password
  if withCredentials?
    options.xhrFields =
      withCredentials: withCredentials
  options


loadData = (url, arg={}) ->
  options = parseArg arg
  options.dataType = 'binary'
  options.beforeSend = (xhr) ->
    xhr.overrideMimeType 'text/plain; charset=x-user-defined'
  options.converters =
    '* binary': (response) -> response
  $.ajax url, options
    .then (dods) ->
      pos = dods.indexOf '\nData:\n'
      dds = dods.substr 0, pos
      dods = getBuffer dods.substr pos + 7
      dapvar = new parser.ddsParser dds
        .parse()
      new xdr.dapUnpacker dods, dapvar
        .getValue()


loadDataset = (url, arg={}) ->
  options = parseArg arg
  ddsRequest = $.ajax url + '.dds', options
  dasRequest = $.ajax url + '.das', options
  $.when ddsRequest.promise(), dasRequest.promise()
    .then (dds, das) ->
      dataset = new parser.ddsParser dds[0]
        .parse()
      new parser.dasParser das[0], dataset
        .parse()


global.window.jqdap =
  loadData: loadData
  loadDataset: loadDataset
