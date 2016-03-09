#Use this file to define functions that can be called using setup steps and after steps columns in the excel as well as generate_request function. Also yo can modify generate request function as needed.
#You should only use other service calls in the functions you define.
#
#You can call service with rest_service_call function taht returns an array of values [response body, response headers, response code] stab is:
#def rest_service_call(request_type=nil,url=nil,headers=nil,body=nil, proxy=false)
#Example usage:
#def published_campaign
#   url = @params['environment']['url'] + "wds-campaign/publishedCampaign"
#   req_param ={
#       "campaignId"=> "CAMPAIGNID"
#   }
#   req_param = req_param.to_s.gsub("=>", ":")
#   req_param = replace_params(req_param)
#   act_par = rest_service_call('post',url,@req_header,req_param)[0]
#   act_par = ActiveSupport::JSON.decode(act_par)
#   $test_params['result'] = act_par['result']  # to capture result if needed
#end

#Generate params for the request. Params should be saved to global $test_params hash and will get automatically replaced in the request/headers/expected response
def generate_request(req_param)
  if req_param.include? "UNIQUE_VALUE"
    result = rand_string_alpha(10)
    $test_params["UNIQUE_VALUE"] = "QA" + result
  end
  if req_param.include? "UNIQUE_NAME"
    result = rand_string_alpha(10)
    $test_params["UNIQUE_NAME"] = "QA" + result
  end

  if req_param.include? "FROM_PRESENT_DT"
    suffix_string = "03:01 AM"
    prefix_string = Time.now.strftime("%m/%d/%y ")
    date_string = prefix_string + suffix_string
    $test_params['FROM_PRESENT_DT'] = date_string
  end

  if req_param.include? "TOMORROW_DT"
    suffix_string = "10:00 PM"
    prefix_string = Date.tomorrow.strftime("%m/%d/%y ")
    date_string = prefix_string + suffix_string
    $test_params['TOMORROW_DT'] = date_string
  end

  if req_param.include? "TODAY_DT"
    date_string = Time.now.strftime("%m/%d/%y")
    $test_params['TODAY_DT'] = date_string
  end

  if req_param.include? "NEXT_MONTH"
    suffix_string = "10:00 PM"
    prefix_string = 1.month.from_now.strftime("%m/%d/%y ")
    date_string = prefix_string + suffix_string
    $test_params['NEXT_MONTH'] = date_string
  end
  if req_param.include? "YESTERDAY"
    suffix_string = "10:00 PM"
    prefix_string = 1.day.ago.strftime("%m/%d/%y ")
    date_string = prefix_string + suffix_string
    $test_params['YESTERDAY'] = date_string
  end
  if req_param.include? "LAST_MONTH"
    suffix_string = "10:00 PM"
    prefix_string = 1.month.ago.strftime("%m/%d/%y ")
    date_string = prefix_string + suffix_string
    $test_params['LAST_MONTH'] = date_string
  end

end

def delete_campaign(param=nil)
  puts 'deleting campaign'
  req_param = %Q{
            {"campaignId": "CAMPAIGNID"}
        }
  req_param = replace_params(req_param)
  url = @params['environment']['url'] + "wds-campaign/deleteCampaign"
  puts '-----'
  puts url
  puts req_param
  act_resp = RestClient.post url, req_param , @req_header
  puts 'result:'
  puts "param is #{param}"
  puts act_resp
  puts '------'
end

#Function generates a random string
#param length of the string
#return random Alpha string
def rand_string_alpha(length)
  chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ'
  Array.new(length) { chars[rand(chars.length)].chr }.join
end




def message_draft
  url = @params['environment']['url'] + "wds-management-console/getMessages"

  req_param ={
      "companyId" => "COMPANY_ID"
  }

  req_param = req_param.to_s
  req_param = req_param.gsub("=>", ":")
  req_param = replace_params(req_param)
  act_resp = rest_service_call('post',url,@req_header,req_param)
  act_par = ActiveSupport::JSON.decode(act_resp[0])
  x = act_par["result"].length
  #index= Array.new(x)
  index= Hash.new(x)
  i= 0
  for i in 0 .. x
    if act_par["result"][i]["messageStatusDesc"] == "Draft"
      index[0] = i
      puts "in the loop index:" + index[0].to_s
      break
    end
  end

  puts "Out of loop index: " + index[0].to_s
  y= index[0]
  $test_params['messageId'] =  act_par["result"][y]["messageId"]
  puts "Out of the loop MessageId is:" + $messageid.to_s + "...."
