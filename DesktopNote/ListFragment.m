//
//  ListFragment.m
//  MicroDown
//
//  Created by Jingkai He on 05/07/2014.
//  Copyright (c) 2014 Jingkai He. All rights reserved.
//

#import "ListFragment.h"

static NSString *orderedListPattern = @"\\A[\\d+]\\.\\s+(.+)";
static NSString *unorderedListPattern = @"\\A[\\*-]\\s+(.+)";
static NSRegularExpression *orderedListRegex;
static NSRegularExpression *unorderedListRegex;

@implementation ListFragment

+ (void) initialize
{
    if (!orderedListRegex) {
        orderedListRegex = [[NSRegularExpression alloc]
                            initWithPattern:orderedListPattern
                            options:0
                            error:nil];
    }
    
    if (!unorderedListRegex) {
        unorderedListRegex = [[NSRegularExpression alloc]
                              initWithPattern:unorderedListPattern
                              options:0
                              error:nil];
    }
}

+ (BOOL)isListWithLine:(NSString *)line andDocument:(Document *)document
{
    NSRange range = NSMakeRange(0, [line length]);
    
    if ([[orderedListRegex matchesInString:line options:0 range:range] count] > 0) {
        return YES;
    }else if ([[unorderedListRegex matchesInString:line options:0 range:range] count] > 0 ) {
        return YES;
    }else{
        return NO;
    }
}

+(NSString *) getTagByText:(NSString *)text
{
    char firstChar = [text characterAtIndex:0];
    if (firstChar == '*' || firstChar == '-') {
        return @"ul";
    }else{
        return @"ol";
    }
}

+(NSString *) getListContentByText:(NSString *)text
{
    NSRange range = NSMakeRange(0, [text length]);
    
    char firstChar = [text characterAtIndex:0];
    if (firstChar == '*' || firstChar == '-') {
        NSArray *matches = [unorderedListRegex matchesInString:text options:0 range:range];
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        return [text substringWithRange:[match rangeAtIndex:1]];
    }else{
        NSArray *matches = [orderedListRegex matchesInString:text options:0 range:range];
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        return [text substringWithRange:[match rangeAtIndex:1]];
    }
}

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        self.list = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype) initWithDocument:(Document *)document andTag: (NSString*)tag
{
    self = [super initWithContent:@"" andDocument:document];
    
    if (self) {
        self.tag = tag;
    }
    
    return self;
}

- (void)addListItem: (TextFragment *) frag
{
    [self.list addObject:frag];
}

- (void)parse
{
    [self.document.elements addObject:self];
}

- (NSString *) toHTML
{
    NSMutableArray *arrayOfContent = [[NSMutableArray alloc] init];
    
    for (BaseFragment *frag in self.list ) {
        NSString *text = [frag toHTML];
        NSString *listItem = [NSString stringWithFormat:@"<li>%@</li>", text];
        
        [arrayOfContent addObject: listItem];
    }
    
    return [NSString stringWithFormat:@"<%@>%@</%@>",
            self.tag,
            [arrayOfContent componentsJoinedByString:@"\n"],
            self.tag];
}

@end
