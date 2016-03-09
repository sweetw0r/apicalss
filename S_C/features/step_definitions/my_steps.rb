Before do
	require 'active_support/all'
	require 'roo'
	require 'spreadsheet'
	require 'pry'
	require 'digest'
	require 'rest_client'
	require 'securerandom'	
	require 'rubygems'
	
	@myRoot = File.join(File.dirname(__FILE__),'/')
	$env_params = JSON.parse(File.open("#{@myRoot}env_constants.json").read)['env_params']
	$capture_params = JSON.parse(File.open("#{@myRoot}env_constants.json").read)['capture_params']
end


When(/^I pass variables from row "(.*?)"$/) do |arg1|
	$test_params ||= {}
	@row_id = arg1
	api_to_call = $user_data_row["#{arg1}"][$header_columns.index("api name") || $header_columns.index("end point")]
	@url = @url + api_to_call
	replace_url_params
	puts @url
	$test_params.deep_merge! $env_params
	@scenario = $user_data_row["#{arg1}"][$header_columns.index("scenario")] rescue ''
	@test_element = $user_data_row["#{arg1}"][$header_columns.index("variable")|| $header_columns.index("element")] rescue ''
	@req_param = $user_data_row["#{arg1}"][$header_columns.index("request")]
	@resp_param = $user_data_row["#{arg1}"][$header_columns.index("expected response") || $header_columns.index("response")]
	@resp_param ||= '{}'
	@req_header = $user_data_row["#{arg1}"][$header_columns.index("headers") || $header_columns.index("header params")] rescue nil
	@req_header ||= '{}'
	@req_header = replace_params(@req_header) # will need headers before setup steps
	@req_header = JSON.parse(@req_header)
	set_up_step = $user_data_row["#{arg1}"][$header_columns.index("set up steps")] rescue nil
	generate_request(@req_param)
	generate_request(@req_header)
  if !set_up_step.nil? && set_up_step.length > 1
		execute_steps(set_up_step)
  end
	@req_header = replace_params(@req_header.to_s.gsub("=>", ":"))
	@req_param = replace_params(@req_param)
	@resp_param = replace_params(@resp_param)
	@req_header = JSON.parse(@req_header)

end

#returns an array of values [response body, response headers, response code]
def rest_service_call(request_type=nil,url=nil,headers=nil,body=nil, proxy=false)
	request_type = @type if !request_type || request_type.strip.empty?
	if headers["Content-Type"] == "application/x-www-form-urlencoded"
		body  = JSON.parse(body)
	end
	puts "*******************************"
	puts "request #{request_type}"
	puts "URL: " + url
	puts "**********Header*************"
	puts "#{headers}"
	puts "**********Request**************" if request_type != 'GET'
	puts "#{body}"  if request_type != 'GET' || request_type != 'DELETE'
	puts "*******************************"
	RestClient.proxy = "https://proxy.wellsfargo.com:8080" if proxy
	#begin - rescue block for capturing error codes so the script does not stop.
	begin
		case request_type.upcase
			when 'POST'
				act_resp = RestClient.post( url, body,headers )
			when 'GET'
				act_resp = RestClient.get( url, headers)
			when 'PUT'
				act_resp = RestClient.put( url, body,headers )
			when 'DELETE'
				act_resp = RestClient.delete( url, headers )
			else
				raise(::NotImplementedError, "Unknown request type: #{request_type}")
		end
	rescue RestClient::InternalServerError => e
		act_code = 500
		act_resp = e.response.body rescue '{}'
	rescue RestClient::Unauthorized => e
		act_code = 401
		act_resp = e.response.body rescue '{}'
	rescue ::NotImplementedError => e
		raise(e)
	rescue RestClient::ResourceNotFound => e
		act_code = 404
		act_resp = e.response.body rescue '{}'
	rescue RestClient::MethodNotAllowed => e
		act_code = 405
		act_resp = e.response.body rescue '{}'
	rescue RestClient::BadRequest => e
		act_code = 400
		act_resp = e.response.body rescue '{}'
		#rescue => e
		#	@act_resp = e.response.body rescue '{}'
	end
	RestClient.proxy = "" if proxy
	act_resp = '{}' if (act_resp == '' ||  act_resp.nil?)
	act_resp_headers = act_resp.headers rescue nil
	act_code ||= act_resp.code rescue nil
	[act_resp,act_resp_headers,act_code]
