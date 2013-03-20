# code to run on server at startup
Meteor.startup ->
  process.env.MAIL_URL = "smtp://sertalum:temp$123@smtp.gmail.com"

  #var sendVerificationEmail = true;

  #console.log(AdminGroups.find().count());
  AdminGroups.insert name: "sysAdmin"  unless AdminGroups.find().count()
