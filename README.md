# meatballtracker

A twitter bot to check if [Boot and Shoe Service](http://bootandshoeservice.com/) in Oakland has meatballs on their menu for a given day, because they are delicious.

This all started as one of those workplace conversations:

> _@mroth: "I'll write a service to parse "meatballs" out of this and alert us when its on the menu"_
>
> &mdash; Tara Suan ([@tarasuan](https://twitter.com/tarasuan/)) [October 6, 2010](https://twitter.com/tarasuan/status/26583960263)

What, you thought I was joking?

## Setup

### Running on Heroku
Most setup is in a rake task as `heroku:configure`, but some additional notes below.

#### Don't forget to setup periodic tasks

Ya know, `heroku addons:add scheduler:standard; heroku addons:open scheduler` and then schedule `bundle exec ruby meatballtracker_main.rb` to run every 10 minutes.  Remember to set the `heroku config:set TWITTER_LIVE=true` environment variable to actually start posting live to Twitter.


### Local development
Remember you'll need `pdftotext` installed somewhere in your path.  Use a `.env` file to hold needed config variables.  An example of what the `.env` file might look like is the following:

    TWITTER_CONSUMER_KEY=teiYi8shsaMohne7loo1ai9I
    TWITTER_CONSUMER_SECRET=YaeJo7caEiMoX7EegaeQui6u
    TWITTER_OAUTH_TOKEN=5105551212-eigu5goVaixa7eeFaiJ4bae5zeezo6aG
    TWITTER_OAUTH_TOKEN_SECRET=MoX7EegaeQui6uYaeJo7caEi
    BITLY_USER=scoobydoo
    BITLY_APIKEY=R_EegaeQui6eQui6uYao7caEi
    TWITTER_LIVE=false

The `heroku:configure` Rake task assumes you have the [`heroku-config`](https://github.com/ddollar/heroku-config) plugin installed, and will use it to push your `.env` file variables to the server!

## Notes on refactor
This program predictably stopped working on the server in my closet when I moved to New York two years ago.  So recently it was revised to be more maintainable and run on a Heroku dyno because fuck it, why not? People still need meatballs, even if I'm too far away to eat them myself.  If you want to see the original hacky script, it's locateable under the `v1.0` git tag.
