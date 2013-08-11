//
//  FLPackMuleTool.h
//  PackMuleTool
//
//  Created by Mike Fullerton on 5/5/12.
//  Copyright (c) 2012 GreenTongue Software. All rights reserved.
//

#import "FLCommandLineTool.h"

@interface WhittleTool : FLCommandLineTool<FLCommandLineToolImplementation> {
@private
#if REFACTOR
    BOOL _recursive;
    BOOL _output;
    BOOL _continue;
    BOOL _openFailedFiles;
    BOOL _samples;
    
    NSString* _optionalPath;
    NSString* _filePath;
#endif    
}

+ (id) whittleTool;

@end
