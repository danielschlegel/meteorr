if Meteor.isClient
  Session.set "loging", false
  Template.body.loggedin = ->
    Session.get "logging"

  Session.set "afterauth", false
  Template.login.afterauth = ->
    Session.get "afterauth"

  Template.login.events
    "click #submit": (event, template) ->
      uname = template.find(".uname").value
      pword = template.find(".pword").value
      appkey = template.find(".appkey").value
      Meteor.call "testing",
                  uname: uname
                  pword: pword
                  appkey: appkey
      , (error, result) ->
        unless error
          unless result.content is "no app"
            Session.set "authcode", result.content
            Session.set "appkey", appkey
            Session.set "afterauth", true
          else
            alert result.content


    "click .access": (event, template) ->
      appsecret = template.find(".appsecret").value
      Meteor.call "gettoken",
                  authcode: Session.get("authcode")
                  appkey: Session.get("appkey")
                  appsecret: appsecret
      , (error, result) ->
        unless error

          #alert(result.content);
          Session.set "accesstoken", result.content
          Session.set "logging", true


  Template.content.events
    "click .getresult": (event, template) ->
      method = template.find(".method").value
      id = undefined
      if method is "tenantlist"
        id = Session.get("appkey")
      else
        id = template.find(".id").value

      #alert(method);
      #alert(id);
      Meteor.call method,
                  id: id
                  accesstoken: Session.get("accesstoken")
                  auth: Session.get("authcode")
      , (error, result) ->
        unless error

          #for(var key in result.data){ alert(key); alert(result.data[key]) }
          Session.set "resultofmethod", result.content
        else
          alert result.content


    "click .logout": ->
      Meteor.call "logoutuser",
                  auth: Session.get("authcode")
      , (error) ->
        unless error

          #alert('logged out');
          Session.set "afterauth", false
          Session.set "logging", false
        else
          alert error


  Session.set "resultofmethod", "no result"
  Handlebars.registerHelper "result", ->
    str = Session.get("resultofmethod")
    new Handlebars.SafeString(str)
