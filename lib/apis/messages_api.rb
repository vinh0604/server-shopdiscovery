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
        query = current_user.message_receivers.order('created_at DESC')
        if params[:page] and params[:per_page]
          query = query.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          query = query.page(params[:page])
        else
          query = query.page(1)
        end
        present query, :with => API::RablPresenter, :source => 'api/messages'
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
        message_receiver = current_user.message_receivers.find_by_id(params[:id])
        if message_receiver
          message_receiver.status = MessageReceiver::STATUSES[:read]
          message_receiver.save
          present message_receiver, :with => API::RablPresenter, :source => 'api/message_detail'
        else
          raise ActiveRecord::RecordNotFound
        end
      end

      desc 'Compose new message'
      params do
        requires :title, type => String
        requires :content, type => String
        requires :receivers, type => Array
      end
      post '/' do
        authenticate!
        message = Message.create({
          :sender_id => current_user.id,
          :title => params[:title],
          :content => params[:content],
          :status => Message::STATUSES[:sent],
          :sent_date => DateTime.now
        })
        params[:receivers].each do |receiver|
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
      delete '/:id' do
        authenticate!
        message_receiver = current_user.message_receivers.find_by_id(params[:id])
        if message_receiver
          message_receiver.destroy
          {:success => true}
        else
          raise ActiveRecord::RecordNotFound
        end
      end
    end
  end
end