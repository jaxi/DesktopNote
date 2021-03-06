//
//  NoteController.h
//  DesktopNote
//
//  Created by Jingkai He on 24/06/2014.
//  Copyright (c) 2014 Jingkai He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <Quartz/Quartz.h>
#import "Note.h"
#import "Parser.h"
#import "NSMutableArray+EventStack.h"

@interface NoteController : NSObject <NSTableViewDelegate, NSTextViewDelegate>

@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet WebView *webView;

@property (nonatomic, strong) IBOutlet NSTextView *contentField;

@property (nonatomic, weak) IBOutlet NSButton *saveButton;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSMutableArray *notes;
@property (nonatomic, strong) Note *selectedNote;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *renderingStack;

@property (nonatomic, strong) dispatch_queue_t renderingQueue;

@end
