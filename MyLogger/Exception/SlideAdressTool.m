//
//  SlideAdressTool.m
//  LogManager
//
//  Created by 王娜 on 2018/1/31.
//  Copyright © 2018年 王娜. All rights reserved.
//

#import "SlideAdressTool.h"
#import <mach-o/dyld.h>

@implementation SlideAdressTool


//MARK: - 获取偏移量地址
/* 通过获取到偏移量地址Slide,Address和错误信息的内存地址基本即可定位错误，错误信息的内存地址在捕获的crash信息中会体现，Slide
Address则需要我们自己获取，通过调用如下C方法我们可以获取到偏移量地址，这里通过swift文件来调用C方法。*/
long  calculate(void){
    long slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return slide;
}

+ (void)redirectLogToDocumentFolder
{
    // 获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    // 获取打印输出文件路径
    NSString *fileName = [NSString stringWithFormat:@"myData.txt"];
    NSLog(@"%@",paths);
    NSLog(@"能不能输出到控制台");
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    // 将NSLog的输出重定向到文件，因为C语言的printf打印是往stdout打印的，这里也把它重定向到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
    NSLog(@"能不能输出到控制台呢");
}

@end
