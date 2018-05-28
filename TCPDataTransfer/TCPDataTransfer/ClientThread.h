//
//  ClientThread.h
//  TCPDataTransfer
//
//  Created by 仝兴伟 on 2018/5/26.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
@interface ClientThread : NSThread
{
    CFSocketRef obj_client;
    @public
    NSTextField *tx_recv;
}

- (void)initialClinet;
- (void)initizeNative:(CFSocketNativeHandle)native_socket showRecData:(NSTextField *)targer_text_field;

- (void)main;

- (void)DisconnectFromServer;
- (void)sendtcpDataPacker:(const char*)data;

- (char *)ReadData;
@end
