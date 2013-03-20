Meteor.publish "alltenants", ->

  #return Tenants.find( {} );
  tntar = new Array()
  if @userId
    if AdminGroups.find($and: [
      name: "sysAdmin"
    ,
      "users.user": @userId
    ]).count()
      Tenants.find {}
    else
      AdminGroups.find("users.user": @userId).forEach (admin) ->
        unless Applications.find(adminGroup: admin._id).count() is 0
          Applications.find(adminGroup: admin._id).forEach (app) ->
            for key of app.tenants
              tntar[tntar.length] = app.tenants[key].tname

        unless Tenants.find(adminGroup: admin._id).count() is 0
          Tenants.find(adminGroup: admin._id).forEach (tnt) ->
            tntar[tntar.length] = tnt._id

        unless Groups.find(adminGroup: admin._id).count() is 0

          #console.log("here1 :" + Groups.find({adminGroup: admin._id}).count());
          Groups.find(adminGroup: admin._id).forEach (grp) ->
            tntar[tntar.length] = grp.tenant



      # console.log(tntar);
      #console.log(Tenants.find({_id:{$in:tntar}} ));
      Tenants.find _id:
                     $in: tntar

