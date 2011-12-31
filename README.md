# Eve Online API

I want to play with some of the data in EVE. CCP provide an API. Yay!

This README is a little lame because this code doesn't do much yet.
You can pull the SOV info and the skill tree. I'll (slowly) be working on exposing the other parts of the API, but of course, patches would be lovely.


## Example use

    require 'eve_online/api'

    require 'logger'
    logger = Logger.new STDOUT
    logger.level = Logger::DEBUG

    client = EveOnline::Api::Client.new :logger => logger
    puts client.sovereignty.to_s
    puts client.skill_tree.to_s


## Licence

MIT. See LICENSE.


## Authors

Craig R Webster <http://barkingiguana.com/>