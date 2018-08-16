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


/**
 初始化客户端
 */
- (void)initialClinet;


- (void)initizeNative:(CFSocketNativeHandle)native_socket showRecData:(NSTextField *)targer_text_field;

- (void)main;


/**
 DisconnectFromServer
 */
- (void)DisconnectFromServer;


/**
 从clinet发送 data 内容

 @param data data
 */
- (void)sendtcpDataPacker:(const char*)data;


/**
 读取server data

 @return data
 */
- (char *)ReadData;
@end
