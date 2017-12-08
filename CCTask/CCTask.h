//
//  CCTask.h
//  CCTask
//
//  Created by Keys on 2017/12/8.
//  Copyright © 2017年 WUJIOS. All rights reserved.
//
/*
 作者：柚子哥
 github:https://github.com/iyouzige/
 qq:978254430
 email:topqicc@163.com
 */

/*
 用于线程等待。
 用法：
 CCTask * task = [CCTask taskWithName:@"name"];
 {
    ....耗时操作，如网络请求，数据库读写
     if(true){
         [task trySetResult:@(1)];
     }
     else{
         [task trySetError:error];
     }
 }
 [task waitUntilFinished];
 注意：注意主线程警告，耗时长的操作尽量不要放在主线程
 */

#import <Foundation/Foundation.h>

@interface CCTask : NSObject

/**
 初始化一个Task
 
 @param name task名
 @return Task
 */
+ (instancetype)taskWithName:(NSString *)name;

/**
 task名字
 */
@property (nonatomic, strong) NSString * name;

/**
 任务数量
 */
@property (nonatomic, assign) NSUInteger taskCount;

/**
 readOnly 已完成的任务数量
 */
@property (nonatomic, assign, readonly) NSUInteger completedTaskCount;

/**
 设置已完成数量+1
 */
- (BOOL)trySetCompleteOneTask;

/**
 是否已经完成或者失败
 */
@property (nonatomic, assign, getter=isCompleted) BOOL completed;

/**
 结果，可以存放异步线程里的值
 */
@property (nonatomic, strong, readonly) id result;

/**
 错误信息
 */
@property (nonatomic, strong, readonly) NSError * error;


/**
 设置结果，有同步锁
 
 @param result 结果
 @return BOOL
 */
- (BOOL)trySetResult:(id)result;

/**
 设置错误信息，有同步锁
 
 @param error 错误信息
 @return BOOL
 */
- (BOOL)trySetError:(NSError *)error;

/**
 等待当前线程，直至任务完成或失败
 */
- (void)waitUntilFinished;


@end
