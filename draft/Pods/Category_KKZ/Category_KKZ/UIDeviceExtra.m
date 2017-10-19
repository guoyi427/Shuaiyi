//
//  UIDeviceExtra.m
//  phonebook
//
//  Created by zhang da on 11-1-24.
//  Copyright 2011 alfaromeo.dev. All rights reserved.
//

#import "UIDeviceExtra.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIDevice(Hardware)

- (NSString *)platform {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = (char *)malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (BOOL)hasRetinaDisplay {
    NSString *platform = [self platform];
    BOOL ret = YES;
    if ([platform isEqualToString:@"iPhone1,1"]) {
        ret = NO;
    }
    else if ([platform isEqualToString:@"iPhone1,2"]) {
        ret = NO;
    }    
    else if ([platform isEqualToString:@"iPhone2,1"]) {
        ret = NO;
    }    
    else if ([platform isEqualToString:@"iPod1,1"]) {
        ret = NO; 
    }     
    else if ([platform isEqualToString:@"iPod2,1"]) {
        ret = NO;
    }     
    else if ([platform isEqualToString:@"iPod3,1"]) {
        ret = NO;
    }
    else if ([platform isEqualToString:@"i386"]) {
        ret = NO;
    }
    
    return ret;
}

- (BOOL)hasMultitasking {
    if ([self respondsToSelector:@selector(isMultitaskingSupported)]) {
        return [self isMultitaskingSupported];
    }
    return NO;
}

- (BOOL)hasCamera {
    BOOL ret = NO;
    // check camera availability
    return ret;
}

- (BOOL)under3gs {
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])
        return YES;
    if ([platform isEqualToString:@"iPhone1,2"])
        return YES;
    if ([platform isEqualToString:@"iPod1,1"])
        return YES;
    if ([platform isEqualToString:@"iPod2,1"])
        return YES;
    return NO;
}

- (NSString *)platformString {
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])
        return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])
        return @"iPad";
    if ([platform isEqualToString:@"i386"])
        return @"Simulator";
    return platform;
}

- (BOOL)isIpad {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}

- (NSString *)MACAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char *)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring? outstring: @"unknown";
}

- (NSString *)IPAddress
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://www.whatismyip.com/automation/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
    return ip ? ip : [error localizedDescription];
}

@end
