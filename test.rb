@train_num = '17032'
@train_date_reversed = '2013-07-14'

uri = URI.parse("http://coa-search-193678880.ap-southeast-1.elb.amazonaws.com/search.json?q=#{@train_num}")
response = Net::HTTP.get_response(uri)

hash = JSON.load(response.body)[0]
stations = hash["routes"][0]["stations"]
abbrev_stations = stations.scan(/\(.*?\)/).map { |e| e.gsub(/\(/, '').gsub(/\)/, '') }
full_stations = stations.split(',').map { |e| e.split[1..-1].join(' ') }

@stations_hash = Hash[abbrev_stations.zip(full_stations)]

call_curl(abbrev_stations.join("%2C"))