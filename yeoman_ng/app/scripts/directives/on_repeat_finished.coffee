@app.directive "onRepeatFinished", ($timeout) ->
  restrict: "A"
  link: (scope, element, attrs) ->
    if scope.$last
      $timeout ->
        scope.$eval attrs["onRepeatFinished"]
