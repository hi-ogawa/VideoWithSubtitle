@app.service "Auth", ($firebaseObject, $firebaseArray, $firebaseAuth, FIREBASE_DOMAIN, ENV, $state) ->
  @authObj = $firebaseAuth new Firebase FIREBASE_DOMAIN

  @currentUser = null
  @userItems   = null

  @login = ->
    @authObj.$authWithOAuthPopup "facebook", scope: "public_profile"
    .then  (authData) =>
      @setUser authData
      .then =>
        @currentUser.name = authData.facebook.cachedUserProfile.first_name
        @currentUser.$save()
        $state.go $state.current, {}, {reload: true}

    .catch (err) ->
      # TODO: handle error
      console.log err

  @logout = ->
    @authObj.$unauth()
    @currentUser = null
    @userItems = null
    $state.go "watch"

  @setUser = (authData) ->
    @currentUser = $firebaseObject new Firebase [FIREBASE_DOMAIN, ENV, "users", authData.uid].join "/"
    @currentUser.$loaded()

  @setItems = ->
    @currentUser.$loaded()
    .then =>
      @userItems = $firebaseArray @currentUser.$ref().child("items")
      @userItems.$loaded()

  @
