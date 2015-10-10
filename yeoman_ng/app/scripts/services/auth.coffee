@app.service "Auth", ($firebaseObject, $firebaseAuth, FIREBASE_DOMAIN, ENV, $state) ->
  @authObj = $firebaseAuth new Firebase FIREBASE_DOMAIN

  @currentUser = null

  @login = ->
    @authObj.$authWithOAuthPopup "facebook", scope: "public_profile"
    .then  (authData) =>
      @setUser authData
      @currentUser.name = authData.facebook.cachedUserProfile.first_name
      @currentUser.$save()

    .catch (err) ->
      # TODO: handle error
      console.log err

  @logout = ->
    @authObj.$unauth()
    @currentUser = null
    $state.go "watch"

  @setUser = (authData) ->
    @currentUser = $firebaseObject new Firebase [FIREBASE_DOMAIN, ENV, authData.uid].join "/"

  @
