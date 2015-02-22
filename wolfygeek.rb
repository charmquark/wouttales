#!/usr/bin/env ruby

LIBS = %w(rubygems htmlentities curl chatterbot/dsl)
LIBS.each {|lib| require lib }


# remove this to send out tweets
#debug_mode

# remove this to update the db
#no_update

# remove this to get less output when running
#verbose


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
    1.upto(MAX_QUOTE_ATTEMPTS) do
        quote = $curl.get(QUOTE_URL).squeeze(" \n").split("\n")
        quote = quote.slice(0, quote.length - 1).join(' ')
        quote = $entities.decode quote

        if quote.length <= MAX_QUOTE_LENGTH then
            result = quote
            break
        end
    end
    result
end


#loop do
    search "from:#{WOUT_USER} '[1]'" do |tweet|
        #next if tweet.text.start_with? '[1]'
        next unless tweet.text.index(/^\s*(?:@[a-zA-Z0-9_]+\s*)*\s*\[1\]/).nil?
        next unless tweet.text.include? '[1]'

        #puts "<< #{tweet.text} >>"
        reply "#{MSG_BASE}#{get_quote}", tweet
    end

    update_config

#     sleep 300
# end

