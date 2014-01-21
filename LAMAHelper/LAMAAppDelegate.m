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
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.title = @"";
    self.statusItem.image = [NSImage imageNamed:@"lamahelper-logo"];
    self.statusItem.alternateImage = [NSImage imageNamed:@"lamahelper-logo-alt"];
    self.statusItem.highlightMode = YES;
    [self setupMenu];
}

- (void)setupMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Take screenshot" action:@selector(capture:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"About Lama" action:@selector(about:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Quit Lama" action:@selector(terminate:) keyEquivalent:@""];

    self.statusItem.menu = menu;
}

- (void)about:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/f/lama.app"]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/emre/lama"]];
}

- (void)capture:(id)sender
{
    NSTask *task = [[NSTask alloc] init];
    
    NSString *lamaPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"lama-path"];
    if (lamaPath == nil) {
        lamaPath = @"/usr/local/bin/lama";
    }
    [task setLaunchPath:lamaPath];

    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (string.length > 0) {
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
