class Common::JsonGenerator

	def self.generate_user_names_json(current_user)
		# Common::JsonGenerator.check_folder("autocomplete")

		all_users = User.all
		user_names = []
		all_users.each do |user|
			if (current_user == user) && (user.has_role? :admin)
				# avoid it in the search
			else
				user_names << user.name
			end
		end
		path = Rails.root.join("public","data","autocomplete","user_names_#{current_user.id}.json")
		begin
			File.open(path, "w") {|f| f.write(user_names.to_json)}
		rescue
			puts "Error: #{$!}"
		end
	end

	# def self.check_folder(folder_name)
	#     path = Rails.root.join("public", "data", "#{folder_name}");
	#     Dir.mkdir(path) unless File.exist?(path)
 #  	end

end