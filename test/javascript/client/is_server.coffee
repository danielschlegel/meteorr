if Meteor.isServer
  Meteor.methods
    testing: (options) ->

      #this.unblock();
      whentime = new Date()
      options = options or {}
      auth = Meteor.http.get("http://localhost:3000/authcode",
                             params:
                               uname: options.uname
                               pword: options.pword
                               appkey: options.appkey
      )
      whentime2 = new Date()
      diff = whentime2 - whentime
      console.log "time taken for the method: " + diff
      auth

    gettoken: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/accesstoken",
                      params:
                        asecret: options.appsecret
                        appkey: options.appkey
                        authcode: options.authcode


    tenantlist: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/tenantList",
                      params:
                        appid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    tenant: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/tenant",
                      params:
                        tenid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    grouplist: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/groupList",
                      params:
                        tenid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    gancestors: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/gancestors",
                      params:
                        grpid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    gusers: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/gusers",
                      params:
                        grpid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    usergroups: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/userGroups",
                      params:
                        userid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    directgroups: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/directGroups",
                      params:
                        userid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    usertenants: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/userTenants",
                      params:
                        userid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    tenantusers: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/tenantUsers",
                      params:
                        tenid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    gdecenders: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/gdescendants",
                      params:
                        grpid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    gleafs: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/gleafs",
                      params:
                        grpid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    logoutuser: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/logoutUser",
                      params:
                        auth: options.auth


    isAncestor: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/isAncestor",
                      params:
                        grpid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    isDecendant: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/isDecendant",
                      params:
                        grpid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    isMemberOfTenant: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/isMemberOfTenant",
                      params:
                        tenid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken


    isMemberOf: (options) ->
      options = options or {}
      Meteor.http.get "http://localhost:3000/isMemberOf",
                      params:
                        grpid: options.id
                        auth: options.auth
                        accesstoken: options.accesstoken

