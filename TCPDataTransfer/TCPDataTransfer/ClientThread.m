//
//  ClientThread.m
//  TCPDataTransfer
//
//  Created by 仝兴伟 on 2018/5/26.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "ClientThread.h"

@implementation ClientThread

- (void)initialClinet {
    CFSocketContext sctx = {0,(__bridge void *)(self),NULL,NULL,NULL};
    // 创建socket
    obj_client = CFSocketCreate(kCFAllocatorDefault, // 为对象分配内存 可为nil
                                AF_INET, // 协议族 0或负数  默认为 PF_INET
                                SOCK_STREAM, // 套接字类型，协议族为 PF_INET 默认
                                IPPROTO_TCP, // 套接字协议
                                kCFSocketConnectCallBack, // 触发回调消息类型
                                TCPClientCallBackHandler, // 回调函数
                                &sctx); // 一个持有CFSocket结构消息的对象， 可以为nil
    
    // 配置服务器地址
    struct sockaddr_in sock_addr; // IPV4
    
    memset(&sock_addr, 0, sizeof(sock_addr));
    
    sock_addr.sin_len = sizeof(sock_addr);
    
    sock_addr.sin_family = AF_INET; // 协议族
    sock_addr.sin_port = htons(6658); // 端口
    inet_pton(AF_INET, "127.0.0.1", &sock_addr.sin_addr); // 把字符串的地址转为机器可识别的网络地址
    
    CFDataRef dref = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&sock_addr, sizeof(sock_addr)); // 绑定socket
    
    CFSocketConnectToAddress(obj_client, dref, -1); // 链接超时时间，如果为负，则不尝试链接，而是把链接放到后台进行，如果obj_client 消息类型为 kCFSocketConnectCallBack ,将会在链接成功或者失败的时候在后台触发回调函数
    
    // 释放dref
    CFRelease(dref);
    
}
- (void)main {
    CFRunLoopSourceRef loopref = CFSocketCreateRunLoopSource(kCFAllocatorDefault, obj_client, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), loopref, kCFRunLoopDefaultMode);
    CFRelease(loopref);
    CFRunLoopRun();
}

- (void)DisconnectFromServer {
    CFSocketInvalidate(obj_client);
    CFRelease(obj_client);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)sendtcpDataPacker:(const char*)data {
    int initialize[1] = {2}; // initialize
    int separator[1] = {4};
    int data_length = (int)strlen(data);
    int target_length = snprintf(NULL, 0, "%d", data_length);
    char *data_length_char = malloc(target_length + 1);
    snprintf(data_length_char, target_length+1, "%d",data_length); // this line of code vonvert （45 into "45"）

    int ele_count = (int)strlen(data_length_char);
    int *size_buff = (int*)malloc(ele_count*sizeof(int));
    for (int counter = 0; counter < ele_count; counter++) {
        size_buff[counter] = (int)data_length_char[counter];
    }
    
    int packet_length = 1 + 1 + ele_count + (int)strlen(data);
    UInt8 *packet =(UInt8*)malloc(packet_length * sizeof(UInt8));
     memcpy(&packet[0], initialize, 1);
    for (int counter = 0; counter < ele_count; counter++) {
        memcpy(&packet[counter +1], &size_buff[counter], 1);
    }

    memcpy(&packet[0 + 1 + ele_count], separator, 1);
    memcpy(&packet[0 + 1 + ele_count+1], data, strlen(data));
    CFDataRef dref = CFDataCreate(kCFAllocatorDefault, packet, packet_length);
    
    CFSocketSendData(obj_client, NULL, dref, -1);
    free(packet);
    free(size_buff);
    free(data_length_char);
    CFRelease(dref);
}

- (void)initizeNative:(CFSocketNativeHandle)native_socket showRecData:(NSTextField *)targer_text_field{
    tx_recv = targer_text_field;
    CFSocketContext sctx = {0,(__bridge void *)(self),NULL,NULL,NULL};
    obj_client = CFSocketCreateWithNative(kCFAllocatorDefault, native_socket, kCFSocketReadCallBack, TCPClientCallBackHandler, &sctx);
    
}

- (char *)ReadData {
    char *data_buff;
    NSMutableString *buff_length = [[NSMutableString alloc]init];
    char buf[1];
    read(CFSocketGetNative(obj_client), &buf, 1);
    while ((int)*buf!= 4) {
        [buff_length appendFormat:@"%c", (char)(int)*buf];
        read(CFSocketGetNative(obj_client), &buf, 1);
    }
    
    int data_length = [[buff_length stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet]invertedSet]]intValue];
    data_buff = (char *)malloc(data_length *sizeof(char));
    ssize_t byte_read = 0;
    ssize_t byte_offset = 0;
    while (byte_offset < data_length) {
        byte_read = read(CFSocketGetNative(obj_client), data_buff+byte_offset, 50);
        byte_offset += byte_read;
    }
    return data_buff;
}

// socket 回调函数 ，函数格式克制socket创建函数里查看
void TCPClientCallBackHandler(CFSocketRef s, CFSocketCallBackType callbacktype, CFDataRef address, const void *data, void *info) {
    switch (callbacktype) {
        case kCFSocketConnectCallBack:
            if (data) {
                CFSocketInvalidate(s);
                CFRelease(s);
                CFRunLoopStop(CFRunLoopGetCurrent());
            } else {
                NSLog(@"client to server ");
            }
            break;
            
            case kCFSocketReadCallBack:
            {
                char buf[1];
                read(CFSocketGetNative(s), &buf, 1);
                if ((int)*buf == 2) {
                    ClientThread *obj_client_ptr = (__bridge ClientThread*)info;
                    char * recv_data = [obj_client_ptr ReadData];
                    NSLog(@"%s", recv_data);
                    
                    // 这里非常危险 在xcode9会报错 这是现实server返回的数据
                    [obj_client_ptr ->tx_recv setStringValue:[NSString stringWithUTF8String:recv_data]];
                    
                    free(recv_data);
                }
            }
            break;
        default:
            break;
    }
}


@end
