//
//  SocketIOManager.swift
//  Inbox
//
//  Created by Md.Ballal Hossen on 24/6/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import SocketIO


let manager = SocketManager(socketURL: URL(string: "http://45.55.41.166:3000/")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

public class SocketIOManager: NSObject {
    
   
    public static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
   

    open func establishConnection(){
        
        socket.connect()
        
        print("establishConnection socketmanager")
    }
    
   open func closeConnection(){
        socket.disconnect()
    
        print("closeConnection socketmanager")
    }
    
    
    open func getNewMessages(){
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected..........");
        };
        
        socket.on("messages") {data, ack in
            
           // self.getHeadlines();
            print("getNewMessages socket",data)
            
        };
    }
    
    func connectToServerWithUserId(id: Any, completionHandler: (_ userList: [[String: Any]]?)->Void){
        
                
    }


}
