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
          error!(user.errors, 400)
        end
      end
    end

    resource :profile do
      desc "Update user's profile"
      put '/' do
        authenticate!
        user = current_user
        if params[:avatar]
          user.avatar = params[:avatar]
          user.save!
        end
        user.contact.update_attributes(params[:contact])
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
        if current_user.update_with_password(params)
          {success: true}
        else
          error!(current_user.errors, 400)
        end
      end
    end
  end
end
