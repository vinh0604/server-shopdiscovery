module API
  class Users < Grape::API
    resource :users do
      desc "Create new user"
      params do
        requires :email, :type => String, :desc => "Email"
        requires :username, :type => String, :desc => "Username"
        requires :first_name, :type => String, :desc => "First Name"
        requires :last_name, :type => String, :desc => "Last Name"
        requires :password, :type => String, :desc => "Password"
        requires :password_confirmation, :type => String, :desc => "Password Confirmation"
        requires :gender, :type => Integer, :desc => "Gender"
      end
      post '/' do
        attrs = {
          :username => params[:username],
          :email => params[:email],
          :password => params[:password],
          :password_confirmation => params[:password_confirmation]
        }
        user = User.new(attrs)
        if user.save
          contact = Contact.create({
            :gender => params[:gender],
            :first_name => params[:first_name],
            :last_name => params[:last_name]
          })
          user.contact = contact
          user.save
          user
        else
          error!(user.errors.to_json(:methods => :full_messages), 400)
        end
      end
    end

    resource :profile do
      desc "Get user's profile"
      get '/' do
        authenticate!
        current_user.to_json(:include => :contact)
      end

      desc "Update user's profile"
      params do
        optional :contact, :type => String, :desc => "Contact in JSON format"
      end
      put '/' do
        authenticate!
        user = current_user
        contact_params = params[:contact].blank? ? {} : JSON.parse(params[:contact])
        user.transaction do
          if params[:avatar]
            user.avatar = params[:avatar]
            user.save!
          end
          user.contact.update_attributes(contact_params)
        end
        user.to_json(:include => :contact)
      end
    end

    resource :passwords do
      desc "Change password"
      params do
        requires "current_password", :type => String, :desc => "Current Password"
        requires "password", :type => String, :desc => "New Password"
        requires "password_confirmation", :type => String, :desc => "New Password Confirmation"
      end
      put '/' do
        authenticate!
        sub_params = {
          :current_password => params[:current_password],
          :password => params[:password],
          :password_confirmation => params[:password_confirmation]
        }
        if current_user.update_with_password(sub_params)
          {success: true}
        else
          error!(current_user.errors.to_json(:methods => :full_messages), 400)
        end
      end
    end
  end
end
