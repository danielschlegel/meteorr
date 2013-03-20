Meteor.publish "allapps", ->
  apar = new Array()

  # var self = this;
  if @userId

    # console.log("flag is: " +flag);
    if AdminGroups.find($and: [
      name: "sysAdmin"
    ,
      "users.user": @userId
    ]).count()
      Applications.find {}
    else
      AdminGroups.find("users.user": @userId).forEach (admin) ->
        unless Applications.find(adminGroup: admin._id).count() is 0
          Applications.find(adminGroup: admin._id).forEach (app) ->
            apar[apar.length] = app._id

        unless Tenants.find(adminGroup: admin._id).count() is 0
          Tenants.find(adminGroup: admin._id).forEach (tnt) ->
            Applications.find("tenants.tname": tnt._id).forEach (app) ->
              apar[apar.length] = app._id


        unless Groups.find(adminGroup: admin._id).count() is 0
          Groups.find(adminGroup: admin._id).forEach (grp) ->
            Applications.find("tenants.tname": grp.tenant).forEach (app) ->
              apar[apar.length] = app._id




      #console.log(Groups.find({adminGroup: admin._id}).count());
      #console.log(apar.length);

      #console.log('inner' + apar);

      #console.log(apar);
      Applications.find _id:
                          $in: apar

