require "cm-writeonce/version"

module CmWriteonce
    
    require 'createsend'

    def self.initialize(cm_key, cm_list, filename)
        @cm_key = cm_key
        @cm_list = cm_list
        @now = DateTime.now.to_time.to_i
        @auth = {:api_key => @cm_key}
        cs = CreateSend::CreateSend.new @auth

        i = 0
        File.open(filename).read.split("\n").each do |line|
          begin
              name, email_address, street_address, city, province, country, postal_code, telephone, initial_source, campaign, gender, language_preference = line.split(",")

              if i == 0
                  raise "Could not find correct headers in CSV file!" unless name == "Name" &&
                                                                  email_address == "Email Address" &&
                                                                  street_address == "Street Address" &&
                                                                  city == "City" &&
                                                                  province == "Province" &&
                                                                  country == "Country" &&
                                                                  postal_code == "Postal Code" &&
                                                                  telephone == "Telephone" &&
                                                                  initial_source == "Initial Source" &&
                                                                  campaign == "Campaign" &&
                                                                  gender == "Gender" &&
                                                                  language_preference == "Language Preference"
              else
                  email_address.downcase!
                  postal_code.upcase!
                  postal_code = postal_code.gsub(/\s+/, "")
                  province = province.upcase!
                  country = country.split(' ').map(&:capitalize).join(' ')
                  telephone = telephone.gsub(/([-() ])/, '')
                  gender.capitalize!
                  language_preference.upcase!
                  custom_fields = [ { :Key => 'Street Address', :Value => street_address, :Clear => false },
                                    { :Key => 'City', :Value => city, :Clear => false },
                                    { :Key => 'Province', :Value => province, :Clear => false },
                                    { :Key => 'Country', :Value => country, :Clear => false },
                                    { :Key => 'Postal Code', :Value => postal_code, :Clear => false },
                                    { :Key => 'Telephone', :Value => telephone, :Clear => false },
                                    { :Key => 'Campaign', :Value => campaign, :Clear => false },
                                    { :Key => 'Gender', :Value => gender, :Clear => false },
                                    { :Key => 'Language Preference', :Value => language_preference, :Clear => false } ]
                  begin
                      details = CreateSend::Subscriber.new @auth, @cm_list, email_address
                      details.update email_address, name, custom_fields, true
                      puts "Updated " << name << " <" << email_address << ">"
                  rescue Exception => e
                      if e.message == 'The CreateSend API responded with the following error - 203: Subscriber not in list or has already been removed.'
                          custom_fields << { :Key => 'Initial Source', :Value => initial_source }
                          email_address = CreateSend::Subscriber.add @auth, @cm_list, email_address, name, custom_fields, true
                          puts "Added " << name << " <" << email_address << ">"
                      end
                  end
              end

              i = i + 1
          rescue Exception => e 
              puts e.message
              puts "Expecting: Name,Email Address,Address,City,Province,Country,Postal Code,Telephone,Initial Source,Campaign,Gender,Language Preference"
              abort
          end 
        end
    end
end
