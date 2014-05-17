/*
  JLObjectObserver.m

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

#import "JLObjectObserver.h"


@implementation JLObjectObserver

+ (instancetype)observerWithObject:(NSObject*)obj
{
    return [[self alloc] initWithObject:obj];
}

+ (instancetype)observerWithObject:(NSObject*)object keyPaths:(NSArray*)keyPaths block:(JLObjectObserverBlock)block
{
    JLObjectObserver* observer = [[self alloc] initWithObject:object];
    
    [observer addObserverForKeyPaths:keyPaths withBlock:block];
    return observer;
}

- (id)initWithObject:(NSObject*)obj
{
    self = [super init];
    if(self)
    {
        self.object = obj;
    }
    return self;
}

- (void)addObserverForKeyPaths:(NSArray*)keyPaths withBlock:(JLObjectObserverBlock)block
{
    self.keyPaths = keyPaths;
    self.observerBlock = block;
    for(NSString* keyPath in _keyPaths)
    {
        //    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self.object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObserverForKeyPath:(NSString *)keyPath
{
    if([self.keyPaths containsObject:keyPath])
    {
        [self.object removeObserver:self forKeyPath:keyPath];
    }
}

- (void)removeAllObservers
{
    for(NSString* keyPath in _keyPaths)
    {
        [self.object removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([self.keyPaths containsObject:keyPath])
    {
        if(self.observerBlock)
        {
            self.observerBlock(self, keyPath, object, change, context);
        }
    }
}

- (void)dealloc
{
    [self removeAllObservers];
}

@end
