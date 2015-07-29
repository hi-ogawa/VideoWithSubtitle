// Generated by CoffeeScript 1.9.3
(function() {
  var videosubApp;

  videosubApp = angular.module('videosubApp', ['ngAnimate', 'ngSanitize', 'ngStorage', 'yqlService', 'parseService']);

  videosubApp.controller('videosubCtrl', [
    '$scope', '$sce', '$localStorage', 'getHTMLwithYQL', 'parsers', (function($scope, $sce, $localStorage, getHTMLwithYQL, parsers) {
      var storageProps, url0, url1, url2, url3, url4;
      $scope.settingOn = true;
      $scope.historyOn = false;
      $scope.x = 1;
      $scope.y = 0;
      $scope.$storage = $localStorage;
      storageProps = ['titleQuery', 'tvonlineTitle', 'tvonlineEpisode', 'tvonlineEpisodes', 'videoProvider', 'videoProviders', 'springfieldTitle', 'springfieldEpisode', 'springfieldEpisodes'];
      if ($scope.$storage.history == null) {
        $scope.$storage.history = [];
      }
      $scope.putNewData = function() {
        var currentData;
        currentData = _.pick($scope, storageProps);
        $scope.$storage.history.push(currentData);
        return $scope.$storage.now = currentData;
      };
      $scope.loadData = function(data) {
        $scope.$storage.now = data;
        return storageProps.forEach(function(p) {
          return $scope[p] = data[p];
        });
      };
      $scope.deleteData = function(data) {
        return $scope.$storage.history.splice($scope.$storage.history.indexOf(data), 1);
      };
      if ($scope.$storage.now != null) {
        $scope.loadData($scope.$storage.now);
      }
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
        getHTMLwithYQL(url0(encodeURIComponent($scope.titleQuery))).then(function(html) {
          var items;
          $scope.loading0 = false;
          items = parsers.getTitlesFromSpringfield(html);
          $scope.springfieldTitleSuggestions = items;
          return $scope.springfieldTitle = items[0];
        });
        $scope.loading1 = true;
        return getHTMLwithYQL(url1(encodeURIComponent($scope.titleQuery))).then(function(html) {
          var items;
          $scope.loading1 = false;
          items = parsers.getTitlesFromTVOnline(html);
          $scope.tvonlineTitleSuggestions = items;
          return $scope.tvonlineTitle = items[0];
        });
      };
      $scope.showSpringfielEpisodes = function() {
        $scope.loading2 = true;
        return getHTMLwithYQL(url2($scope.springfieldTitle.val)).then(function(html) {
          var items;
          $scope.loading2 = false;
          items = parsers.getEpisodesFromSpringfield(html);
          $scope.springfieldEpisodes = items;
          return $scope.springfieldEpisode = items[0];
        });
      };
      $scope.showSubtitle = function() {
        $scope.subtitleAppearance = true;
        $scope.loading5 = true;
        return getHTMLwithYQL(url4($scope.springfieldEpisode.val)).then(function(html) {
          $scope.loading5 = false;
          return $scope.subtitle = parsers.getSubtitle(html);
        });
      };
      $scope.showTVOnlineEpisodes = function() {
        $scope.loading3 = true;
        return getHTMLwithYQL(url3($scope.tvonlineTitle.val)).then(function(html) {
          var items;
          $scope.loading3 = false;
          items = parsers.getEpisodesFromTVOnline(html);
          $scope.tvonlineEpisodes = items;
          return $scope.tvonlineEpisode = items[0];
        });
      };
      $scope.showTVOnlineVideoProviders = function() {
        $scope.loading4 = true;
        return getHTMLwithYQL(url3($scope.tvonlineEpisode.val)).then(function(html) {
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
          $scope.videoProviders = items;
          return $scope.videoProvider = items[0];
        });
      };
      $scope.showVideo = function() {
        return $scope.embedVideoUrl = $scope.videoProvider.val;
      };
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
      $scope.position = function(x, y) {
        return "subtitle-position-" + (x.toString()) + (y.toString());
      };
      return $scope.jumpEpisode = function(i) {
        var currentIndex0, currentIndex1, dest0, dest1;
        currentIndex0 = $scope.tvonlineEpisodes.map(function(e) {
          return e.val;
        }).indexOf($scope.tvonlineEpisode.val);
        dest0 = $scope.tvonlineEpisodes[currentIndex0 + i];
        if (dest0 != null) {
          $scope.tvonlineEpisode = dest0;
          $scope.showTVOnlineVideoProviders();
        }
        currentIndex1 = $scope.springfieldEpisodes.map(function(e) {
          return e.val;
        }).indexOf($scope.springfieldEpisode.val);
        dest1 = $scope.springfieldEpisodes[currentIndex1 + i];
        if (dest1 != null) {
          return $scope.springfieldEpisode = dest1;
        }
      };
    })
  ]);

}).call(this);
