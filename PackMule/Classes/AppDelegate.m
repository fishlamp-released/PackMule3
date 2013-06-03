//
//  AppDelegate.m
//  PackMule
//
//  Created by Mike Fullerton on 9/25/12.
//  Copyright (c) 2012 Mike Fullerton. All rights reserved.
//

#import "AppDelegate.h"

#import "NSFileManager+FLExtras.h"
#import "FLStringUtils.h"
#import "FLUnitTest.h"

#import "FLWsdlDocument.h"

@implementation AppDelegate

static AppDelegate* s_instance;

+ (AppDelegate*) instance {
	return s_instance;
}

- (id) init {
	if(self = [super init]) {
		s_instance = self;
	}
	
	return self;
}

- (void) generateWithFiles:(NSArray*) files {
	
    @try {
		
		for(NSString* file in files) {
		/*
			FLCodeGeneratorProject* project = [FLCodeGeneratorProject object];
			
			// TODO: add ui to specify this
			project.company = @"GreenTongue Software";
			project.project = @"FishLamp";
			project.destinationFolder = [file stringByDeletingLastPathComponent];

			// TODO: add support for URLs
			project.projectPath = [[file stringByDeletingPathExtension] stringByAppendingPathExtension:@"cgproj"];
			
			[[FLCodeGeneratorProjectManager instance] generateCode:project];
		*/
		}
		
//		[self finishedGenerating:nil output:nil];
	}
	@catch(NSException* ex) {
//		[self finishedGenerating:ex output:nil];
	}
	
}

- (void) generateCodeFromFile:(id) sender {
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];

	[openDlg setAllowsMultipleSelection:NO];

	// Enable the selection of files in the dialog.
	[openDlg setCanChooseFiles:YES];

	// Enable the selection of directories in the dialog.
	[openDlg setCanChooseDirectories:NO];

	// Display the dialog.	If the OK button was pressed,
	// process the files.
	if ( [openDlg runModal] == NSOKButton )
	{
		[self generateWithFiles:[openDlg URLs]];
	}
}

- (IBAction) runUnitTests:(id) sender {
#if TEST
//	  [[FLUnitTestManager instance] discoverTests];
//	  [[FLUnitTestManager instance] executeTests];
#endif
}

- (void) showAlertForError:(NSError*) error {

    NSAlert* alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Aw, the Mule kicked you."]
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat: error ? [error localizedDescription] : @""];
        
    [alert runModal];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	return NO;
}

- (IBAction) newCodeDocument:(id) sender
{
	NSError* err = nil;
	NSDocument* doc = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"FLCodeGeneratorDocument" error:&err];
	[[NSDocumentController sharedDocumentController] addDocument:doc];
	[doc makeWindowControllers];
	[doc showWindows];
}

- (IBAction) newWsdlDocument:(id) sender
{
	NSError* err = nil;
	NSDocument* doc = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"FLWsdlDocument" error:&err];
	[[NSDocumentController sharedDocumentController] addDocument:doc];
	[doc makeWindowControllers];
	[doc showWindows];
}

- (IBAction) downloadWsdl:(id) sender
{
//	[m_inputWindow setReleasedWhenClosed:NO];
//
//	m_label.stringValue = @"enter url";
//	m_text.stringValue = @"";
//
//	int result = [[NSApplication sharedApplication] runModalForWindow:m_inputWindow];
//	if(result == 1)
//	{
//		NSError* err = nil;
//		FLWsdlDocument* doc = (FLWsdlDocument*) [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"FLWsdlDocument" error:&err];
//        if(err)
//        {
//            FLThrowIfError(err);
//        }
//		
//		[[NSDocumentController sharedDocumentController] addDocument:doc];
//		[doc makeWindowControllers];
//		[doc showWindows];
//		
//		[doc openUrl:m_text.stringValue];
//	}
//	
//	[m_inputWindow close];
}

- (IBAction) ok:(id) sender
{
	[[NSApplication sharedApplication] stopModalWithCode:YES];
}

- (IBAction) cancel:(id) cancel
{
	[[NSApplication sharedApplication] stopModalWithCode:NO];
}

- (IBAction) parseFile:(id) sender {

//	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
//
//	[openDlg setAllowsMultipleSelection:NO];
//
//	// Enable the selection of files in the dialog.
//	[openDlg setCanChooseFiles:YES];
//
//	// Enable the selection of directories in the dialog.
//	[openDlg setCanChooseDirectories:NO];
//
//	// Display the dialog.	If the OK button was pressed,
//	// process the files.
//	if ( [openDlg runModal] == NSOKButton )
//	{
//		NSArray* urls = [openDlg URLs];
//        for(NSURL* url in urls) {
//            NSString* string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//            
//            FOCFileTokenizer* tokenizer = [FOCFileTokenizer stringTokenizer];
//            NSArray* tokens = [tokenizer parseString:string];
//            
//            FLLog([tokens description]);
//        
//        }
//	}

}


@end
