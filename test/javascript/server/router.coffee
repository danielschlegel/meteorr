Meteor.Router.add
  "/authcode": ->
    checkuser @request.query.uname, @request.query.pword  unless Applications.findOne(_id: @request.query.appkey) is `undefined`

  "/accesstoken": ->
    if Applications.findOne($and: [
      "secretkey.srp.identity": @request.query.asecret
    ,
      _id: @request.query.appkey
    ]) is `undefined`
      [404, "no application with your secret key and appkey combination"]
    else
      fetchaccesstoken @request.query.authcode

  "/tenantList": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken

      # console.log(true);
      @response.setHeader "Content-Type", "application/json"
      tarr = new Array()
      sapp = Applications.findOne(_id: @request.query.appid)
      unless sapp is `undefined`
        for key of sapp.tenants
          tarr[tarr.length] = Tenants.findOne(_id: sapp.tenants[key].tname)
        jsntarr = JSON.stringify(tarr)
        jsntarr
      else
        [404, "no application with this id"]
    else
      [404, "token invalid"]

  "/tenant": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      jsntar = new Array()
      @response.setHeader "Content-Type", "application/json"
      unless Tenants.findOne(_id: @request.query.tenid) is `undefined`
        jsntar = JSON.stringify(Tenants.findOne(_id: @request.query.tenid))
        jsntar
      else
        [404, "no tenant with this id"]
    else
      [404, "token invalid"]

  "/groupList": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      grpar = new Array()
      @response.setHeader "Content-Type", "application/json"
      tgrps = Groups.find(tenant: @request.query.tenid)
      tgrps.forEach (grp) ->
        grpar[grpar.length] = grp

      jsngrp = JSON.stringify(grpar)
      jsngrp
    else
      [404, "token invalid"]

  "/gancestors": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      grpar = new Array()
      @response.setHeader "Content-Type", "application/json"
      grp = Groups.findOne(_id: @request.query.grpid)
      if grp
        unless grp.parent is ""
          until grp.parent is ""
            grp = Groups.findOne(_id: grp.parent)
            grpar[grpar.length] = grp
          jsngrp = JSON.stringify(grpar)
          jsngrp
      else
        [404, "parameter invalid"]
    else
      [404, "token invalid"]

  "/gusers": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      sgrp = Groups.findOne(_id: @request.query.grpid)
      if sgrp
        @response.setHeader "Content-Type", "application/json"
        unless sgrp.users is ""
          uarr = new Array()
          for key of sgrp.users
            uarr[uarr.length] = Meteor.users.findOne(_id: sgrp.users[key].user)
          jsntarr = JSON.stringify(uarr)
          jsntarr
      else
        [404, "parameter invalid"]
    else
      [404, "token invalid"]

  "/userGroups": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      ngarr = new Array()
      @response.setHeader "Content-Type", "application/json"
      usr = Meteor.users.findOne(_id: @request.query.userid)
      for key of usr.groups
        grp = Groups.findOne(_id: usr.groups[key].group)
        ngarr[ngarr.length] = grp
        unless grp.parent is ""
          until grp.parent is ""
            grp = Groups.findOne(_id: grp.parent)
            ngarr[ngarr.length] = grp
      jsntarr = JSON.stringify(ngarr)
      jsntarr
    else
      [404, "token invalid"]

  "/directGroups": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      ngarr = new Array()
      @response.setHeader "Content-Type", "application/json"
      usr = Meteor.users.findOne(_id: @request.query.userid)
      if usr
        for key of usr.groups
          grp = Groups.findOne(_id: usr.groups[key].group)
          ngarr[ngarr.length] = grp
        jsntarr = JSON.stringify(ngarr)
        jsntarr
      else
        [404, "parameter invalid"]
    else
      [404, "token invalid"]

  "/userTenants": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      user = Meteor.users.findOne(_id: @request.query.userid)
      if user
        tntar = new Array()
        @response.setHeader "Content-Type", "application/json"
        for key1 of user.groups
          tnt = Tenants.findOne(_id: Groups.findOne(_id: user.groups[key1].group).tenant)
          unless tntar.length is 0
            for key2 of tntar
              flag = 0
              if tntar[key2].tname is tnt.tname
                flag = 1
                break
            tntar[tntar.length] = tnt  if flag is 0
        jsngrp = JSON.stringify(tntar)
        jsngrp
      else
        [404, "parameter invalid"]
    else
      [404, "token invalid"]

  "/tenantUsers": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      @response.setHeader "Content-Type", "application/json"
      uarr = new Array()
      Groups.find(tenant: @request.query.tenid).forEach (grp) ->
        unless grp.users.length is 0
          if uarr.length is 0
            for key of grp.users
              uarr[uarr.length] = Meteor.users.findOne(_id: grp.users[key].user)
          else
            for key1 of grp.users
              for key2 of uarr
                flag = 0
                if uarr[key2]._id is grp.users[key1].user
                  flag = 1
                  break
              uarr[uarr.length] = Meteor.users.findOne(_id: grp.users[key1].user)  if flag is 0

      unless uarr.length is 0
        jsntarr = JSON.stringify(uarr)
        jsntarr
    else
      [404, "token invalid"]

  "/gdescendants": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      unless @request.query.grpid is ""
        grpar = new Array()
        @response.setHeader "Content-Type", "application/json"
        if Groups.find(parent: @request.query.grpid).count() is 0
          return [404, "no child groups"]
        else
          allchilds @request.query.grpid
        jsngrp = JSON.stringify(grpar)
        jsngrp
      else
        [404, "parameter invalid"]
    else
      [404, "token invalid"]

  "/gleafs": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      unless @request.query.grpid is ""
        grpar = new Array()
        @response.setHeader "Content-Type", "application/json"
        if Groups.find(parent: @request.query.grpid).count() is 0
          return [404, "this is the leaf node"]
        else
          alLeafs @request.query.grpid
        jsngrp = JSON.stringify(grpar)

        #  console.log(grpar);
        jsngrp
      else
        [404, "parameter invalid"]
    else
      [404, "token invalid"]


  #public access methods
  "/isAncestor": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      usr = Meteor.users.findOne(authcode: @request.query.auth)
      if usr
        flag = 0
        for key of usr.groups
          grp = Groups.findOne(_id: usr.groups[key].group)
          until grp.parent is ""
            grp = Groups.findOne(_id: grp.parent)
            if grp._id is @request.query.grpid
              flag = 1
              break
          break  if flag is 1
        if flag is 1
          [404, "TRUE"]
        else
          [404, "FALSE"]
      else
        [404, "no group matched with id"]
    else
      [404, "token invalid"]

  "/isDecendant": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      usr = Meteor.users.findOne(authcode: @request.query.auth)
      if usr
        flag = ""
        for key of usr.groups
          flag = checkDecend(usr.groups[key].group, @request.query.grpid)
          break  if flag
        if flag
          [404, "TRUE"]
        else
          [404, "FALSE"]
      else
        [404, "no group with id"]
    else
      [404, "token invalid"]

  "/isMemberOfTenant": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      usr = Meteor.users.findOne(authcode: @request.query.auth)
      flag = ""
      for key of usr.groups
        if Groups.findOne(_id: usr.groups[key].group).tenant is @request.query.tenid
          flag = 1
          break
      if flag is 1
        [404, "TRUE"]
      else
        [404, "FALSE"]
    else
      [404, "token invalid"]

  "/isMemberOf": ->
    if Meteor.users.findOne(authcode: @request.query.auth).accesstoken.token is @request.query.accesstoken
      usr = Meteor.users.findOne(authcode: @request.query.auth)
      flag = ""
      for key of usr.groups
        if usr.groups[key].group is @request.query.grpid
          flag = 1
          break
      if flag is 1
        [404, "TRUE"]
      else
        [404, "FALSE"]
    else
      [404, "token invalid"]

  "/logoutUser": ->
    auth = @request.query.auth
    Meteor.users.update
      authcode: auth
    ,
      $set:
        accesstoken:
          token: ""
          when: ""

    true


  # get the Group JSON by techName
  "/getGroupByTechName": ->
    unless Applications.findOne($and: [
      "secretkey.srp.identity": @request.query.appsecret
    ,
      _id: @request.query.appkey
    ]) is `undefined`
      group = Groups.findOne(groupname: @request.query.groupname)
      if group
        if Applications.findOne(
          _id: @request.query.appkey
          tenants:
            tname: group.tenant
        ) is `undefined`
          [404, "group not in app"]
        else
          [200,
           "Content-type": "application/json"
          , EJSON.stringify(group)]
      else
        [404, "no group " + @request.query.groupname]


  # get the Tenant JSON by techName
  "/getTenantByTechName": ->
    console.log "got request for tenant " + @request.query.tenantname + " at " + (new Date())
    unless Applications.findOne($and: [
      "secretkey.srp.identity": @request.query.appsecret
    ,
      _id: @request.query.appkey
    ]) is `undefined`
      tenant = Tenants.findOne(tname: @request.query.tenantname)
      if tenant
        if Applications.findOne(
          _id: @request.query.appkey
          tenants:
            tname: tenant._id
        ) is `undefined`
          console.log "returning tenant not in app"
          return [404, "tenant not in app"]
        else
          console.log "returning tenant JSON"
          return [200,
                  "Content-type": "application/json"
          , EJSON.stringify(tenant)]
      else
        console.log "returning tenant does not exist"
        return [404, "no tenant " + @request.query.tenantname]
    console.log "returning nothing at all"