end

def create_campaign(status="published")
  if status =="active"
    start_date = "FROM_PRESENT_DT"
  else
    start_date ="TOMORROW_DT"
  end
  url = @params['environment']['url'] + "wds-campaign/createCampaign"

  req_param =
      {
          "irdapi" => {
              "irdapiContext" => {


                  "messageDateTime" =>"2015-12-01T18:30:47+0000",
                  "appId" =>"CEOCOID1",
                  "messageId" =>"7ec34962db32ff5f08ef",
                  "messageType" => "ces",
                  "appId" => "CEOCOID1",
                  "companyId" => "COMPANY_ID",
                  "facilityId" => "FACILITY_ID"
              },
              "irdapiBody" => {
                  "contextEngineRq" => {
                      "campaign" => {
                          "name" => "UNIQUE_NAME",
                          "stDate" => start_date,
                          "endDate" => "NEXT_MONTH",
                          "targetGroups" => [
                              "test for Req"
                          ],
                          "type" => "EVENT",
                          "triggerGroups" => [
                              {
                                  "name" => "test for Req Group",
                                  "triggers" => [
                                      {
                                          "locationEvent" => [
                                              {
                                                  "key" => "context.location.facility.facilityName",
                                                  "value" => "surfershop",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "testAtt",
                                                  "value" => "gender",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.gender",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.gender",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.gender",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.gender",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.gender",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.gender",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.gender",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.occupation",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.occupation",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.occupation",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.education",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.education",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.education",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.education",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "context.consumer.ageRange",
                                                  "value" => "null",
                                                  "op" => "=="
                                              },
                                              {
                                                  "key" => "DOB",
                                                  "value" => "1011",
                                                  "op" => "=="
                                              }
                                          ],
                                          "eventName" => "Location Event"
                                      }
                                  ],
                                  "action" => {
                                      "type" => "E",
                                      "priority" => "1",
                                      "contentId" => "6",
                                      "actionName" => "Greetings 234"
                                  }
                              }
                          ]
                      }
                  }
              }
          }
      }
  req_param = req_param.to_s
  req_param.gsub!("=>", ":")
  generate_request(req_param)
  req_param = replace_params req_param
  act_resp = rest_service_call('post', url,  @req_header, req_param)[0]
  puts 'result:'
  puts act_resp
  puts '------'
  act_par = ActiveSupport::JSON.decode(act_resp)
  if act_par["result"] && act_par["result"]["campaignId"]
    $test_params['campaignId'] =   act_par["result"]["campaignId"].to_s
  else
    raise act_resp
  end


end

def get_campaign_by_campaign_id


url = @params['environment']['url'] + "wds-campaign/getCampaignByCampaignId"

req_param = {
  "campaignId" => "CAMPAIGNID"
}
  
  req_param = req_param.to_s
  req_param.gsub!("=>", ":")
  req_param = replace_params(req_param)
	act_resp = rest_service_call('post',url, @req_header, req_param )[0]
  puts 'result:'
  puts act_resp
  puts '------'
	act_par = ActiveSupport::JSON.decode(act_resp)
	$test_params['scheduleId'] = act_par["result"]["campaignSchedule"]["schedule"]["scheduleId"].to_s

end

