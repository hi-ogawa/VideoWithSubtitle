// Generated by CoffeeScript 1.9.3
(function() {
  var videosubApp;

  videosubApp = angular.module('videosubApp', ['ngAnimate', 'ngSanitize', 'ngCookies', 'yqlService', 'parseService']);

  videosubApp.controller('videosubCtrl', [
    '$scope', '$sce', '$cookies', 'getHTMLwithYQL', 'parsers', (function($scope, $sce, $cookies, getHTMLwithYQL, parsers) {
      var loadScope, saveScope, url0, url1, url2, url3, url4;
      $scope.on = true;
      $scope.x = 1;
      $scope.y = 0;
      loadScope = function() {
        var scope;
        if (($cookies.get('existence') != null) && $cookies.get('existence')) {
          return scope = $cookies.get('scope');
        }
      };
      saveScope = function() {
        $cookies.put('existence', true);
        return $cookies.put('scope', $scope);
      };
      url0 = function(query) {
        return "http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=" + query;
      };
      url1 = function(query) {
        return "http://tvonline.tw/search.php?key=" + query;
      };
      url2 = function(path) {
        return "http://www.springfieldspringfield.co.uk" + path;
      };
      url3 = function(path) {
        return "http://tvonline.tw/" + path;
      };
      url4 = function(path) {
        return "http://www.springfieldspringfield.co.uk/" + path;
      };
      $scope.searchTitles = function() {
        $scope.loading0 = true;
        getHTMLwithYQL(url0($scope.titleQuery)).then(function(html) {
          var items;
          $scope.loading0 = false;
          items = parsers.getTitlesFromSpringfield(html);
          $scope.springfieldTitleSuggestions = items;
          return $scope.springfieldTitle = items[0].val;
        });
        $scope.loading1 = true;
        return getHTMLwithYQL(url1($scope.titleQuery)).then(function(html) {
          var items;
          $scope.loading1 = false;
          items = parsers.getTitlesFromTVOnline(html);
          $scope.tvonlineTitleSuggestions = items;
          return $scope.tvonlineTitle = items[0].val;
        });
      };
      $scope.$watch('springfieldTitle', function(newValue, oldValue) {
        if (newValue) {
          $scope.loading2 = true;
          return getHTMLwithYQL(url2(newValue)).then(function(html) {
            var items;
            $scope.loading2 = false;
            items = parsers.getEpisodesFromSpringfield(html);
            $scope.springfieldEpisodes = items;
            return $scope.springfieldEpisode = items[0].val;
          });
        }
      });
      $scope.$watch('tvonlineTitle', function(newValue, oldValue) {
        if (newValue) {
          $scope.loading3 = true;
          return getHTMLwithYQL(url3(newValue)).then(function(html) {
            var items;
            $scope.loading3 = false;
            items = parsers.getEpisodesFromTVOnline(html);
            $scope.tvonlineEpisodes = items;
            return $scope.tvonlineEpisode = items[0].val;
          });
        }
      });
      $scope.$watch('tvonlineEpisode', function(newValue, oldValue) {
        if (newValue) {
          $scope.loading4 = true;
          return getHTMLwithYQL(url3(newValue)).then(function(html) {
            var comp, items;
            $scope.loading4 = false;
            comp = function(i, j) {
              if (i.name === 'nowvideo' || i.name === 'movshare') {
                return -1;
              } else {
                return 1;
              }
            };
            items = parsers.getEmbedVideos(html).sort(comp);
            $scope.embedVideoUrls = items;
            return $scope.embedVideoUrl = items[0].val;
          });
        }
      });
      $scope.$watch('springfieldEpisode', function(newValue, oldValue) {
        if (newValue) {
          $scope.loading5 = true;
          return getHTMLwithYQL(url4(newValue)).then(function(html) {
            $scope.loading5 = false;
            return $scope.subtitle = parsers.getSubtitle(html);
          });
        }
      });
      $scope.trustSrc = function(src) {
        return $sce.trustAsResourceUrl(src);
      };
      $scope.buttonColor = function(x, y, x_, y_) {
        if (x === x_ && y === y_) {
          return 'btn-warning';
        } else {
          return 'btn-default';
        }
      };
      return $scope.position = function(x, y) {
        return "subtitle-position-" + (x.toString()) + (y.toString());
      };
    })
  ]);

}).call(this);
