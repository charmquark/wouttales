#!/usr/bin/env ruby

LIBS = %w(rubygems htmlentities curl chatterbot/dsl)
LIBS.each {|lib| require lib }


HASHTAG     = '#WoutTales'
WOUT_USER   = 'Wout123456'

MSG_BASE    = "@#{WOUT_USER} #{HASHTAG} "

MAX_QUOTE_ATTEMPTS  = 10
MAX_QUOTE_LENGTH    = 140 - MSG_BASE.length
QUOTE_SOURCES       = %w(math prog_style).join '+'
QUOTE_URL           = "http://www.iheartquotes.com/api/v1/random?source=#{QUOTE_SOURCES}"


$curl = CURL.new
$entities = HTMLEntities.new
def get_quote
    result = ''
    attempts = 0
    loop do
        quote = $curl.get(QUOTE_URL).squeeze(" \n").split("\n")
        quote = quote.slice(0, quote.length - 1).join(' ')
        quote = $entities.decode quote

        if quote.length <= MAX_QUOTE_LENGTH then
            result = quote
            break
        end

        attempts += 1
        break if attempts >= MAX_QUOTE_ATTEMPTS
    end
    return result
end


# remove this to send out tweets
#debug_mode


# remove this to update the db
#no_update


# remove this to get less output when running
#verbose


# here's a list of users to ignore
#blacklist "abc", "def"


# here's a list of things to exclude from searches
#exclude "hi", "spammer", "junk"


#loop do
    search "from:#{WOUT_USER} '[1]'" do |tweet|
    #search "from:wolfygeek" do |tweet|
        next if tweet.text.start_with? '[1]'
        next unless tweet.text.include? '[1]'
        #puts "<< #{tweet.text} >>"
        quote = get_quote
        reply "#{MSG_BASE}#{quote}", tweet
    end

    update_config

#     sleep 120
# end

