//
//  GUIHandler.m
//  TCPDataTransfer
//
//  Created by 仝兴伟 on 2018/5/26.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "GUIHandler.h"

@implementation GUIHandler

- (IBAction)StartServerNow:(id)sender {
    obj_server_thread  = [[ServerThread alloc]init];
    [obj_server_thread initializeServer:tx_recv_data];
    [obj_server_thread start];
}

- (IBAction)StopServerNow:(id)sender {
    [obj_server_thread StopServer];
    [obj_server_thread cancel];
}

- (IBAction)ConnectToServerNow:(id)sender {
    obj_client_thread = [[ClientThread alloc]init];
    [obj_client_thread initialClinet];
    [obj_client_thread start];
}

- (IBAction)DisConnectFormServerNow:(id)sender {
    [obj_client_thread DisconnectFromServer];
    [obj_client_thread cancel];
}

- (IBAction)SenderDataToServer:(id)sender {
    [obj_client_thread sendtcpDataPacker:[[tx_send_data stringValue]UTF8String]];
}
































@end
