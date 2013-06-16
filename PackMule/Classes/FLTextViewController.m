//
//  FLTextViewController.m
//  PackMule
//
//  Created by Mike Fullerton on 6/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTextViewController.h"

@interface FLTextViewController ()

@end

@protocol FLFontResponder <NSObject>
@optional
- (void) fontDidChange:(NSFontManager*) fontManager;
@end

@implementation FLTextViewController

@synthesize textView = _textView;

+ (void) initialize {
    [[NSFontManager sharedFontManager] setAction:@selector(fontDidChange:)];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) fontDidChange:(id)sender {
    [_textView changeFont:sender];

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
        [_textView setFont:[NSFont fontWithName:[defaultFont objectForKey:@"name"] size:[[defaultFont objectForKey:@"size"] floatValue]]];
    }
    else {
        [_textView setFont:[NSFont fontWithName:@"Menlo Regular" size:10]];
    }
}

- (void) defaultFontChanged:(id) sender {

    [self setToDefaultFont];
}

- (void) awakeFromNib {
	[super awakeFromNib];
    FLAssertNotNil(_textView);

    _textView.delegate = self;
    [self setNextResponder:_textView.nextResponder];
    [_textView setNextResponder:self];
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
