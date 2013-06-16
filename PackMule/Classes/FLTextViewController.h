//
//  FLTextViewController.h
//  PackMule
//
//  Created by Mike Fullerton on 6/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLamp.h"

#define FLDefaultFontDidChangeNotificationName @"FLDefaultFontDidChangeNotificationName"

@interface FLTextViewController : NSViewController<NSTextViewDelegate> {
@private
    IBOutlet NSTextView* _textView;
}

@property (readonly, strong, nonatomic) NSTextView* textView;

@end
