//
//  LAMAAppDelegate.m
//  LAMAHelper
//
//  Created by Fatih Kadir Akin.
//  There is no copyright.
//

#import "LAMAAppDelegate.h"

@interface LAMAAppDelegate ()

@end

@implementation LAMAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [self setupStatusItem];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (void)setupStatusItem
{
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"";
    _statusItem.image = [NSImage imageNamed:@"lamahelper-logo"];
    _statusItem.alternateImage = [NSImage imageNamed:@"lamahelper-logo-alt"];
    _statusItem.highlightMode = YES;
    [self setupMenu];
}

- (void)setupMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Take screenshot" action:@selector(capture:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Quit Lama Helper" action:@selector(terminate:) keyEquivalent:@""];
    self.statusItem.menu = menu;
}

- (void)capture:(id)sender
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/local/bin/lama"];

    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    if (string.length) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"Screenshot URL Copied!";
        notification.informativeText = string;
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}

- (void)terminate:(id)sender
{
    [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

@end
