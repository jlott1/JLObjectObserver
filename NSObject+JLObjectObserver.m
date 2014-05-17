/*
  NSObject+JLObjectObserver.m

Created by Jonathan Lott.
Copyright (c) 2014 A Lott Of Ideas. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

If you happen to meet one of the copyright holders in a bar you are obligated
to buy them one pint of beer.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#import "NSObject+JLObjectObserver.h"
#import <objc/runtime.h>

@implementation NSObject (JLObjectObserver)
- (NSMutableArray*)objectObservers
{
    NSMutableArray* _objectObservers = (NSMutableArray *)objc_getAssociatedObject(self, @"objectObservers");
    return _objectObservers;
}

- (void)setObjectObservers:(NSMutableArray*)objectObservers
{
    if(![self.objectObservers isEqual:objectObservers])
    {
        objc_setAssociatedObject(self, @"objectObservers", objectObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (void)addObserver:(JLObjectObserver*)observer
{
    if(!self.objectObservers)
    {
        [self setObjectObservers:[NSMutableArray array]];
    }
    
    [self.objectObservers addObject:observer];
}

- (JLObjectObserver*)addObserverWithKeyPaths:(NSArray*)keyPaths block:(JLObjectObserverBlock)block
{
    JLObjectObserver* observer = [JLObjectObserver observerWithObject:self keyPaths:keyPaths block:block];
    [self addObserver:observer];
    return observer;
}

- (void)removeObserverWithKeyPaths:(NSArray*)keyPaths
{
    NSMutableArray* objectsToRemove = [NSMutableArray arrayWithCapacity:1];
    for(NSString* keyPath in keyPaths)
    {
        for(JLObjectObserver* observer in self.objectObservers)
        {
            if(![objectsToRemove containsObject:observer] && [observer.keyPaths containsObject:keyPath])
            {
                [objectsToRemove addObject:observer];
            }
        }
    }
    
    if(objectsToRemove.count)
    {
        [self.objectObservers removeObjectsInArray:objectsToRemove];
    }
}

@end

