module ApplicationHelper
	def header(text)
		content_for(:header) { text.to_s}
	end

	def spaces(number)
		str = ''
		number.times do
			str += "&nbsp;"		
		end
		str
	end
end
