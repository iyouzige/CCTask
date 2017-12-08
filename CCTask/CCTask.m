//
//  CCTask.m
//  CCTask
//
//  Created by Keys on 2017/12/8.
//  Copyright © 2017年 WUJIOS. All rights reserved.
//

#import "CCTask.h"

@interface CCTask ()
{
    id _result;
    NSError * _error;
}

@property (nonatomic, strong) NSObject * lock;

@property (nonatomic, strong) NSCondition * condition;

@end

@implementation CCTask

+ (instancetype)taskWithName:(NSString *)name
{
    CCTask * task = [[self alloc] init];
    task.name = name;
    return task;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.lock = [[NSObject alloc] init];
        self.condition = [[NSCondition alloc] init];
    }
    return self;
}



- (void)runContinuations {
    @synchronized(self.lock) {
        [self.condition lock];
        [self.condition broadcast];
        [self.condition unlock];
    }
}

#pragma mark - Method
- (BOOL)trySetResult:(id)result
{
    @synchronized(self.lock) {
        if (self.completed) {
            return NO;
        }
        self.completed = YES;
        _result = result;
        [self runContinuations];
        return YES;
    }
}
- (BOOL)trySetError:(NSError *)error {
    @synchronized(self.lock) {
        if (self.completed) {
            return NO;
        }
        self.completed = YES;
        _error = error;
        [self runContinuations];
        return YES;
    }
}
- (BOOL)trySetCompleteOneTask
{
    @synchronized (self.lock) {
        if (self.completed)
        {
            return NO;
        }
        if (self.taskCount == 0)
        {
            return NO;
        }
        if (_completedTaskCount < self.taskCount)
        {
            _completedTaskCount ++;
        }
        if (_completedTaskCount >= self.taskCount)
        {
            self.completed = YES;
            [self runContinuations];
            return YES;
        }
        return NO;
    }
}

- (void)warnOperationOnMainThread
{
    NSString * message = [NSString stringWithFormat:@"⚠️⚠️ Main thread is busy (╯>д<)╯⁽˙³˙⁾ <%@>", self.name ?: @"无名氏"];
    NSLog(@"%@", message);
}

- (void)waitUntilFinished
{
    if ([NSThread isMainThread]) {
        [self warnOperationOnMainThread];
    }
    
    @synchronized(self.lock) {
        if (self.completed) {
            return;
        }
        [self.condition lock];
    }
    while (!self.completed) {
        [self.condition wait];
    }
    [self.condition unlock];
}

#pragma mark - getter
- (BOOL)isCompleted {
    @synchronized(self.lock) {
        return _completed;
    }
}
- (NSError *)error
{
    @synchronized (self.lock) {
        return _error;
    }
}
- (NSUInteger)taskCount
{
    @synchronized (self.lock)
    {
        return _taskCount;
    }
}

@end