end

When(/^I make the ?"?([^"]*)?"? ?REST-service call$/) do |request_type|
	result = rest_service_call(request_type, @url, @req_header, @req_param)
	@act_resp = result[0]
	@act_resp_headers = result[1]
	@act_code = result[2]
end

Then(/^I should see response from row "(.*?)"$/) do |arg1|

	if @resp_param.strip[0] == '[' && @resp_param.strip[-1] == ']'
		resp_par = "{\"resp\":" + @resp_param + "}"
	else
		resp_par = @resp_param
	end
	resp_par = ActiveSupport::JSON.decode(resp_par)

	exp_code = $user_data_row["#{arg1}"][$header_columns.index("code") || $header_columns.index("response code")].to_i rescue nil
	act_code = @act_code

	begin
		if @act_resp.strip[0] == '[' && @act_resp.strip[-1] == ']'
			act_par = "{\"resp\":" + @act_resp + "}"
		else
			act_par = @act_resp
    end
		act_resp_raw =act_par
		act_par = ActiveSupport::JSON.decode(act_par)
	rescue
		#puts "actual resp \n #{@act_resp}"
		@act_resp = "{\"error\":\"#{@act_resp.delete("\n")}\"}"
		begin
			act_par = ActiveSupport::JSON.decode(@act_resp)
		rescue JSON::ParserError => e
			#puts e
			puts "** ERROR: Invalid json in the response"
			puts e
			puts "************"
			@act_resp = "{\"error\":\"invalid json received\"}"
			act_par = ActiveSupport::JSON.decode(@act_resp)
			d = ["Invalid json in the response"]
		end

	end

			capture = $user_data_row["#{arg1}"][$header_columns.index("capture")] rescue nil
			if  !capture.nil? && capture.to_s.downcase =~ /y/
				capture_test_params act_par
				capture_test_params @act_resp_headers
			elsif !capture.nil?
				item_index = capture.to_i - 1
				$test_items ||= []
				$test_items[item_index] ||= {}
				capture_test_params act_par, $test_items[item_index]
      end

		###	binding.pry
			begin
			after_step = $user_data_row["#{arg1}"][$header_columns.index("after steps")]
			if !after_step.nil? && after_step.length > 1
				execute_steps(after_step)
			end
			rescue => e
				puts 'after steps error:'
				puts e.to_s
				puts '-----'
			end
				d ||= different?(resp_par, act_par)
				if  !exp_code.nil? && exp_code != 0 && exp_code != ''
					if act_code != exp_code && d.nil?
						d = ["Response Code: [#{exp_code}, #{act_code}]"]
					end
				end
				# binding.pry
				###if !d.nil? && d["irdapi"].length >= 2
        puts d
        if !d.nil? #&& d["result"].length >= 1
				to_push = ActiveSupport::JSON.decode(act_resp_raw)
				a = JSON.pretty_generate to_push
        @failing_error = "
				Did not receive the expected response.. \n
				Difference is reported in format(Nesting=>[Expected_response, Actual_response]) \n#{d}
				\n\n"
				fail("The response received is \n#{a} \n #{@failing_error}")
        else
					@failing_error = ''
				puts "Test passed. The response received is : \n #{act_resp_raw}\n\n"
				
			end
end

#All well beyond this point.. plz dont touch anything..

Given(/^I read the data from the "(.*?)" and "(.*?)" tab$/) do |arg1, arg2|
  if (!$current_excel && !$current_excel_sheet) || (($current_excel && $current_excel !=arg1) || ($current_excel_sheet && $current_excel_sheet !=arg2))
			$current_excel = arg1
			$current_excel_sheet = arg2
	$data_changes_for = arg2
	book = Roo::Spreadsheet.open("#{@myRoot}#{arg1}")
	user_data = book.sheet("#{arg2}")

	$user_data_row = {}
	for i in 1..user_data.last_row
		$user_data_row[user_data.row(i)[0].to_s] = user_data.row(i)[1..user_data.last_column]
  end
  $header_columns = user_data.row(1)[1..user_data.last_column]
	$header_columns.map!{ |el| el.downcase rescue nil}
  end

end

Given(/^I have a validate service url to make "(.*?)" request$/) do |arg|
	@url = @params['environment']['url']
	@env = @params['environment']['name']
	@type = arg
end