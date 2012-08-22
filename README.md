# ScoutAlerter
Simple app to recieve webhooks calls from Scout and send alerts via Boxcar. Can be extended for more notification options.

## Prerequisites
* Register a provider on Boxcar - http://boxcar.io/site/providers/new (requires account)
* Heroku account

## Setting it up

Clone the repository, and create a new Heroku app:

$ heroku create

Configure the Boxcar provider:

$ heroku set BOXCAR_KEY=… BOXCAR_SECRET=…

Add RedisToGo addon:

$ heroku addons:add redistogo:nano

Deploy:

$ git push heroku master

Once deployed, you can test that sending messages works by calling http://your-app-name.herokuapp.com/test_message -- this should issue a message via Boxcar.

After that configure your webhook callback url in Scout's settings. 

You can use Redis to filter which hosts should issue alert by writing comma delimited list of hosts to ignore to `filtered_hostnames`.

## License

MIT License. Copyright 2012 GetTaxi & Arik Fraimovich.