module FacebookerAuthentication
  module Controller
    def self.included(includer)
      #install the current_user helper and the before filter
      includer.module_eval do
        helper_attr :current_user
        attr_accessor :current_user
      end
    end
    
  
    def set_current_user
      #this is a facebooker method to make sure we have a session
      set_facebook_session
      # if the session isn't secured, we don't have a good user id
      if facebook_session and 
         facebook_session.secured? and 
         !request_is_facebook_tab?
         self.current_user = <%=class_name%>.for_facebook_id(facebook_session.user.to_i,facebook_session) 
      end
    end
    
    def facebook_login_required
      @after_login_url = request.request_uri
      debugger
      if ensure_authenticated_to_facebook
        set_current_user
      end
    end
    
    def after_login_url
      @after_login_url.blank? ? nil : url_for(:controller=>request.request_uri,:only_path=>true)
    end
    
    
  end
end