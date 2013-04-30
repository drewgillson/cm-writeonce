require "net/http"
require "cgi"
require "cm-writeonce/version"

module CmWriteonce
    
    require 'createsend'
    require 'date'

    def self.initialize(cm_key, cm_list)
        @cm_key = cm_key
        @cm_list = cm_list
        @now = DateTime.now.to_time.to_i
        @auth = {:api_key => @cm_key}
        cs = CreateSend::CreateSend.new @auth

        @list = CreateSend::List.new @auth, @cm_list

        records = @list.active '1970-01-01', 1, 10
        puts records.inspect
    end

=begin
    def self.record(d)
        p = d['p']
        type = d['s']
        email = p.EmailAddress

        begin
            k = KM.new
            k.init(@km_key, :log_dir => 'log/')
            k.identify(email)

            details = CreateSend::Subscriber.get @auth, @cm_list, email
            ts = DateTime.parse(details.Date).to_time.to_i
            
            case type
                when 'active' then label = 'CM subscribed to email'
                when 'unsubscribed' then label = 'CM unsubscribed from email'
                when 'bounced' then label = 'CM bounced from email'
                when 'deleted' then label = 'CM deleted from email'
            end
            
            k.record(label, {'List' => @list.details.Title, '_d' => 1, '_t' => ts})
            details.CustomFields.each{|field|
                if ['City','Province','Postal Code','Source'].include? field.Key
                    k.set({field.Key => field.Value}) if field.Value != '' && field.Value != nil
                end
            }

            subscriber_events = []
            person = CreateSend::Subscriber.new @auth, @cm_list, email
            history = person.history
            history.each{|h|
                h.Actions.each{|a|
                    ts = DateTime.parse(a.Date).to_time.to_i
                    if @now - ts <= (@allowed_history_days * 86400) || @allowed_history_days == 0
                        if a.Event == 'Open'
                            data = {'Email' => h.Name, '_d' => 1, '_t' => ts}
                            subscriber_events << Thread.new(data){|data| k.record('CM opened an email', data)}
                        elsif a.Event == 'Click'
                            data = {'Email' => h.Name, 'Link' => a.Detail, '_d' => 1, '_t' => ts}
                            subscriber_events << Thread.new(data){|data| k.record('CM clicked something in an email', data)}
                        end
                    end
                }
            }
            subscriber_events.each { |t| t.join }
            subscriber_events.each { |t| t.exit }
            person = nil
            history = nil
            details = nil
            puts "Finished recording events for #{email}"
        rescue StandardError => e
            puts e.message
        end
    end
=end
end
