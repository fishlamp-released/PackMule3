//
//  FLDefaultFontLoggingViewController.m
//  PackMule
//
//  Created by Mike Fullerton on 6/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLDefaultFontLoggingViewController.h"
#import "NSTextView+FLTextWrapping.h"

@protocol FLFontResponder <NSObject>
@optional
- (void) fontDidChange:(NSFontManager*) fontManager;
@end

@implementation FLDefaultFontLoggingViewController

+ (void) initialize {
    [[NSFontManager sharedFontManager] setAction:@selector(fontDidChange:)];
}

- (void) fontDidChange:(id)sender {
    [self.textView changeFont:sender];

    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
        [[sender selectedFont] fontName], @"name",
        [NSNumber numberWithFloat:[[sender selectedFont] pointSize]], @"size",
        nil]
        forKey:@"default-font"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:FLDefaultFontDidChangeNotificationName object:nil];
}

- (void) setToDefaultFont {

    NSDictionary* defaultFont = [[NSUserDefaults standardUserDefaults] objectForKey:@"default-font"];

    if(defaultFont) {
        [self.textView setFont:[NSFont fontWithName:[defaultFont objectForKey:@"name"] size:[[defaultFont objectForKey:@"size"] floatValue]]];
    }
    else {
        [self.textView setFont:[NSFont fontWithName:@"Menlo Regular" size:10]];
    }
}

- (void) defaultFontChanged:(id) sender {

    [self setToDefaultFont];
}

- (void) awakeFromNib {
    [super awakeFromNib];

    self.textView.drawsBackground = NO;
    self.textView.delegate = self;
    [self.textView setAlignment:NSLeftTextAlignment];
    [self.textView setRichText:YES];
    [self.textView setWrappingDisabled];

    [self.textView setTextContainerInset:NSMakeSize(10, 10)];
    [self.textView setEnabledTextCheckingTypes:NSTextCheckingTypeLink];

    [self setLinkAttributes];

    [self setNextResponder:self.textView.nextResponder];
    [self.textView setNextResponder:self];
    [self setToDefaultFont];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultFontChanged:) name:FLDefaultFontDidChangeNotificationName object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

#if FL_MRC
	[super dealloc];
#endif
}

@end
