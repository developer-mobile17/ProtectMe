
import UIKit


class downloadfolder: UIViewController {
    let filemgr = FileManager.default
    var foldername = "Temp"
    var arrFileList:[archivedListModel] = [archivedListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createFolderinFileApp()
    }
    func downloadAllfiles(foldername:String){
        let commaSapratedStrIDS = arrFileList.map{String($0.image_path!)}
        print(commaSapratedStrIDS)
        for item in commaSapratedStrIDS{
            let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
            let docsURL = dirPaths[0]
            let newDir = docsURL.appendingPathComponent("ProtectMe").path
            
            do{
                try filemgr.createDirectory(atPath: newDir,withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
                    APPDELEGATE.SHOW_CUSTOM_LOADER()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        // ...
                        let path = item
                        let fileName = URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
                        let  fileExtension = URL(fileURLWithPath: path).pathExtension
                        Swift.print(fileName,".",fileExtension)
                        
                        let fileNameWithExtension = "\(fileName).\(fileExtension)"
                        let a = self.foldername
                        let newDir1 = docsURL.appendingPathComponent("ProtectMe/\(a)").path

                        do{
                            try self.filemgr.createDirectory(atPath: newDir1,withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                        
                        
                        
                        let url = URL(string: item)
                        let pdfData = try? Data.init(contentsOf: url!)
                        let resourceDocPath = docsURL
                        let pdfNameFromUrl = fileNameWithExtension
                        let actualPath = resourceDocPath.appendingPathComponent("ProtectMe").appendingPathComponent("\(a)").appendingPathComponent("\(pdfNameFromUrl)")
                        print(resourceDocPath,actualPath)
                        do {
                            try pdfData?.write(to: actualPath, options: .atomic)
                            
                            NotificationCenter.default.post(name: NSNotification.Name("download"), object: nil)
            //                Toast(text: "Successfully downloaded").show()
                            APPDELEGATE.HIDE_CUSTOM_LOADER()
                            print("successfully saved!")
                        } catch {
                            APPDELEGATE.HIDE_CUSTOM_LOADER()
                            print(" could not be saved")
                        }
                    }
            

            
        }
        NotificationCenter.default.post(name: NSNotification.Name("downloadcan"), object: nil)

    }
    func getfilelist(folderid:String,foldername:String){
        self.foldername = foldername
        self.WSFolderList1(Parameter: ["folder_id":folderid])
    }
    func createFolderinFileApp(){


        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)

        let docsURL = dirPaths[0]

        let newDir = docsURL.appendingPathComponent("ProtectMe").path

        do{
            try filemgr.createDirectory(atPath: newDir,withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    func WSFolderList1(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .nested_folder_list, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let archived_counter = dataResponce["archived_counter"] as? Int{
                        USER.shared.archived_counter = String(archived_counter)
                        USER.shared.save()
                    }
                                       if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                                                               USER.shared.linked_account_counters = String(linked_account_counters)
                                       USER.shared.save()
                                       }
                    if let outcome = dataResponce["data"] as? NSDictionary{
                        self.arrFileList.removeAll()


                        if let FileArr = outcome["file_list"] as? [NSDictionary]{
                            for a : Int in (0..<(FileArr.count))
                            {
                                let objarchivedList : archivedListModel = archivedListModel()
                                objarchivedList.city         = FileArr[a]["city"] as? String ?? ""
                                objarchivedList.country      = FileArr[a]["country"] as? String ?? ""
                                objarchivedList.created      = FileArr[a]["created"] as? String ?? ""
                                objarchivedList.file_size    = FileArr[a]["file_size"] as? String ?? ""
                                objarchivedList.folder_id    = FileArr[a]["folder_id"] as? String ?? ""
                                objarchivedList.folder_name  = FileArr[a]["folder_name"] as? String ?? ""
                                objarchivedList.id           = FileArr[a]["id"] as? String ?? ""
                                objarchivedList.image_name   = FileArr[a]["image_name"] as? String ?? ""
                                objarchivedList.image_path   = FileArr[a]["image_path"] as? String ?? ""
                                objarchivedList.longitude    = FileArr[a]["longitude"] as? String ?? ""
                                objarchivedList.latitude     = FileArr[a]["latitude"] as? String ?? ""
                                objarchivedList.state        = FileArr[a]["state"] as? String ?? ""
                                objarchivedList.status       = FileArr[a]["status"] as? String ?? ""
                                objarchivedList.type         = FileArr[a]["type"] as? String ?? ""
                                objarchivedList.updated      = FileArr[a]["updated"] as? String ?? ""
                                objarchivedList.uploaded_by  = FileArr[a]["uploaded_by"] as? String ?? ""
                                objarchivedList.user_id      = FileArr[a]["user_id"] as? String ?? ""
                                objarchivedList.name         = FileArr[a]["name"] as? String ?? ""
                                objarchivedList.thumb_image  = FileArr[a]["thumb_image"] as? String ?? ""
                                self.arrFileList.append(objarchivedList)
                            }
                            self.downloadAllfiles(foldername: self.foldername)
                          //  self.collVideogrid.reloadSections(NSIndexSet(index: 1) as IndexSet)
                        }

                        
                    }
                }
                    else if(StatusCode == 307)
                    {
                        if let errorMessage:String = dataResponce["message"] as? String{
                        if let LIveURL:String = dataResponce["iOS_live_application_url"] as? String{
                            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: errorMessage, buttons: ["Open Store"]) { (i) in
                                if let url = URL(string: LIveURL),
                                UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.openURL(url)
                                }
                            }
                            }
                            //showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                            }
                    }
                    else if(StatusCode == 412)
                    {
                        if let errorMessage:String = dataResponce["message"] as? String{
                                showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                        }
                    }
                else if(StatusCode == 401)
                {
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                            USER.shared.isLogout = true
                            USER.shared.save()
                                appDelegate.setLoginVC()
                                // Fallback on earlier versions
                            
                        }
                    }
                }
                else{
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                    }
                }
            }
            else{
                if let errorMessage:String = Message{
                    showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                }
            }
        }) { (DataResponce, Status, Message) in
            //
        }
    }
}
