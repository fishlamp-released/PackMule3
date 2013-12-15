//
//  FLDefaultFontLoggingViewController.h
//  PackMule
//
//  Created by Mike Fullerton on 6/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTextViewController.h"

#define FLDefaultFontDidChangeNotificationName @"FLDefaultFontDidChangeNotificationName"

@interface FLDefaultFontLoggingViewController : FLTextViewController {
@private
}
- (void) setToDefaultFont;

@end
