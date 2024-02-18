/*
MIT License

Copyright (c) 2017-2019 MessageKit

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit
//import MessageKit
//import InputBarAccessoryView
import MapKit
import Common
import SocketIO
import SwiftKeychainWrapper
import Kingfisher
import IQKeyboardManagerSwift
import SVProgressHUD

/// A base class for the example controllers
 public class ChatViewController: MessagesViewController, MessagesDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate {
    
    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)

    var messageList: [MockMessage] = []
    
    let refreshControl = UIRefreshControl()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    let outgoingAvatarOverlap: CGFloat = 17.5
    
    
  
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var viewForMedia: UIView!
    
    @IBOutlet weak var pinButton: UIButton!
    
    public var threadId = ""
    
    public var isPined = false
    
    public var userName = ""
    
    
    var fileStorageBase = ""
    
    var imageSelectView:UIView!
    
    var selectedImage:UIImage!
    
    var currentPage = 1
    
    var isFirstLoad = true
    
    var docController : UIDocumentInteractionController!
    
    lazy var manager = SocketManager(socketURL: URL(string: "http://45.55.41.166:3000/")!,config: [.log(false),.compress])
    
    var socket:SocketIOClient!

    var messageListFromApi:[ThreadMessageData] = []
    
    var scrollImageContainerView = UIView()// scrollImageView will be added here
    var scrollImageView = ImageScrollView()//for full image with zoom feature

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        //hide before loading data
        messagesCollectionView.isHidden = true;
        
        SVProgressHUD.show()
        
        self.tabBarController?.tabBar.isHidden = true
        
        IQKeyboardManager.shared.enable = false
        
        
        //register customcell
        messagesCollectionView.register(CustomCell.self)

        
        configureMessageCollectionView()
        configureMessageInputBar()
        
        titleLabel.text = userName
        
        if isPined {
            
            pinButton.isSelected = true
        }else{
            pinButton.isSelected = false
        }
        
        

        getMessages()
        
       
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu])
        //            .onNewMessage { [weak self] message in
        //                self?.insertMessage(message)
        //        }
        
        
    }

    
    func getMessages() {
        
        
        
        APIManager.manager.getMessagesOfThread(threadId: self.threadId,pageNo:currentPage) { (allMessages,token,userId,file_storage_base,current_page, msg) in
            
            SVProgressHUD.dismiss()
            
            self.fileStorageBase = file_storage_base!
            
            
            
            if self.currentPage == 1 {
            
                //set current user
            
                SampleData.shared.currentSender = MockUser(senderId: userId!, displayName:"", userAuth: "", userImage: "")
            
                //Socket
            
                self.socket = self.manager.defaultSocket
            
                //auth
                self.manager.config = SocketIOClientConfiguration(arrayLiteral: .compress,.connectParams(["token" : token!]))
            
                self.setSocketEvents();
            
                self.socket.connect();
            
            
            }


            //load messages

          //  if self.currentPage == 1{
              
                self.messageListFromApi = allMessages
                
                self.loadMessages()
                
//            }
//            else{
//
//                for single in allMessages{
//
//
//                    self.messageListFromApi.append(single)
//
//
//                }
//
//
//                self.loadMessages()
//
//
//            }
            
            
            
            
        }

    }
    
    
    
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      //  MockSocket.shared.disconnect()
        audioController.stopAnyOngoingPlaying()
        
       
    }
    //let wu = MockUser(senderId: "000003", displayName: "Wu Zhong")

    func loadMessages() {
       
        print("loadFirstMessages",messageListFromApi.count)
        
     //   self.messageList.removeAll()
        
        let allMsg:[ThreadMessageData]!
        
        if self.currentPage == 1{
            
          allMsg = messageListFromApi.reversed()
            
        }else{
            
            allMsg = messageListFromApi
        }

        for singleMessage in allMsg{
            
            let senderId = "\(String(describing: singleMessage.sent_by!))"
            
            let sender = MockUser(senderId: senderId , displayName: singleMessage.full_name ?? "no name", userAuth: singleMessage.authId ?? "", userImage: singleMessage.user_image_thumb ?? "")
                let msg = singleMessage.message ?? "no msg"
            
                let dateHelper = DateTimeHelper()
            
                let date = dateHelper.getDate(format: "yyyy-MM-dd'T'HH:mm:ssXXXXX", dateString: singleMessage.date_created!)
            
                let messageId = "\(String(describing: singleMessage.message_id!))"
            
               if singleMessage.content_type == "TEXT"{
                
                  let message = MockMessage(text: msg, user: sender, messageId: messageId, date: date)
                
                if self.currentPage == 1{
                    
                    self.messageList.append(message)
                    
                }else{
                    
                    self.messageList.insert(message, at: 0)
                }
                
               }else if singleMessage.content_type == "IMAGE"{
                
                let imageUrl:String = singleMessage.content!["url"] as! String
              
                let url = URL(string: fileStorageBase + imageUrl )
                
                
                
                
                
                let message = MockMessage(imageUrl:url!, user: sender, messageId: messageId, date: date)
                
                if self.currentPage == 1{
                    
                    self.messageList.append(message)
                    
                }else{
                    
                    self.messageList.insert(message, at: 0)
                }

               }else if singleMessage.content_type == "DOCUMENT"
               {
                
                let fileUrl:String = singleMessage.content!["url"] as! String
                
                let url = URL(string: fileStorageBase + fileUrl )
                
                print("web url.......",url!)
                
                let fileName = singleMessage.content!["file_name"] as! String

//                let localUrlString = fileStorageBase + fileName
//
//                print("local url.......",localUrlString)
//
//
//                let fileURL = URL(string: localUrlString)
                
                let tempDic = [
                    "url":url!,
                    "name":fileName,
                    "fileType": url!.pathExtension,
                    ] as [String : Any]
                
                
                let message = MockMessage(custom: tempDic, user: sender, messageId: messageId, date: date)
                
                if self.currentPage == 1{
                    
                    self.messageList.append(message)
                    
                }else{
                    
                    self.messageList.insert(message, at: 0)
                }

                
//                let fileManager = FileManager.default
//
//                if fileManager.fileExists(atPath: fileURL!.path){
//
//                    print("loadMessages file exist")
//
//
//
//                }
                
            
            }

            }
            
            
            DispatchQueue.main.async {
                
             
              
              // self.messageList = self.messageList.reversed()
                
               
                if self.currentPage == 1{
                    
                    
                  self.messagesCollectionView.reloadData()
                  self.messagesCollectionView.scrollToBottom()
                  self.messagesCollectionView.isHidden = false
                    
                }
                else{

                    self.messagesCollectionView.reloadDataAndKeepOffset()
                }
        
                print("message list count",self.messageList.count)
            }
        
    }
    
    
    private func setSocketEvents()
    {
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected..........",data);
        };
        
        self.socket.on("messages") {data, ack in
            
            print("got live message",data);
            
            
            
            for newMessage in data{
                
                print("newMessage.....",newMessage)
                
                if let singlemsg = newMessage as? Dictionary<String, Any>{
                    
                    let senderInInt = singlemsg["sent_by"] as!Int
                    
                    print("senderInInt......",senderInInt)
                    
                    let senderId = "\(String(describing: senderInInt))"
                    
                    let sender = MockUser(senderId: senderId , displayName: singlemsg["full_name"] as! String, userAuth:  singlemsg["auth_id"] as! String, userImage:  singlemsg["user_image_thumb"] as! String)
                    
                    let dateHelper = DateTimeHelper()
                    
                    let date = dateHelper.getDate(format: "yyyy-MM-dd'T'HH:mm:ssXXXXX", dateString: singlemsg["date_created"] as! String)
                    
                    let messageId = "\(String(describing: singlemsg["date_created"] as! String))"
                    
                    
                    
                    let currentUser = SampleData.shared.currentSender?.senderId
                    let currentSenderId:String = senderId
                    
                    print("currentSenderId",currentUser!, currentSenderId)
                    
                    
                    if currentUser! == currentSenderId {
                        
                        
                    }else{
                        
                        if singlemsg["content_type"] as! String == "TEXT"{
                            
                            let msg = singlemsg["message"] as! String
                            
                            let message = MockMessage(text: msg, user: sender, messageId: messageId, date: date)
                            
                            self.insertMessage(message)
                            
                        }else if singlemsg["content_type"] as! String == "IMAGE"{
                            
                            let contentDic = singlemsg["content"] as! Dictionary<String,Any>
                            
                            let imageUrl:String = contentDic["url"] as! String
                            
                            let fileStorageBase = singlemsg["file_storage_base"] as! String
                            
                            let url = URL(string: fileStorageBase + imageUrl )
                            
                            let message = MockMessage(imageUrl:url!, user: sender, messageId: messageId, date: date)
                            self.messageList.append(message)
                            self.messagesCollectionView.reloadData()
                            self.messagesCollectionView.scrollToBottom()
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
            }
            
            
        };
    };

    
//    @objc
//    func loadMoreMessages() {
//        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
//            SampleData.shared.getMessages(count: 20) { messages in
//                DispatchQueue.main.async {
//                    self.messageList.insert(contentsOf: messages, at: 0)
//                    self.messagesCollectionView.reloadDataAndKeepOffset()
//                    self.refreshControl.endRefreshing()
//                }
//            }
//        }
//    }
    
    func configureMessageCollectionView() {
        
        //editted messageviewcontroller's private func setupConstraints() for top constraint
        if #available(iOS 11.0, *) {
            
            let top = messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length+84)
            
            NSLayoutConstraint.activate([top])
            
        }else{
        
           let top = messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length+64)
        
           NSLayoutConstraint.activate([top])
        }

        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
//        messagesCollectionView.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
//
        
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        
        // Set outgoing avatar to overlap with the message bubble
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 18))
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        
        
    }
    
   
    
    func configureMessageInputBar() {

        messageInputBar.delegate = self
        
        
        
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.sendButton.setTitleColor(.primaryColor, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.primaryColor.withAlphaComponent(0.3),
            for: .highlighted
        )
       
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = .primaryColor
        
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 8)
        messageInputBar.inputTextView.layer.borderColor = UIColor.primaryColor.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        messageInputBar.setLeftStackViewWidthConstant(to: 40, animated: false)
        
        
        //add a accessory(Plus) button ************
        
        let accessoriesButton = UIButton(frame: CGRect(x: 0, y: 5, width: 30, height: 30))
        accessoriesButton.setImage(UIImage(named: "plus_icon.png"), for: .normal)
        //accessoriesButton.backgroundColor = .primaryColor
        accessoriesButton.addTarget(self, action: #selector(accessoriesButtonAction), for: .touchUpInside)


        messageInputBar.leftStackView.addSubview(accessoriesButton)
        
        //**********
        
        
      
        configureInputBarItems()

     
        
    }
    
    private func configureInputBarItems() {
            messageInputBar.setRightStackViewWidthConstant(to: 50, animated: false)
            messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
            messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            messageInputBar.sendButton.setSize(CGSize(width: 50, height: 36), animated: false)
    //        messageInputBar.sendButton.image = #imageLiteral(resourceName: "ic_up")
            messageInputBar.sendButton.title = "SEND"
           // messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        
        
            messageInputBar.middleContentViewPadding.right = 0
        
//            let charCountButton = InputBarButtonItem()
//                .configure {
//                    $0.title = "0/140"
//                    $0.contentHorizontalAlignment = .right
//                    $0.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
//                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
//                    $0.setSize(CGSize(width: 50, height: 25), animated: false)
//                }.onTextViewDidChange { (item, textView) in
//                    item.title = "\(textView.text.count)/140"
//                    let isOverLimit = textView.text.count > 140
//                    item.inputBarAccessoryView?.shouldManageSendButtonEnabledState = !isOverLimit // Disable automated management when over limit
//                    if isOverLimit {
//                        item.inputBarAccessoryView?.sendButton.isEnabled = false
//                    }
//                    let color = isOverLimit ? .red : UIColor(white: 0.6, alpha: 1)
//                    item.setTitleColor(color, for: .normal)
//            }
//            let bottomItems = [.flexibleSpace, charCountButton]
//            messageInputBar.middleContentViewPadding.bottom = 8
//            messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
//
            // This just adds some more flare
            messageInputBar.sendButton
                .onEnabled { item in
                    UIView.animate(withDuration: 0.3, animations: {
                        item.imageView?.backgroundColor = .primaryColor
                    })
                }.onDisabled { item in
                    UIView.animate(withDuration: 0.3, animations: {
                        item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
                    })
            }
        }
    
    
    
    //pagination
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        var visibleRect = CGRect()
//
//        visibleRect.origin = self.messagesCollectionView.contentOffset
//        visibleRect.size = self.messagesCollectionView.bounds.size
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//
//        let screenHeight = UIScreen.main.bounds.height
//
//        print("visiblePoint....... \(visiblePoint.y) screenHeight",screenHeight)
//
//
//
//
//    }
    
    override public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
      //  print("indexpath.section.........",indexPath.section,messageList[messageList.count - 1])
        
        if indexPath.section == 3 {


              currentPage += 1

              getMessages()


        }
        
    }
    
    
    //accessories button Action
    
    
    @objc func accessoriesButtonAction(sender: UIButton!) {
        
        print("Button tapped")
        
        let alert = UIAlertController(title: "Choose option", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            
                self.getImage(fromSourceType: .photoLibrary)
        }))
        
//        alert.addAction(UIAlertAction(title: "Document", style: .default , handler:{ (UIAlertAction)in
//
////              let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
//
//            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.composite-content", "public.text"], in: .import)
//
//
//            documentPicker.delegate = self
//            documentPicker.modalPresentationStyle = .formSheet
//            self.present(documentPicker, animated: true, completion: nil)
//
//        }))
//
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
//            print("User click Delete button")
//        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
            
        })
        
    }
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
      //   self.dismiss(animated: true, completion: nil)
        
        // if mediaType.isEqual(to: kUTTypeImage as String) {
        let image = info[UIImagePickerController.InfoKey.originalImage]
            as! UIImage
        
        print("picked image")
        
        
        selectedImage = image
        
        //  }

        
        let screenSize: CGRect = UIScreen.main.bounds
        imageSelectView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        imageSelectView.backgroundColor = .white
        
        let button = UIButton(frame: CGRect(x: 5, y: 25, width: 60, height: 50))
        button.backgroundColor = .clear
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.addTarget(self, action: #selector(cancelPhoto), for: .touchUpInside)
        
        imageSelectView.addSubview(button)
        
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 100, width: screenSize.width, height: screenSize.height-180)
        imgView.contentMode = .scaleAspectFit
        imgView.image = image
        
        imageSelectView.addSubview(imgView)
        
        let sendbutton = UIButton(frame: CGRect(x: screenSize.width/2 - 30, y: screenSize.height - 60, width: 60, height: 40))
        sendbutton.backgroundColor = .clear
        sendbutton.setTitle("Send", for: .normal)
        sendbutton.setTitleColor(.primaryColor, for: .normal)
        sendbutton.addTarget(self, action: #selector(sendPhoto), for: .touchUpInside)
        
        imageSelectView.addSubview(sendbutton)
        
       
        picker.view.addSubview(imageSelectView)
        
        
    }
    
    @objc func cancelPhoto(sender: UIButton!) {
        
        print("cancelPhoto Button tapped")
        
        imageSelectView.isHidden = true
        
        
    }
    
    @objc func sendPhoto(sender: UIButton!) {
        
        print("sendPhoto Button tapped")
        
        insertMessages([selectedImage as Any])
        self.messagesCollectionView.scrollToBottom(animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let fileurl: URL = urls.last!
        
        let fileExtention = fileurl.pathExtension
        
        print("pathExtention..........",fileurl,fileExtention)
        
        let tempDic = [
            "url":fileurl,
            "name":fileurl.lastPathComponent,
            "fileType": fileExtention,
            ] as [String : Any]
        
        insertMessages([tempDic as Any])
        
        
    }
    
    
    
    
    
    @IBAction func pinButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        let isPin:Int
        
        if sender.isSelected {
            
            isPin = 1
        }else{
            
            isPin = 0
        }
        print("isPin",isPin)
        
        APIManager.manager.updateMessagesOfThread(threadId: self.threadId, isPined: isPin) { (dataDic, msg) in
            
            
            print("pinButtonAction",msg)
            
            //have to check if api call is successful
        }
    
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        socket.disconnect()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    

    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        
        messageList.append(message)
        
     //   print("messageList last msg in insertMessage ",messageList.last!)
        
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            
            messagesCollectionView.insertSections([messageList.count - 1])
            
            if messageList.count >= 2 {
                
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            
            if self?.isLastSectionVisible() == true {
                
                self?.messagesCollectionView.scrollToBottom(animated: true)
                
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        
       // return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    
       return !isPreviousMessageSameSender(at: indexPath)
        
       // return true
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section - 1].user
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section + 1].user
    }
    
    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
        updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
        setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
            if success, self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 25, height: 25), animated: false)
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onSelected {
                $0.tintColor = .primaryColor
            }.onDeselected {
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onTouchUpInside {
                print("Item Tapped")
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                actionSheet.addAction(action)
                if let popoverPresentationController = actionSheet.popoverPresentationController {
                    popoverPresentationController.sourceView = $0
                    popoverPresentationController.sourceRect = $0.frame
                }
                self.navigationController?.present(actionSheet, animated: true, completion: nil)
        }
    }

    
    // MARK: - MessagesDataSource
    
    public func currentSender() -> SenderType {

       // print("currentSender call in chat",SampleData.shared.currentSender!.senderId)

        return SampleData.shared.currentSender!
    }
    
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return messageList.count
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messageList[indexPath.section]
        
    }
    
    public func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
      //  if indexPath.section % 3 == 0 {
            
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 7), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
     //   }
     //   return nil
    }
    
    public func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        print("cellBottomLabelAttributedText......................")
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
    }
    
    public func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        //hide name for self
        if isFromCurrentSender(message: message){
            
            return NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    public func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
//        let dateString = formatter.string(from: message.sentDate)
//        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
        
        return nil
        
    }
    
    
    public func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {

        //must register CustomCell in viewdidload()
        
        let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        return cell
        
        
    }
    
    //**********************
    
    

    
}

// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    
    public func didTapBackground(in cell: MessageCollectionViewCell) {
        
        print("didTapBackground")
        
        self.messageInputBar.inputTextView.resignFirstResponder()
    }
    
    public func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            let message = messageList[indexPath.section]
 
            let user = message.user
            
            let authId = user.userAuth
            
            print("message didTapAvatar",authId)
            
            
            
            let tempDic = ["authId" : authId]
            // call in appdelegate
            navigate(MyNavigation.profile,from:self, info: tempDic as Dictionary<String, Any>)
            

        }
    }
    
    public func didTapMessage(in cell: MessageCollectionViewCell) {
        
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            let message = messageList[indexPath.section]
            print("Message tapped,indexPath.section: ",indexPath.section)
            
            switch message.kind {
             
            case .photo(let photoItem):
                
                print("tap on photo",photoItem.image)
                
                scrollImageContainerView = UIView(frame: (CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
                scrollImageContainerView.backgroundColor = .white
                
                self.view.addSubview(scrollImageContainerView)
                
                let button = UIButton(frame: CGRect(x: 5, y: 25, width: 60, height: 50))
                button.backgroundColor = .clear
                button.setTitle("Close", for: .normal)
                button.setTitleColor(.primaryColor, for: .normal)
                button.addTarget(self, action: #selector(closeFullPhoto), for: .touchUpInside)
                
                scrollImageContainerView.addSubview(button)
                
                
                scrollImageView = ImageScrollView(frame: (CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
                scrollImageView.backgroundColor = .white
                scrollImageContainerView.addSubview(scrollImageView)
                
            
                scrollImageContainerView.bringSubviewToFront(button)
                
                
                scrollImageView.setup()
                
                if (photoItem.url) != nil{
                    
                    KingfisherManager.shared.retrieveImage(with: photoItem.url!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                        
                        self.messageInputBar.isHidden = true
                        self.scrollImageView.display(image: image!)
                    })
                    
                }else{
                    
                    self.messageInputBar.isHidden = true
                    self.scrollImageView.display(image: photoItem.image!)
                    
                }
                
               

               
                
//          case .video(let videoItem):
//
//                if let videoUrl = videoItem.url {
//                    let player = AVPlayer(url: videoUrl)
//                    let playerViewController = AVPlayerViewController()
//                    playerViewController.player = player
//                    present(playerViewController, animated: true) {
//                        playerViewController.player!.play()
//                    }
//                }
                
              
                
            case .custom(let docDic):
                
                let tempDic = docDic as? Dictionary<String,Any>
                
                if tempDic!["url"] != nil{
                    
                    print("url..................",tempDic!["url"]!)
                    
                    let fileURL = tempDic!["url"]! as! URL
                    
                    let storyBoard = UIStoryboard(name: "Inbox", bundle: Bundle(for: ChatViewController.self ))
                    
                    let vc :OpenDocumentViewController = storyBoard.instantiateViewController(withIdentifier: "OpenDocumentViewController") as! OpenDocumentViewController
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.webUrl = fileURL
                    vc.fileName = (tempDic!["name"]! as! String)
                    self.present(vc, animated: true) {
                        
                        
                    }

//                    let fileManager = FileManager.default
//
//                    if fileManager.fileExists(atPath: fileURL.path){
//
//                        print("file is local")
//
//                        self.docController = UIDocumentInteractionController(url: fileURL)
//                        docController.delegate = self
//
//                        docController.presentPreview(animated: true)
//
//                    }else{
//
//
//                    }
                }
                
                
            default:
                break
            
        }
    }

        
    }
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
//    public func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
//        
//        UIInteraction = nil
//    }
    
    
    
    @objc func closeFullPhoto(sender: UIButton!) {
        
        scrollImageContainerView.removeFromSuperview()
        messageInputBar.isHidden = false
        
    }

    
    
    
    
    public func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
        
        self.messageInputBar.inputTextView.resignFirstResponder()
    }
    
    public func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    public func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    public func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    public func didTapPlayButton(in cell: AudioMessageCell) {
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }

    public func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    public func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }

    public func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }

    public func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        
        print("Accessory view tapped")
        
        
    }

}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    
    public func didSelectAddress(_ addressComponents: [String: String]) {
        
        print("Address Selected: \(addressComponents)")
        
    }
    
    public func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    public func didSelectPhoneNumber(_ phoneNumber: String) {
        
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    public func didSelectURL(_ url: URL) {
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        print("URL Selected: \(url)")
    }
    
    public func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }

    public func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }

    public func didSelectMention(_ mention: String) {
        
        print("Mention selected: \(mention)")
    }

    public func didSelectCustom(_ pattern: String, match: String?) {
        
        print("Custom data detector patter selected: \(pattern)")
    }

}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {

    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
//            // fake send request task
//            sleep(1)
            
           
            
            
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    private func insertMessages(_ data: [Any]) {
        
        
        
        for component in data {
            let user = SampleData.shared.currentSender!
            var messageText = ""
            
            if let str = component as? String {
                
                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
                
                messageText = str
                
                insertMessage(message)
                
                //send to server
                
                var contentDic = [String: Any]()
                
                var params = [
                    
                    "content_type":"TEXT",
                    "content":contentDic,
                    "message":messageText,
                    ] as [String : Any]
                
                APIManager.manager.postMessagesOfThread(threadId: self.threadId, params: params, withCompletionHandler: { (returnDic, msg) in

                    print("msg in post messege",returnDic)


                })

                
            } else if let img = component as? UIImage {
                
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                
                insertMessage(message)
                
                print("image upload")
                
                //send to server
                

                let params = [

                    "content_type":"IMAGE",
                    
                ] as [String : Any]
                
                let mediaInfo = [
                    
                    "fileType":"image",
                    "image" : img
                    
                    ] as [String : Any]

                APIManager.manager.postMediaMessagesOfThread(threadId: self.threadId,mediaInfo:mediaInfo, params: params, withCompletionHandler: { (returnDic, msg) in

                    print("msg in post messege",returnDic)


                })

            }else if let dic = component as? Dictionary<String, Any>{  //message type custom
                
                //changed code in TextMessageSizeCalculator class(messageContainerSize method),MessagesCollectionViewFlowLayout class( cellSizeCalculatorForItem method)
                //---should implement customCellSizeCalculator
                
                
                
                
                
                let message = MockMessage(custom: dic, user: user, messageId: UUID().uuidString, date: Date())
                
               
                
                insertMessage(message)
                
                
//                var params = [
//
//                    "content_type":"DOCUMENT",
//
//                    ] as [String : Any]
//
//                var mediaInfo = dic
//
//                APIManager.manager.postMediaMessagesOfThread(threadId: self.threadId,mediaInfo:mediaInfo, params: params, withCompletionHandler: { (returnDic, msg) in
//
//                    print("msg in post messege",returnDic)
//
//
//                })

                
            }
            
        }
    }
}



// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    public func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
      
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    public func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        

        
        switch detector {
          
        case .hashtag, .mention,.url:
            

            
            if isFromCurrentSender(message: message) {
                return [.foregroundColor: UIColor("#3366ff")]
            } else {
                return [.foregroundColor: UIColor("#3366ff")]
            }
       
            
        default:
            return [.foregroundColor: UIColor.white]
           // return MessageLabel.defaultAttributes
        }
    }
    
    public func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
     //   return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag,.custom(try! NSRegularExpression(pattern: ".[.a-z]{4,}", options: []))]

    }
    
    // MARK: - All Messages
    
    public func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? .primaryColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
    }
    
    public func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    public func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let message = messageList[indexPath.section]
        
        if let url = URL(string: "https://storage.googleapis.com/disco-outpost-198321.appspot.com/image/photos/\(String(describing: message.user.userImage))"){
            
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                
                avatarView.image = image
            })
        }
        
        
        
            
        print("message configureAvatarView",message)
        
//        let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
//        avatarView.set(avatar: avatar)
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
       // avatarView.layer.borderWidth = 2
       // avatarView.layer.borderColor = UIColor.primaryColor.cgColor
    }
    
    public func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        
        
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
    
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        accessoryView.backgroundColor = .clear
        
        let docImageView = UIImageView(frame: CGRect(x:2,y:0,width:accessoryView.frame.size.width-4,height:accessoryView.frame.size.height-4))
       // docImageView.backgroundColor = UIColor.primaryColor
        docImageView.image = UIImage(named: "doc_icon.png")
        accessoryView.addSubview(docImageView)
        
        
//        let shouldShow = Int.random(in: 0...10) == 0
//        guard shouldShow else { return }
        
//        let button = UIButton(type: .infoLight)
//        button.tintColor = .primaryColor
//        accessoryView.addSubview(button)
//        button.frame = accessoryView.bounds
//        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
      //  accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
//        accessoryView.backgroundColor = UIColor.primaryColor.withAlphaComponent(0.3)
//
        
        //hide accessoryview
 //       accessoryView.isHidden = true        // hide for all
        
        switch message.kind {
            
        case .custom(let docDic):
            
            accessoryView.isHidden = false
            
        default:
            
            accessoryView.isHidden = true
            
        }
        
    }
    
    // MARK: - Media Messages
    
    public func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
       
        switch message.kind {
        case .photo(let photoItem):
            
            /// if we don't have a url, that means it's simply a pending message
            guard let url = photoItem.url else {
                
                
                return
            }
            
           
            (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white//not working
            
            imageView.kf.indicator?.startAnimatingView()
            imageView.kf.setImage(with: url)
            
        default:
            break
        }
        
    }
    
    
    
    // MARK: - Location Messages
    
    public func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "ic_map_marker")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    public func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(2, 2, 2)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    public func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }
    
    // MARK: - Audio Messages
    
    public func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return self.isFromCurrentSender(message: message) ? .white : .primaryColor
    }
    
    public func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound
    }
    
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    
    public func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if isTimeLabelVisible(at: indexPath) {
            return 10
        }
        return 0
    }
    
    public func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
        }
    }
    
    public func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
    
//    func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
//
//        return TextMessageSizeCalculator
//    }
    
}
