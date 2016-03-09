def different?(a, b, bi_directional=true)
	return [a.class.name, nil] if !a.nil? && b.nil?
	return [nil, b.class.name] if !b.nil? && a.nil?

	differences = {}
	a.each do |k, v|
		if !v.nil? && b[k].nil?
			differences[k] = [v, nil]
			next
		elsif !b[k].nil? && v.nil?
			differences[k] = [nil, b[k]]
			next
		end

		if v.is_a?(Hash)
			unless b[k].is_a?(Hash)
				differences[k] = "Different types"
				next
			end
			diff = different?(a[k], b[k])
			differences[k] = diff if !diff.nil? && diff.count > 0

		elsif v.is_a?(Array)
			unless b[k].is_a?(Array)
				differences[k] = "Different types"
				next
			end

			c = -1
			diff = v.map do |n|
				c += 1
				if n.is_a?(Hash)
					diffs = different?(n, b[k][c])
					["Differences: ", diffs] unless diffs.nil?
				else
					[n , b[k][c]] unless b[k][c] == n
				end
			end.compact
			differences[k] = diff if diff.count > 0
		else
			differences[k] = [v, b[k]] unless v == b[k]
		end
	end
	return differences if !differences.nil? && differences.count > 0
end

def clear
	$test_params = {}
end

def execute_steps(steps)
	steps = steps.split(', ')
	steps.each{|step|
		puts "#{step}"
		eval("#{step}")
	}
end

def replace_url_params
	true
end

#string string to replace params in
def replace_params(string, hash={"a" => "b"}, prefix='')         #(keys)
#will replace all the params in visa hash with they special capital values in the request and header and response
# all keys in the request and response that will be replaced must be in quotes and all caps ex: "TOKENREQUESTORID"
	$test_params ||= {}
	#check if no initial hash is passed, so that we will use visa_params hash as a hash with values that we will replace
	if hash['a'] == 'b'
		hash = $test_params
		puts ' '
		print 'replacing: '
	end
	#check if we want to use cars_hash to replace params that we are storing for a specific card
	if prefix !~ /item_/ && hash == $test_params && (string.include?("\"item_"))
		#prefix = 'item_'
		#replace params for each card in the visa_cards hash
		#ALL CARD specific keys to be replaced  must have item_#  before the actual value
		$test_items.each_with_index {|item_hash, index|
			string = replace_params string, item_hash, "#{'item_'}#{index+1}_"
		}
		#prefix = ''
	end

	#Actuall replacing loop, goes through the hash and replaces
	hash.each { |key, value|
		if value.nil?
			string.gsub!("\"#{prefix + key.upcase}\"", 'null')
		elsif value.is_a? String
			string.gsub!("\"#{prefix + key.upcase}\"", "\"#{value}\"")
			print "#{key}, "
		elsif value.is_a? Hash #call itself if a hash
			string = replace_params(string, value, prefix)
		elsif value.is_a? Array and value[0].is_a? Hash
			value.each {|sub_hash|
				string = replace_params(string, sub_hash, prefix)
			}
		elsif value.is_a? Integer or value.is_a? Array or value.is_a? Float
			string.gsub!("\"#{prefix + key.upcase}\"", "#{value}")
			print "#{key}, "
		else
			warn("Ooops, don't know how to handle value to be replaced, #{value}")
		end
	}
	string
end


def capture_test_params(act_par, capture_to_hash = $test_params)

	puts ' '
	print 'captured: '
	#$test_params.merge!(act_par)
	puts ' '
	act_par ||= {}
	act_par.each_key { |key|
		case key.to_s
			when *$capture_params
				#$test_params[key.to_s] = act_par[key]
				capture_to_hash.deep_merge!({key.to_s => act_par[key]})
				print "#{key}, "
		end}
end

