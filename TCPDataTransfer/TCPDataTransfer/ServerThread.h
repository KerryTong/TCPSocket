//
//  ServerThread.h
//  TCPDataTransfer
//
//  Created by 仝兴伟 on 2018/5/26.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <sys/socket.h>
#import <netinet/in.h>
@interface ServerThread : NSThread
{
    
    CFSocketRef obj_server;
    @public
    NSTextField *tx_recv;

}


- (void)initializeServer:(NSTextField *)target_text_field;

- (void)main;

- (void)StopServer;
@end
