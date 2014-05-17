JLObjectObserver
================

A generic class plus category for easily handling key-value-observing with the help of blocks

Background
---
This work was done to make it easier to handle KVO patterns with the help of blocks and a observer object.
Using an observer object is nicer because it can self-maintain its own construction/destruction and will stop observing on dealloc.  This makes it simple to "bind" two object properties together.


Features
--------

The NSObject+JLObjectObserver Category Provides methods

    - (JLObjectObserver*)addObserverWithKeyPaths:(NSArray*)keyPaths block:(JLObjectObserverBlock)block;

and 

    - (void)removeObserverWithKeyPaths:(NSArray*)keyPaths;


NOTE: `addObserverWithKeyPaths:block` method returns an instance of JLObjectObserver, you can optionally keep a reference to it. The NSObject category automatically maintains an NSMutableArray of all objectObservers so it is not necessary to retain the object yourself.  

Also note that because of this use of NSMutableArray,  it is NOT THREAD SAFE.  use at your own discretion when using with multiple threads.


Usage
-----

Add the files into your project.

Exmaple:
``` objc

#import "NSObject+JLObjectObserver.h"

@interface MyCollectionViewController : UIViewController
@property (nonatomic, strong) UICollectionView* collectionView1;
@property (nonatomic, strong) UICollectionView* collectionView2;

@end

@implementation JALeftViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
        __weak MyCollectionViewController* weakSelf = self;

    //call remove observer to ensure that you do not add multiple observers for the same property
    [self.collectionView1 removeObserverWithKeyPaths:@[@"contentOffset"]];
    [self.collectionView2 removeObserverWithKeyPaths:@[@"contentOffset"]];
    
    //add a observer for contentOffset on collectionView 1
    [self.collectionView1 addObserverWithKeyPaths:@[@"contentOffset"] block:^(JLObjectObserver* observer, NSString *keyPath, id object, NSDictionary *change, void *context) {
        if([keyPath isEqualToString:@"contentOffset"])
        {
            CGPoint newValue = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
            
            //check for equality to prevent infinite update loop
          	if(!CGPointEqualToPoint(weakSelf.collectionView2.contentOffset, newValue))
            {
            	// set contentOffset for collectionView 2
                weakSelf.collectionView2.contentOffset = newValue;
            }
        }
    }];
    
    //add a observer for contentOffset on collectionView 2
    [self.collectionView2 addObserverWithKeyPaths:@[@"contentOffset"] block:^(JLObjectObserver* observer, NSString *keyPath, id object, NSDictionary *change, void *context) {
        if([keyPath isEqualToString:@"contentOffset"])
        {
            CGPoint newValue = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
            
            //check for equality to prevent infinite update loop
          	if(!CGPointEqualToPoint(weakSelf.collectionView1.contentOffset, newValue))
            {
            	// set contentOffset for collectionView 1
                weakSelf.collectionView1.contentOffset = newValue;
            }
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	// remove observers
    [self.collectionView1 removeObserverWithKeyPaths:@[@"contentOffset"]];
    [self.collectionView2 removeObserverWithKeyPaths:@[@"contentOffset"]];
}
@end

```

Requirements
------------

XCode 4.2 or later and iOS 4 or later as the module uses automatic reference counting. 



License
---

```
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
 
 
 ```