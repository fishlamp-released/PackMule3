//
//	FLWsdlDocument.h
//	PackMule
//
//	Created by Mike Fullerton on 8/23/09.
//	Copyright 2009 Greentongue Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//#import "FLCodeGeneratorWsdlFileReader.h"
#import "FLAbstractCodeDocument.h"

@interface FLWsdlDocument : FLAbstractCodeDocument {
	NSString* m_url;
}

- (IBAction) createCodeSchema:(id) sender;

- (void) openUrl:(NSString*) url;

@end
