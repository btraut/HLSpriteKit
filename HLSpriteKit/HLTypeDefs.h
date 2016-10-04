//
//  HLTypeDefs.h
//  HLSpriteKit
//
//  Created by Brent Traut on 10/3/16.
//  Copyright © 2016 Hilo Games. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
typedef UIGestureRecognizer HLGestureRecognizer;

#else

#import <Cocoa/Cocoa.h>
typedef NSGestureRecognizer HLGestureRecognizer;

#endif
