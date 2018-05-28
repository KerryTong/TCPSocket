//
//  GUIHandler.h
//  TCPDataTransfer
//
//  Created by 仝兴伟 on 2018/5/26.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ClientThread.h"
#import "ServerThread.h"
@interface GUIHandler : NSObject {
    ServerThread *obj_server_thread;
    ClientThread *obj_client_thread;
    @public
    __weak IBOutlet NSTextField *tx_send_data;
    __weak IBOutlet NSTextField *tx_recv_data;
}
- (IBAction)StartServerNow:(id)sender;
- (IBAction)StopServerNow:(id)sender;
- (IBAction)ConnectToServerNow:(id)sender;
- (IBAction)DisConnectFormServerNow:(id)sender;
- (IBAction)SenderDataToServer:(id)sender;

@end
