#!/usr/bin/ruby21


%w(rubygems mechanize).each {|lib| require lib }


module WoutTales
    def self.main
        cmdline
        @@mechanize = Mechanize.new do |agent|
            agent.user_agent = 'Linux / Firefox 29: Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0'
        end
        do_login
        @@wout = @@mechanize.get 'https://twitter.com/Wout123456'
        find_tales
    end


    def self.cmdline
        if ARGV.length == 2 then
            @@username = ARGV[0]
            @@password = ARGV[1]
        else
            puts "USAGE: #{$0} <username/email> <password>"
            exit! 0
        end
    end


    def self.find_tales
        
    end


    def self.do_login
        @@mechanize.get('http://www.twitter.com') do |page|
            page.form_with(action: 'https://twitter.com/sessions') do |form|
                form.fields[0].value = @@username
                form.fields[1].value = @@password
            end.submit
        end
    end
end

WoutTales.main if $0 == __FILE__

