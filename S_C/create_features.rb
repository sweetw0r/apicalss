require 'rubygems'
require 'active_support/all'
require 'roo'
require 'spreadsheet'
 require 'pry'
  
puts "We will Create feature files based on the excel sheet"
`mkdir new_files`

#Usage Please pass the excel file name as an argument or specify it in 
#else part of the following condition.
if ARGV.length == 1
	file_name = ARGV[0]
else
	file_name = "scenarios.xlsx"
end

@myRoot = File.join(File.dirname(__FILE__),'/')
book = Roo::Spreadsheet.open("#{@myRoot}/features/step_definitions/#{file_name}")
		# binding.pry

	book.sheets.each do |e| 
		puts e
		user_data = book.sheet(e)
		file = File.new("./new_files/#{e}.feature", "w")
		@header_columns = user_data.row(1)[0..user_data.last_column]
		@header_columns.map!{ |el| el.downcase rescue nil}
		# write_feature_scenario(file, e)
		file.write("Feature: This feature file tests all the
    scenarios from #{e} tab on #{file_name}"+"\n\n")
		file.write("  Background:
    Given I have a validate service url to make \"POST\" request
    And I read the data from the \"#{file_name}\" and \"#{e}\" tab"+"\n\n")
		
		# @user_data_row = {}
		for i in 2..user_data.last_row
			# @user_data_row[user_data.row(i)[0]] = user_data.row(i)[1..user_data.last_column]
			# binding.pry	
			unless user_data.row(i)[0].nil?
				requset_type = nil
				request_type_column_present =  (user_data.row(i)[@header_columns.index("request type") || @header_columns.index("method/verb")] && user_data.row(i)[@header_columns.index("request type") || @header_columns.index("method/verb")].length > 0) rescue false
				if request_type_column_present
					requset_type = "\"#{user_data.row(i)[@header_columns.index("request type") || @header_columns.index("method/verb")]}\""
				end
				scenario = user_data.row(i)[@header_columns.index("scenario")]
				element_name = user_data.row(i)[@header_columns.index("variable")|| @header_columns.index("element")]
				file.write("\n  Scenario: #{scenario},   Element = #{element_name}   ScenarioID = #{user_data.row(i)[0]}, Service/API = #{user_data.row(i)[@header_columns.index("api name") || @header_columns.index("end point")]},
    When I pass variables from row \"#{user_data.row(i)[0]}\"
    And I make the #{requset_type} REST-service call
    Then I should see response from row \"#{user_data.row(i)[0]}\"\n")
		end
		end
		file.close
		# binding.pry
	end

