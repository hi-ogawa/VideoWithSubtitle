'use strict'

###*
 # @ngdoc function
 # @name mainAppApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the mainAppApp
###
angular.module 'mainAppApp'
  .controller 'MainCtrl', ->
    @awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
    return
