# Uncomment the next line to define a global platform for your project

   platform :ios, '11.0'

  # target 'Flyadeal Employee Engagement' do

  # all dependencies must be installed for the main app target.



   use_frameworks!
   
   workspace 'Flyadeal Employee Engagement'


   def networkAndParsingPods

     pod 'Alamofire', '~> 5.0.0.beta.1'
     pod 'SwiftyJSON', '~> 4.0'
     pod 'Gloss', '~> 2.0'

   end

   def uiPods

     pod 'Kingfisher'
     pod 'SVProgressHUD'
     

   end

   def keychainPods
  
     pod 'SwiftKeychainWrapper'
     pod 'IQKeyboardManagerSwift'
  
   end

   def chatPods
  
     pod 'Socket.IO-Client-Swift', '~> 15.1.0'
  
   end


 

    target 'Flyadeal Employee Engagement' do

       project 'Flyadeal Employee Engagement.xcodeproj'
    
         uiPods
         networkAndParsingPods
         keychainPods
         chatPods
                 
         pod 'Firebase/Core'
         pod 'Firebase/Messaging'
         pod 'DTPagerController'
    end

  

    target 'Feed' do

       project 'Feed/Feed.xcodeproj'

         uiPods
         keychainPods
       
     end

    target 'Common' do

       project 'Common/Common.xcodeproj'

         networkAndParsingPods
         keychainPods
         uiPods
       
     end

    target 'Auth' do
  
       project 'Auth/Auth.xcodeproj'
       
        keychainPods
       
       
  
     end

    target 'Inbox' do
  
       project 'Inbox/Inbox.xcodeproj'
       
        chatPods
        keychainPods
        uiPods
  
     end

    target 'Events' do
  
     project 'Events/Events.xcodeproj'
     
      pod 'DTPagerController'
  
    end

    target 'StaffDirectory' do
  
      project 'StaffDirectory/StaffDirectory.xcodeproj'
     
      uiPods
  
    end
    

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end
