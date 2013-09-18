require "sinatra"
require "net/http"
require "json"
require "curb"

get '/' do
	erb :home
end

get	'/about' do
	erb :about
end

get '/contact' do
	erb :contact
end

get '/info' do
  @pnr = params[:pnr]

  train_response = Net::HTTP.get_response(URI.parse("http://www.railpnrapi.com/#{@pnr}")).body

  if train_response =~ /Invalid PNR/
    erb :invalid_pnr
  else
    train_json = JSON.load(train_response)

    @train_num = train_json["tnum"]
    @train_date = train_json["tdate"]
    @train_date_reversed = @train_date.split('-').reverse.join('-')

    @final_destn = train_json["to"]

    uri = URI.parse("http://coa-search-193678880.ap-southeast-1.elb.amazonaws.com/search.json?q=#{@train_num}")
    response = Net::HTTP.get_response(uri)

    p response.body

    hash = JSON.load(response.body)[0]

    if response.body[0] =~ /invalid/
      STDERR.puts "HTTP Response Error"
      exit
    end
    stations = hash["routes"][0]["stations"]
    abbrev_stations = stations.scan(/\(.*?\)/).map { |e| e.gsub(/\(/, '').gsub(/\)/, '') }
    full_stations = stations.split(',').map { |e| e.split[1..-1].join(' ') }

    @stations_hash = Hash[abbrev_stations.zip(full_stations)]

    set_next_and_prev(abbrev_stations.join("%2C"))
    set_final_long

    @train_name = train_json["tname"]
    @train_start = @stations_hash[train_json["from"]]
    @train_end = @stations_hash[@final_destn]

    @weather_forecast, @distance_to_destn = weather_distance_api if weather_distance_api
    @weather_forecast = @weather_forecast || "[Could not be found]"
    @distance_to_destn = @distance_to_destn || "[Could not be found]"

    erb :info
  end
end

helpers do
  def set_next_and_prev(stns)

    # grep_result = `curl --head 'http://trainenquiry.com/RailYatri.ashx' | grep Set-Cookie`
    # cookie = grep_result.split[1]

    `curl --dump-header headers_and_cookies http://trainenquiry.com/ 1>/dev/null 2>/dev/null`
    cookie_line = `grep Set-Cookie headers_and_cookies`
    cookie = cookie_line.split[1]

    text_dump = `curl 'http://trainenquiry.com/RailYatri.ashx' -H 'Cookie: #{cookie} __gads=ID=da9366776debb721:T=1373759777:S=ALNI_MbTBC-RdvvVfSAJhZ5PqTylQHUoSA; OX_plg=swf|qt|wmp|shk|pm; __utma=177604064.1792347361.1373759770.1373759770.1373759770.1; __utmb=177604064.5.10.1373759770; __utmc=177604064; __utmz=177604064.1373759770.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)' -H 'Origin: http://trainenquiry.com' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: trainenquiry.com' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.71 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: */*' -H 'Referer: http://trainenquiry.com/TrainStatus.aspx' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data 't=#{@train_num}&s=#{@train_date_reversed}&codes=#{stns}&RequestType=Location' --compressed`

    begin
      json = JSON.load text_dump

      @next_stn = json[json["keys"][0]]["station_updates"].reject { |k,v| v["status"] == "departed" }.keys.first
      @prev_stn = json[json["keys"][0]]["station_updates"].reject { |k,v| v["status"] == "not_reached" }.keys.last
      @prev_stn = (@prev_stn.nil? or @prev_stn == "nil" or @prev_stn == "") ? "Your train hasn't started yet" : @prev_stn

      @delay_mins = json[json["keys"][0]]["station_updates"]["#{@prev_stn}"]["delay_mins"]
    rescue
      erb :error
    end
  end

  def weather_distance_api
    unless @next_stn.nil? or @final_destn.nil?
      next_stn_long = @stations_hash[@next_stn].split.first
      final_destn_long = @stations_hash[@final_destn].split.first

      distance_hash = JSON.load(`curl 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.distance%20where%20place1%3D%22#{next_stn_long}%22%20and%20place2%3D%22#{final_destn_long}%22&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'`)

      begin
        next_woeid = distance_hash["query"]["results"]["distance"]["place"][0]["locality1"]["woeid"]
        dest_woeid = distance_hash["query"]["results"]["distance"]["place"][1]["locality1"]["woeid"]
      rescue
        return false
      end

      distance = distance_hash["query"]["results"]["distance"]["kilometers"]

      weather_text = `curl 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%3D#{next_woeid}&format=json&diagnostics=true'`
      weather_hash = JSON.load(weather_text)

      begin
        forecast = weather_hash["query"]["results"]["channel"]["item"]["forecast"][0]["text"]
      rescue
        erb :error
      end

      return [forecast, distance]
    end
  end

  def set_final_long
    @final_destn_long = @stations_hash[@final_destn]
  end

  def distance_to_next
    return 0 if @prev_stn.nil? or @prev_stn == ""
    ``
  end
end