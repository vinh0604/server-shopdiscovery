module API
  class Messages < Grape::API
    resource :messages do
      desc 'Get all messages of user'
      params do
        optional :page, :type => Integer
        optional :per_page, :type => Integer
      end
      get '/' do
        authenticate!
        query = current_user.message_receivers.includes(:messages).order('sent_date DESC')
        if params[:page] and params[:per_page]
          query = query.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          query = query.page(params[:page])
        else
          query = query.page(1)
        end
        present query, :with => API::RablPresenter, :source => 'api/messages'
      end

      desc 'Get all sent messages of user'
      params do
        optional :page, :type => Integer
        optional :per_page, :type => Integer
      end
      get '/sent' do
        authenticate!
        query = current_user.messages.active.order('created_at DESC')
        if params[:page] and params[:per_page]
          query = query.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          query = query.page(params[:page])
        else
          query = query.page(1)
        end
        present query, :with => API::RablPresenter, :source => 'api/sent_messages'
      end

      desc "Get number of unread message"
      get '/check' do
        authenticate!
        message_count = current_user.message_receivers.where(:status => MessageReceiver::STATUSES[:new]).count
        {:count => message_count}
      end

      desc 'Get detail of a message'
      get '/:id' do
        authenticate!
        message = Message.find(params[:id])
        if current_user.message_receivers.where(:message_id => message.id).exists?
          message_receiver = current_user.message_receivers.where(:message_id => message.id).first
          message_receiver.status = MessageReceiver::STATUSES[:read]
          message_receiver.save
          present message, :with => API::RablPresenter, :source => 'api/message_detail'
        elsif message.user_id == current_user.id
          present message, :with => API::RablPresenter, :source => 'api/message_detail'
        else
          error!({message: '401 Unauthorized'}.to_json, 401)
        end
      end

      desc 'Compose new message'
      params do
        requires :title, :type => String
        requires :content, :type => String
        requires :receivers, :type => String, :desc => 'Message receivers in JSON'
      end
      post '/' do
        authenticate!
        receivers = JSON.parse params[:receivers]
        receivers.uniq!
        message = Message.create({
          :sender_id => current_user.id,
          :title => params[:title],
          :content => params[:content],
          :status => Message::STATUSES[:sent],
          :sent_date => DateTime.now
        })
        receivers.each do |receiver|
          user = User.find_by_username(receiver)
          if user
            message_receiver = MessageReceiver.create({
              :message_id => message.id,
              :user_id => user.id,
              :status => MessageReceiver::STATUSES[:new]
            })
          end
        end
      end

      desc 'Delete a message'
      params do
        optional :sent, :type => Boolean
      end
      delete '/:id' do
        authenticate!
        message = Message.find(params[:id])
        if params[:sent] and message.user_id == current_user.id
          message.status = Message::STATUSES[:deleted]
          message.save
          {:success => true}
        elsif current_user.message_receivers.where(:message_id => message.id).exists?
          message_receiver = current_user.message_receivers.where(:message_id => message.id).first
          message_receiver.destroy
          {:success => true}
        else
          error!({message: '401 Unauthorized'}.to_json, 401)
        end
      end
    end
  end
end