# def active_campaign
# original_url = @url
# @url = @params['environment']['url'] + "createCampaign"
#
# @req_param ={
#     "irdapi"=> {
#         "irdapiContext"=> {
#             "messageId"=> "uuaamtq20givv9ikqoz3d8vz",
#             "messageDateTime"=> "Tue Jul 30 2015 13=>37=>01 GMT-0700 (Pacific Daylight Time)",
#             "messageType"=> "ces",
#             "appId"=> "CEOCOID1",
#             "companyId"=> "10063",
#             "facilityId"=> "10090"
#         },
#         "irdapiBody"=> {
#             "contextEngineRq"=> {
#                 "campaign"=> {
#                     "name"=> "UNIQUE_NAME",
#                     "stDate"=> "TODAY_DT",
#                     "endDate"=> "08/30/15",
#                     "targetGroups"=> [
#                         "Coffee Lovers"
#                     ],
#                     "triggerGroups"=> [
#                         {
#                             "name"=> "Event Group 1",
#                             "triggers"=> [
#                                 {
#                                     "locationEvent"=> [
#                                         {
#                                             "key"=> "context.location.facility.facilityName",
#                                             "value"=> "Satrbucks",
#                                             "op"=> "CONTAINS"
#                                         },
#                                         {
#                                             "key"=> "context.consumer.targetGroups",
#                                             "value"=> "Coffee Lovers",
#                                             "op"=> "contains"
#                                         }
#                                     ]
#                                 }
#                             ],
#                             "action"=> {
#                                 "type"=> "null",
#                                 "priority"=> "2",
#                                 "contentId"=> "10089"
#                             }
#                         }
#                     ]
#                 }
#             }
#         }
#     }
# }
#
# @req_param = @req_param.to_s
# 	@req_param = @req_param.gsub("=>", ":")
# 	generate_request
# 	step 'I make the REST-service call'
# 	act_par = ActiveSupport::JSON.decode(@act_resp)
# 	###binding.pry
# @url = original_url
# end

# def get_campaign
# original_url = @url
# @url = @params['environment']['url'] + "getCampaigns"
#
# @req_param ={
#    "companyId"=>"COMPANY_ID",
#   "startDate"=>"",
#   "endDate"=>"",
#   "createdOn"=>"",
#   "createdBy"=>"",
#   "campaignName"=> $random_string
#  }
#
# @req_param = @req_param.to_s
# 	@req_param = @req_param.gsub("=>", ":")
# 	generate_request
# 	step 'I make the REST-service call'
# 	act_par = ActiveSupport::JSON.decode(@act_resp)
# 	#binding.pry
# 	$publishid =  act_par["result"]["campaignId"]
# 	#binding.pry
# @url = original_url
# end

def published_campaign
  url = @params['environment']['url'] + "wds-campaign/publishedCampaign"

  req_param ={
      "campaignId"=> "CAMPAIGNID"
  }

  req_param = req_param.to_s
  req_param = req_param.gsub("=>", ":")
  req_param = replace_params(req_param)
  act_par = rest_service_call('post',url,@req_header,req_param)[0]
  act_par = ActiveSupport::JSON.decode(act_par)
  puts act_par
  #binding.pry
  #$publishid =  act_par["result"]["campaignId"]
  #binding.pry
end



def deActivate_Campaign

  url = @params['environment']['url'] + "wds-campaign/deActivateCampaign"

  req_param ={
      "campaignId"=> "CAMPAIGNID"
  }

  req_param = req_param.to_s
  req_param = req_param.gsub("=>", ":")
  req_param = replace_params(req_param)
  act_par = rest_service_call('post',url,@req_header,req_param)[0]
  act_par = ActiveSupport::JSON.decode(act_par)
  puts act_par
end

def save_message
  url = @params['environment']['url'] + "wds-management-console/saveMessage"
  req_param ={
      "companyId"=> "COMPANY_ID",
      "messageId"=> "",
      "messageName"=>"UNIQUE_NAME",
      "messageStatusCode"=> "",
      "messageTxt"=>"Message for Wells",
      "channelTypeCode"=>1,
      "messageTypeCode"=> "1",
      "messageCategoryCode"=>1
  }
  req_param = req_param.to_s
  req_param = req_param.gsub("=>", ":")
  generate_request(req_param)
  req_param = replace_params(req_param)
  act_resp = rest_service_call('post',url,@req_header,req_param)
  act_par = ActiveSupport::JSON.decode(act_resp[0])
  puts act_par
  $test_params['messageId'] =  act_par["result"]["messageId"]
end

def delete_message
  req_param = %Q{
            {"messageId": "MESSAGEID"}
        }
  req_param = replace_params(req_param)
  url = @params['environment']['url'] + "wds-management-console/deleteMessage"
  act_resp = rest_service_call('post',url,@req_header,req_param)
  puts act_resp
end