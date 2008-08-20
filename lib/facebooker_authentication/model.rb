module FacebookerAuthentication
  module Model
    def self.included(includer)
      includer.send(:extend,ClassMethods)
      includer.send(:include,InstanceMethods)
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

      def for(facebook_id,facebook_session=nil)
    		returning find_or_create_by_facebook_id(facebook_id) do |user|
    			unless facebook_session.nil?
    				user.store_session(facebook_session.session_key) 
    			end
    		end
    	end

    end
  end
end