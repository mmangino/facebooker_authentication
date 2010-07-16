module FacebookerAuthentication
  module Model
    def self.included(includer)
      includer.send(:extend,ClassMethods)
      includer.send(:include,InstanceMethods)

      # Provide a way to set the facebook_session in cases where for_facebook_id() doesn't suit.
      # For example, if the model shouldn't be created...
      attr_writer :facebook_session
    end

    module InstanceMethods
      def facebook_session
        return nil if session_key.blank?
        @facebook_session ||=  
          returning Facebooker::Session.create do |session| 
            session.secure_with!(session_key,facebook_id,1.hour.from_now) 
            Facebooker::Session.current=session
        end
      end

      def store_session(session_key)
        if self.session_key != session_key
          update_attribute(:session_key,session_key) 
        end
      end

    end
    module ClassMethods

      def for_facebook_id(facebook_id,facebook_session=nil)
        returning find_or_create_by_facebook_id(facebook_id) do |user|
          unless facebook_session.nil?
            user.store_session(facebook_session.session_key) 
            # Set the session now - this ensures that Cucumber correctly passes the Facebooker::Mock::Session object,
            # rather than letting facebook_session create a standar Facebooker::Session
            user.facebook_session=facebook_session
          end
        end
      end

    end
  end
end
