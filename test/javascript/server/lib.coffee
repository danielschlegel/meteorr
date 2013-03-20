Meteor.publish "alladmingroups", ->
  AdminGroups.find {}

Meteor.publish "allUserData", ->
  Meteor.users.find {}

Meteor.publish "allDevices", ->
  Devices.find {}


#Meteor.methods({
checkuser = (user, pass) ->
  useremail = user
  userpassword = pass
  test = ""
  user = Meteor.users.findOne("emails.address": useremail)
  unless user
    [400, "no user"]
  else
    srp = user.services.password.srp
    verifier = Meteor._srp.generateVerifier(userpassword,
                                            identity: srp.identity
                                            salt: srp.salt
    )
    if verifier.verifier is srp.verifier
      auth_code = Meteor.uuid()
      Meteor.users.update
        "emails.address": useremail
      ,
        $set:
          authcode: auth_code
      , (error, res) ->
        unless error
          test = auth_code
        else
          error

      test
    else
      [400, "username password not match"]

fetchaccesstoken = (authcode) ->
  auth_code = authcode
  actoken = ""
  token = Meteor.uuid()
  when_ = +(new Date)
  Meteor.users.update
    authcode: auth_code
  ,
    $set:
      accesstoken:
        token: token
        when: when_
  , (error, res) ->
    unless error
      actoken = token
    else
      error

  actoken

gdec = Array()
alldecends = (gid) ->
  Groups.find(parent: gid).forEach (grp) ->
    gdec[gdec.length] = grp._id
    alldecends grp._id  unless Groups.find(parent: grp._id).count() is 0

  gdec

grpar = undefined
allchilds = (gid) ->
  Groups.find(parent: gid).forEach (grp) ->
    grpar[grpar.length] = grp
    allchilds grp._id  unless Groups.find(parent: grp._id).count() is 0


alLeafs = (gid) ->
  Groups.find(parent: gid).forEach (grp) ->
    grpar[grpar.length] = grp  if Groups.find(parent: grp._id).count() is 0
    alLeafs grp._id


checkDecend = (gid, cgid) ->
  flag = ""
  Groups.find(parent: gid).forEach (grp) ->
    flag = 1  if grp._id is cgid
    checkDecend grp._id, cgid  unless Groups.find(parent: grp._id).count() is 0

  true  if flag is 1

Meteor.methods
  sendinvite: (options) ->
    Accounts.emailTemplates.siteName = "dev.sertal.ch"
    Accounts.emailTemplates.from = "Sertal User Mgmt <admin@sertal.ch>"
    Accounts.sendEnrollmentEmail options.userId, options.email

  accountcreate: (options) ->
    Accounts.createUser options
