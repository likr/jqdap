$(function() {
  $('form#request').submit(function() {
    var endpoint = document.getElementById('endpoint').value;
    var query = document.getElementById('query').value;
    var username = document.getElementById('username').value;
    var password = document.getElementById('password').value;
    var options = {};
    if (username || password) {
      options.username = username;
      options.password = password;
      options.withCredentials = true;
    }
    jqdap.loadData(endpoint + '.dods?' + query, options)
      .then(function(data) {
        document.getElementById('data').value = JSON.stringify(data);
      });
    jqdap.loadDataset(endpoint, options)
      .then(function(dataset) {
        document.getElementById('dataset').value = JSON.stringify(dataset);
      });
    return false;
  });
});
