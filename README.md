# README

## Exchanges

Currently its only working with BITFINEX

## Getting started

- Create API Keys on [Bitfinex](https://www.bitfinex.com/api) UI
- Copy .env.sample to .env and insert your credentials created in the previous step

## Starting Rails App (api only) 
- install rvm with stable ruby `\curl -sSL https://get.rvm.io | bash -s stable --ruby`
- install bundler `gem install bundler`
- install all gems and dependencies `bundle install`
- start rails `rails s`

## runnning rake tasks

1. task to import wallets 

    `rake bitfinex:wallets:create`

2. task to import trades 

    `rake bitfinex:trades:load`

3. task to import movements 

    `rake bitfinex:movements:load`
