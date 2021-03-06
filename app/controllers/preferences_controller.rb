require 'net/http'

class PreferencesController < ApplicationController
	
	CONSUMER_KEY = "amEkK6sGLXqfjenxefspjQ"
	SECRET = "rBwPXjfYITNUFxB6A1L4_YWp0ug"
	TOKEN = "dBXdYpzF9pRe6ML4EqnAtrvkEWxcGxq2"
	TOKEN_SECRET = "tOE-UZfaD58RfJwgOrKkevN-2hY"

	GOOGLE_KEY = "AIzaSyAMrSWgcikFHJmslnrC_N25fJ9Wv-988iI"

	def index
	end
	
	def show_results


		Location.destroy_all
		#iterate over keys in map, if preference is in map, append key to list 'activities'
		categories = {"airsoft" => ["shooting", "action", "airsoft"], "amusementparks" => ["action", "amusement parks", "family activities"], "museums1" => ["museums"], "rafting1" => ["rafting/kayaking"], "climbing1" =>["climbing"],"boating1" => ["boating"], "golf1" => ["golf"], "beaches1" => ["beaches"], "winteractivities1" => ["winter activities"], "skiing1" => ["skiing"], "shooting1" => ["shooting"], "airsoft1" => ["airsoft"], "scubadiving1" => ["scubadiving"], "biking1" => ["biking"], "hiking1" => ["hiking"], "professionalsports1" => ["professionalsports"],"parasailing1" => ["parasailing"], "rice1" => ["rice"], "aquariums" => ["fish", "family activities"], "archery1" => ["archery"], "professionalsports1" => "professional sports", "archery" => ["archery"], "beaches" => ["fish", "beaches", "family activities", "water activities"], "bicyclepaths" => ["biking", "exercise"], "boating" => ["boating", "exercise", "water activities"], "scuba1" => ["scubadiving"], "climbing" => ["exercise", "climbing", "action"], "scuba" => ["water activities", "exercise", "fish", "action", "scuba diving", "nature"], "fishing" => ["water activities", "fish", "family activities", "fishing", "nature"], "golf" => ["golf"], "hiking" => ["hiking", "nature"], "nudist" => ["adult activities", "nudist"], "parasailing" => ["parasailing", "action", "water activities"], "rafting" => ["exercise", "water activities", "rafting/kayaking"], "skiing" => ["action", "winter activities", "skiing"], "skydiving" => ["action"], "waterparks" => ["action", "amusement parks", "family activities", "water activities"], "museums" => ["family activities", "museums"], "sportsteams" => ["professional sports", "family activities"], "eroticmassage" => ["adult activities"], "weddingchappels" => ["wedding"], "venues" => ["wedding", "rice"], "cannabisdispensaries" => ["recreational marijuana"], "adultentertainment" => ["adult activities"], "riceshop" => ["rice"]}
		activities = []
		
		specified_city = params['specified_city']
		hubs = ["new+york", "los+angeles","houston", "chicago"]
		if params["preferences"] != nil
			preferences_copy = params["preferences"]["categories"]
			preferences = []
		


			preferences_copy.each do |preference|
				if preference != ""
					preferences << preference
				end	
			end	
			@preferences = preferences	


			categories.keys.each do |category|
				preferences.each do |preference|
				
					if categories[category].include? preference and !(activities.include? preference) 
						activities << category

					end
				end
			end 

			activities.each do |activity|

				limit = (24.0 / activities.length).ceil
				#end
				
				#uri = URI("https://api.yelp.com/v2/search/?oauth_consumer_key=amEkK6sGLXqfjenxefspjQ&oauth_token=JiU_ckw_JBoRtjsD6c12enZrvvgYDuV5&oauth_signature_method=HMAC-SHA1&oauth_signature=GPJ842OeLIbiY-kvMJKQ56KVBlQ&oauth_timestamp=1476549110&oauth_nonce&location=Houston&sort=2&limit=5&category_filter=food")			
				#uri = URI("https://api.yelp.com/v2/search/?oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_consumer_key=amEkK6sGLXqfjenxefspjQ&oauth_token=_iZ4KaMzE1dWZx3N4_l2ULyFu8M-Bh_6&oauth_signature_method=HMAC-SHA1&oauth_signature=Ve-G1qysc3ip9XdAzA8vH9durBI&oauth_timestamp=1476551697&location=Houston&category_filter=food")
				#response = Net::HTTP.get(uri) 

				#hash = JSON.parse response
			
			

				consumer = OAuth::Consumer.new( CONSUMER_KEY,SECRET, {:site => "http://api.yelp.com", :signature_method => "HMAC-SHA1", :scheme => :query_string})

				access_token = OAuth::AccessToken.new( consumer, TOKEN,TOKEN_SECRET)

				#hash = access_token.get("/v2/search?location=new+york").

				if specified_city != ""
					hash = JSON.parse(access_token.get("/v2/search?location=#{specified_city}&limit=#{limit}&category_filter=#{activity}").body)
				else
					location = hubs[Random.rand(4)]
					hash = JSON.parse(access_token.get("/v2/search?location=#{location}&limit=#{limit}&category_filter=#{activity}").body)	
				end

				durations = []
				businesses = hash["businesses"]

					if businesses != nil

						businesses.each do |business|

							name = business["name"]
							url = business["url"]
							rating = business["rating"]
							city = business["location"]["city"]
							description = business["snippet_text"]


							#url = URI.parse("https://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&trafficModel=buestGesskey=AIzaSyAMrSWgcikFHJmslnrC_N25fJ9Wv-988iI")
							uri = URI("https://maps.googleapis.com/maps/api/directions/json?origin=Houston&destination=Montreal&trafficModel=buestGesskey=AIzaSyDnXBSGrss5gqEwmZ3YrOSdpw6mWzbT2K4")
							hash = JSON.parse((Net::HTTP.get(uri)))
							
							

							if !(hash.has_key?("routes")) 
								duration = hash["routes"][0]["legs"][0]["duration"]["text"]
							else 
								duration = "N/A"
							end

							#@hash = hash["routes"][3]["legs"]["duration"]["text"]




							#calculate travel time - AIzaSyAMrSWgcikFHJmslnrC_N25fJ9Wv-988iI
							#/directions/outputFormat?origin=41.43206,-81.38992&destination=39.43206,-81.38992&key=AIzaSyAMrSWgcikFHJmslnrC_N25fJ9Wv-988iI

							#map = OAuth::Consumer.new(GOOGLE_KEY, {:site => "https://maps.googleapis.com", :signature_method => "HMAC-SHA1", :scheme => :query_string})

							#access_token = OAuth::AccessToken.new(map,GOOGLE_KEY)
							#hash = JSON.parse(access_token.get("/maps/api/directions/json?origin=Toronto&destination=Montreal&trafficModel=buestGesskey=AIzaSyAMrSWgcikFHJmslnrC_N25fJ9Wv-988iI").body)
							Location.create(title:name, url: url, yelp_rating:rating, city:city, description:description, duration:duration)
						end

					end	
				end

			

		

			#load locations in database
			#@locations = Location.all.sort_by!(yelp_rating)
			@locations = Location.order(yelp_rating: :desc)
		else
			@locations = []
		end

	end
end
