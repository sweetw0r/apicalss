After do |scenario|
	# if scenario.failed?
		#req_header = ActiveSupport::JSON.decode(@req_header.to_s)
		req_header = JSON.pretty_generate @req_header
		act_resp = ActiveSupport::JSON.decode(@act_resp)
		act_resp = JSON.pretty_generate act_resp
		payload = ActiveSupport::JSON.decode(@req_param)
		payload = JSON.pretty_generate payload
		expected_resp = ActiveSupport::JSON.decode(@resp_param)
		expected_resp = JSON.pretty_generate expected_resp
    result = scenario.failed? ? "Fail" : "Pass"
		resp_too_long = act_resp.length > 32001 rescue false
		act_resp = resp_too_long ? act_resp[0..32000] : act_resp
		note = resp_too_long ? 'complete response is too long, only first part is available' : ''
		$act_resp_data_val.push [@row_id, @test_element, @scenario, result, Time.now.to_s, @url, @type, req_header, payload, expected_resp, act_resp, @failing_error, note]
  # end
end

Before do
  	if $act_resp_data_val.nil?
			$act_resp_data_val =[ [ "ID", "Element", "Scenario", "Result", "Date/Time", "URL", "Method","Headers", "Payload", "Expected Response", "Actual Response", "Issue", "Note"]]
		end
end

at_exit do
	book = Spreadsheet::Workbook.new
	sheet1 = book.create_worksheet
	for i in 0..$act_resp_data_val.length - 1
		sheet1.row(i).push i, *$act_resp_data_val[i]
	end
	@myRoot = File.join(File.dirname(__FILE__),'/')
	puts "#{@myRoot}../awetest_report/#{$data_changes_for}_#{Time.now.strftime "%d_%m_%H_%M_%S"}_.xls"
	book.write "#{@myRoot}../awetest_report/#{$data_changes_for}_#{Time.now.strftime "%d_%m_%H_%M_%S"}_.xls"
end