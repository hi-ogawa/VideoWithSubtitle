// Generated by CoffeeScript 1.9.3
(function() {
  var yqlService;

  yqlService = angular.module('yqlService', []);

  yqlService.factory('getHTMLwithYQL', [
    '$q', function($q) {
      var getHTMLwithYQL;
      getHTMLwithYQL = function(url) {
        var deferred, yql;
        deferred = $q.defer();
        yql = "http://query.yahooapis.com/v1/public/yql?q=" + encodeURIComponent("select * from html where url='" + url + "'") + "&format=xml&callback=?";
        $.ajax({
          dataType: 'json',
          url: yql,
          success: function(data) {
            return deferred.resolve($.parseHTML(data.results[0]));
          }
        });
        return deferred.promise;
      };
      return getHTMLwithYQL;
    }
  ]);

}).call(this);
