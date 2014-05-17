/*
  JLObjectObserver.h

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

#import <Foundation/Foundation.h>

@class JLObjectObserver;

typedef void(^JLObjectObserverBlock)(JLObjectObserver* observer, NSString * keyPath, id object,NSDictionary* change, void* context);


@interface JLObjectObserver : NSObject
@property (nonatomic, copy) JLObjectObserverBlock observerBlock;
@property (nonatomic, copy) NSArray* keyPaths;
@property (nonatomic, strong) id object;

+ (instancetype)observerWithObject:(NSObject*)obj;
+ (instancetype)observerWithObject:(NSObject*)obj keyPaths:(NSArray*)keyPaths block:(JLObjectObserverBlock)block;
- (id)initWithObject:(NSObject*)obj;

@end
