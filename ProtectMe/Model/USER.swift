//
//  jamalekUser.swift
//  Jamalek
//
//  Created by Mac on 06/02/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class USER: NSObject  ,NSCoding {
        var email                               = ""
        var id                                  = ""
        var location_service                    = ""
        var name                                = ""
        var new_linked_account_notification     = ""
        var email_notification                  = ""
        var notification                        = ""
        var online                              = ""
        var profile_image                       = ""
        var profile_image_zoom                  = ""
        var sender_account_activity_notification = ""
        var status                              = ""
        var type                                = ""
        var vAuthToken                          = ""
        var country                             = ""
        var state                               = ""
        var city                                = ""
        var latitude                            = ""
        var longitude                           = ""
        var voice_action                        = ""
        var linked_account_counters             = ""
        var support_email                       = ""
        var LinkedAccSenederSelected            = false
        var isLogout                           = false
        var isDeleteActionShow:Bool             = true
    
        var archived_counter                       = ""

    
    
    
    
    // twitter
    var Tusername = ""
    var Tname = ""
    var Temail = ""
    var Tprofile_image = ""
    var Ttwitter_id = ""
    var Tsocial_type = ""
    var Tcountry_code = ""
    var TcheckExist = ""
  
    // facebook
    var Fusername = ""
    var Fname = ""
    var Femail = ""
    var Fprofile_image = ""
    var Ffacebook_id = ""
    var Fsocial_type = ""
    var Fcountry_code = ""
    var FcheckExist = ""

    var preference = [NSDictionary]()
    static var shared: USER = USER()
    override init()
    {
        super.init()
        let encodedObject:NSData? = UserDefaults.standard.object(forKey: "ELUser") as? NSData
        if encodedObject != nil
        {
            let userDefaultsReference = UserDefaults.standard
            let encodedeObject:NSData = userDefaultsReference.object(forKey: "ELUser") as! NSData
            let kUSerObject:USER = NSKeyedUnarchiver.unarchiveObject(with: encodedeObject as Data) as! USER
            self.loadContent(fromUser: kUSerObject);
        }
    }
    
   
    required init?(coder aDecoder: NSCoder)    {
        super.init()
         if let value = aDecoder.decodeObject(forKey: "isLogout") as? Bool{
            self.isLogout = value
        }
        if let value = aDecoder.decodeObject(forKey: "isDeleteActionShow") as? Bool{
            self.isDeleteActionShow = value
        }
        if let value = aDecoder.decodeObject(forKey: "LinkedAccSenederSelected") as? Bool{
            self.LinkedAccSenederSelected = value
        }

        if let value = aDecoder.decodeObject(forKey: "longitude") as? String{
            self.longitude = value
        }
        if let value = aDecoder.decodeObject(forKey: "email_notification") as? String{
            self.email_notification = value
        }
        if let value = aDecoder.decodeObject(forKey: "latitude") as? String{
            self.latitude = value
        }
        if let value = aDecoder.decodeObject(forKey: "city") as? String{
            self.city = value
        }
        if let value = aDecoder.decodeObject(forKey: "state") as? String{
            self.state = value
        }
        if let value = aDecoder.decodeObject(forKey: "country") as? String{
            self.country = value
        }
        
        if let value = aDecoder.decodeObject(forKey: "email") as? String{
            self.email = value
        }
        if let value = aDecoder.decodeObject(forKey: "id") as? String{
            self.id = value
        }
        if let value = aDecoder.decodeObject(forKey: "location_service") as? String{
            self.location_service = value
        }
        if let value = aDecoder.decodeObject(forKey: "name") as? String{
            self.name = value
        }
        if let value = aDecoder.decodeObject(forKey: "new_linked_account_notification") as? String{
            self.new_linked_account_notification = value
        }
        if let value = aDecoder.decodeObject(forKey: "notification") as? String{
            self.notification = value
        }
        if let value = aDecoder.decodeObject(forKey: "online") as? String{
            self.online = value
        }
        if let value = aDecoder.decodeObject(forKey: "profile_image") as? String{
            self.profile_image = value
        }
        if let value = aDecoder.decodeObject(forKey: "profile_image_zoom") as? String{
         self.profile_image_zoom = value
        }
        if let value = aDecoder.decodeObject(forKey: "sender_account_activity_notification") as? String{
            self.sender_account_activity_notification = value
        }
        
        if let value = aDecoder.decodeObject(forKey: "status") as? String{
            self.status = value
        }
        if let value = aDecoder.decodeObject(forKey: "type") as? String{
         self.type = value
        }
        if let value = aDecoder.decodeObject(forKey: "vAuthToken") as? String{
            self.vAuthToken = value
        }
        if let value = aDecoder.decodeObject(forKey: "voice_action") as? String{
            self.voice_action = value
        }
        if let value = aDecoder.decodeObject(forKey: "linked_account_counters") as? String{
            self.linked_account_counters = value
        }
        if let value = aDecoder.decodeObject(forKey: "support_email") as? String{
            self.support_email = value
        }
        if let value = aDecoder.decodeObject(forKey: "archived_counter") as? String{
            self.archived_counter = value
        }

    }
    func loadUser() -> USER
    {   let userDefaultsReference = UserDefaults.standard
        let encodedeObject:NSData = userDefaultsReference.object(forKey: "ELUser") as! NSData
        let kUSerObject:USER = NSKeyedUnarchiver.unarchiveObject(with: encodedeObject as Data) as! USER
        return kUSerObject
    }
    func encode(with aCoder: NSCoder)    {
        aCoder.encode(self.isLogout, forKey: "isLogout")

        aCoder.encode(self.email_notification, forKey: "email_notification")
        aCoder.encode(self.isDeleteActionShow, forKey: "isDeleteActionShow")
        aCoder.encode(self.LinkedAccSenederSelected, forKey: "LinkedAccSenederSelected")
        aCoder.encode(self.support_email,forKey: "support_email")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.state, forKey: "state")
        aCoder.encode(self.country, forKey: "country")
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey: "longitude")

        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.id   , forKey: "id")
        aCoder.encode(self.location_service, forKey: "location_service")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.new_linked_account_notification, forKey: "new_linked_account_notification")
        aCoder.encode(self.notification, forKey: "notification")
        aCoder.encode(self.online, forKey: "online")
        aCoder.encode(self.profile_image, forKey: "profile_image")
        aCoder.encode(self.profile_image_zoom, forKey: "profile_image_zoom")
        aCoder.encode(self.sender_account_activity_notification, forKey: "sender_account_activity_notification")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.vAuthToken, forKey: "vAuthToken")
        aCoder.encode(self.voice_action, forKey: "voice_action")
        aCoder.encode(self.linked_account_counters, forKey: "linked_account_counters")
        aCoder.encode(self.archived_counter, forKey: "archived_counter")



    }
    
    
    
    private func loadContent(fromUser user:USER) -> Void    {
        self.isLogout                                         = user.isLogout
        self.email_notification                               = user.email_notification
        self.support_email                                    = user.support_email
        self.city                                             = user.city
        self.state                                            = user.state
        self.country                                          = user.country
        self.latitude                                         = user.latitude
        self.longitude                                        = user.longitude
        self.LinkedAccSenederSelected                         = user.LinkedAccSenederSelected
        self.email                                             = user.email
        self.id                                                = user.id
        self.location_service                                  = user.location_service
        self.name                                              = user.name
        self.new_linked_account_notification                   = user.new_linked_account_notification
        self.notification                                      = user.notification
        self.online                                            = user.online
        self.profile_image                                     = user.profile_image
        self.profile_image_zoom                                = user.profile_image_zoom
        self.sender_account_activity_notification              = user.sender_account_activity_notification
        self.status                                            = user.status
        self.type                                              = user.type
        self.vAuthToken                                        = user.vAuthToken
        self.voice_action                                      = user.voice_action
        self.linked_account_counters                           = user.linked_account_counters
        self.archived_counter                                   = user.archived_counter

        self.isDeleteActionShow                                = user.isDeleteActionShow
        
        
       
     
    }
    
    
    func save() -> Void    {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(encodedObject, forKey: "ELUser")
        UserDefaults.standard.synchronize()
    }
    
    func clear() -> Void
    {
        self.city                                       = ""
        self.state                                      = ""
        self.country                                    = ""
        self.latitude                                   = ""
        self.longitude                                  = ""
        self.email_notification                         = ""
        self.email                                      = ""
        self.id                                         = ""
        self.location_service                           = ""
        self.name                                       = ""
        self.new_linked_account_notification            = ""
        self.notification                               = ""
        self.online                                     = ""
        self.profile_image                              = ""
        self.profile_image_zoom                         = ""
        self.sender_account_activity_notification       = ""
        self.status                                     = ""
        self.type                                       = ""
        self.vAuthToken                                 = ""
        self.voice_action                               = ""
        self.support_email                              = ""
        self.linked_account_counters                          = ""
        self.archived_counter                          = ""
        self.isLogout           = false
        self.isDeleteActionShow           = true
        self.LinkedAccSenederSelected                   = false
        
        USER.shared.save()
    }
    
   func setFBData(dict:NSDictionary) -> Void {
    
    if let value = dict.value(forKey: "username") as? String {
               USER.shared.Fusername = value
    }
    if let value = dict.value(forKey: "name") as? String {
               USER.shared.Fname = value
    }
    if let value = dict.value(forKey: "email") as? String {
               USER.shared.Fname = value
    }
    if let value = dict.value(forKey: "profile_image") as? String {
               USER.shared.Fname = value
    }
    if let value = dict.value(forKey: "facebook_id") as? String {
               USER.shared.Fname = value
    }
    if let value = dict.value(forKey: "social_type") as? String {
               USER.shared.Fname = value
    }
    if let value = dict.value(forKey: "checkExist") as? String {
               USER.shared.Fname = value
    }
  USER.shared.save()


    }
    
    
    func setData(dict:NSDictionary) -> Void {
        if let value = dict.value(forKey:  "support_email") as? String{
            USER.shared.support_email = value
        }

        if let value = dict.value(forKey:  "city") as? String{
            USER.shared.city = value
        }
        if let value = dict.value(forKey:  "email_notification") as? String{
            USER.shared.email_notification = value
        }
        if let value = dict.value(forKey:  "state") as? String{
            USER.shared.state = value
        }
        if let value = dict.value(forKey:  "country") as? String{
            USER.shared.country = value
        }
        if let value = dict.value(forKey:  "latitude") as? String{
            USER.shared.latitude = value
        }
        if let value = dict.value(forKey:  "longitude") as? String{
            USER.shared.longitude = value
        }
        
            if let value = dict.value(forKey:  "email") as? String{
                  USER.shared.email = value
            }
        
              if let value = dict.value(forKey:  "id") as? String{
                  USER.shared.id = value
              }
              if let value = dict.value(forKey:  "location_service") as? String{
                  USER.shared.location_service = value
              }
              if let value = dict.value(forKey:  "name") as? String{
                  USER.shared.name = value
              }
              if let value = dict.value(forKey:  "new_linked_account_notification") as? String{
                  USER.shared.new_linked_account_notification = value
              }
        if let value = dict.value(forKey:  "linked_account_counters") as? String{
            USER.shared.linked_account_counters = value
        }
        if let value = dict.value(forKey:  "archived_counter") as? String{
            USER.shared.archived_counter = value
        }
              if let value = dict.value(forKey:  "notification") as? String{
                  USER.shared.notification = value
              }
              if let value = dict.value(forKey:  "online") as? String{
                  USER.shared.online = value
              }
              if let value = dict.value(forKey:  "profile_image") as? String{
                  USER.shared.profile_image = value
              }
              if let value = dict.value(forKey:  "profile_image_zoom") as? String{
                    USER.shared.profile_image_zoom = value
              }
              if let value = dict.value(forKey:  "sender_account_activity_notification") as? String{
                  USER.shared.sender_account_activity_notification = value
              }
              
              if let value = dict.value(forKey:  "status") as? String{
                  USER.shared.status = value
              }
              if let value = dict.value(forKey:  "type") as? String{
               USER.shared.type = value
              }
              if let value = dict.value(forKey:  "vAuthToken") as? String{
                  USER.shared.vAuthToken = value
              }
              if let value = dict.value(forKey:  "voice_action") as? String{
                  USER.shared.voice_action = value
              }
/*
        if let value = dict.value(forKey: "id") as? String {
            USER.shared.id = value
        }
        if let value = dict.value(forKey: "gender") as? String {
            USER.shared.gender = value
        }
        if let value = dict.value(forKey: "name") as? String {
            USER.shared.name = value
        }
        if let value = dict.value(forKey: "country") as? String {
                 USER.shared.country = value
             }
   
        if let value = dict.value(forKey: "email") as? String {
                 USER.shared.email = value
        }
   
        if let value = dict.value(forKey: "profile_image") as? String {
               USER.shared.profile_image = value
        }
        if let value = dict.value(forKey: "status") as? String {
               USER.shared.status = value
        }
        if let value = dict.value(forKey: "vAuthToken") as? String {
               USER.shared.vAuthToken = value
        }
        if let value = dict.value(forKey: "age") as? String {
                     USER.shared.age = value
            }
 */
            
        USER.shared.save()
    }
    func setPrefranceData(dict:[NSDictionary]) -> Void {
        USER.shared.preference = dict
        USER.shared.save()

    }
}
