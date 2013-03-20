Meteor.publish "allgroups", ->
  grpar = new Array()
  if @userId
    if AdminGroups.find($and: [
      name: "sysAdmin"
    ,
      "users.user": @userId
    ]).count()
      Groups.find {}
    else
      AdminGroups.find("users.user": @userId).forEach (admin) ->
        unless Applications.find(adminGroup: admin._id).count() is 0
          Applications.find(adminGroup: admin._id).forEach (app) ->
            for key of app.tenants
              Groups.find(tenant: app.tenants[key].tname).forEach (grp) ->
                grpar[grpar.length] = grp._id


        unless Tenants.find(adminGroup: admin._id).count() is 0
          Tenants.find(adminGroup: admin._id).forEach (tnt) ->
            Groups.find(tenant: tnt._id).forEach (grp) ->
              grpar[grpar.length] = grp._id


        unless Groups.find(adminGroup: admin._id).count() is 0
          Groups.find(adminGroup: admin._id).forEach (grp) ->
            grpar[grpar.length] = grp._id
            Groups.find(_id:
                          $in: alldecends(grp._id)
            ).forEach (grp) ->
              grpar[grpar.length] = grp._id



      Groups.find _id:
                    $in: grpar

