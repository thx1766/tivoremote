/* ConnectionManager

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; version 2
   of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/
#import <Foundation/Foundation.h>
#import <netdb.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <stdlib.h>
#import <stdio.h>
#import "TiVoBeacon.h"
#if 1
#import "CFBonjour.h"
#endif
#import "SimpleDialog.h"

@implementation TiVoBeacon

static TiVoBeacon *instance = NULL;

+ (TiVoBeacon *) getInstance 
{
    @synchronized(self) {
        if (instance == NULL) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

- (id)init
{
    detected = [[NSMutableDictionary alloc] init];

#if 1
    CFBonjour *bonjour = [[CFBonjour alloc] init];
    [bonjour CFBonjourStartBrowsingForServices:@"_tivo-videos._tcp." inDomain:@""];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(bonjourClientAdded:)
               name:@"bonjourClientAdded"
             object:nil];
#endif
/*     
    NSNetService is not resolving my TiVo
*/

#if 0
    NSNetServiceBrowser *browser = [[NSNetServiceBrowser alloc] init];

    [browser setDelegate:self];
    // Passing in "" for the domain causes us to browse in the default browse domain,
    // which currently will always be "local".  The service type should be registered
    // with IANA, and it should be listed at <http://www.iana.org/assignments/port-numbers>.
    // At minimum, the service type should be registered at <http://www.dns-sd.org/ServiceTypes.html>
    [browser searchForServicesOfType:@"_tivo-videos._tcp." inDomain:@""];
#endif



    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:nil];
    return self;
}

- (NSDictionary *)getDetectedTiVos
{
    return detected;
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"resolved = %@", [sender hostName]);
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"did not resolve = %@", sender);
    NSLog(@"did not = %@", errorDict);
}

// This object is the delegate of its NSNetServiceBrowser object. We're only interested in services-related methods,
// so that's what we'll call.
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    NSLog(@"more? = %@", moreComing);
    [aNetServiceBrowser stop];
    [aNetService setDelegate:self];
    [aNetService resolveWithTimeout:0];
    NSLog(@"host = %@", [aNetService hostName]);
    NSLog(@"name = %@", [aNetService name]);
    NSLog(@"type = %@", [aNetService type]);
    NSLog(@"domain = %@", [aNetService domain]);
    NSLog(@"addresses = %d", [[aNetService addresses] count]);
    NSLog(@"obj = %@", aNetService);
    NSLog(@"data = %@", [aNetService TXTRecordData]);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
#if 0
    NSString *ipAddr = [[notification userInfo] objectForKey:@"resolvedIP"];
    [dict setObject:[[notification userInfo] objectForKey:@"serviceName"] forKey:@"TiVo Name"];
    [dict setObject:ipAddr forKey:@"IP Address"];
    @synchronized (detected) {
        if ([detected objectForKey:ipAddr] == NULL) {
            [detected setObject:dict forKey:ipAddr];
            [self performSelectorOnMainThread: @selector(newTiVo:) withObject: NULL waitUntilDone:NO];
        } else {
            [dict release];
            [ipAddr release];
        }
    }
#endif
}

- (void) run:(id) param
{
    NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
    struct sockaddr_in my_addr;
    struct sockaddr_in their_addr;
    char buf[512];
    int fd = socket (PF_INET, SOCK_DGRAM, 0);
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(2190);
    my_addr.sin_addr.s_addr = INADDR_ANY;
    memset(my_addr.sin_zero, '\0', sizeof my_addr.sin_zero);
    if (bind (fd, (struct sockaddr *) &my_addr, sizeof my_addr) == -1) {
        NSLog(@"Unable to bind listening socket!");
        return;
    }

    int numbytes;
    unsigned int addr_len = sizeof their_addr;
    while (true) {
        if ((numbytes = recvfrom(fd, buf, 512 - 1, 0, (struct sockaddr *) &their_addr, &addr_len)) == -1) {
            NSLog(@"Did not receive anything!");
            continue;
        }
        NSString *recvd = [[NSString alloc] initWithUTF8String: buf];
        NSArray *components = [recvd componentsSeparatedByString:@"\n"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        int i = 0;
        for (i = 0; i < [components count]; i++) {
            NSArray *toks = [[components objectAtIndex:i] componentsSeparatedByString:@"="];
NSLog(@"%@", toks);
            if ([toks count] < 2) {
                continue;
            }
            if ([[toks objectAtIndex:0] isEqualToString:@"machine"]) {
                [dict setObject:[toks objectAtIndex:1] forKey:@"TiVo Name"];
            } else {
                [dict setObject:[toks objectAtIndex:1] forKey:[toks objectAtIndex:0]];
            }
        }
        [components release];
        [recvd release];
        NSString *ipAddr = [[NSString alloc] initWithUTF8String: (const char *)inet_ntoa(their_addr.sin_addr)];
        [dict setObject:ipAddr forKey:@"IP Address"];
        @synchronized (detected) {
            if ([detected objectForKey:ipAddr] == NULL) {
                [detected setObject:dict forKey:ipAddr];
                [self performSelectorOnMainThread: @selector(newTiVo:) withObject: NULL waitUntilDone:NO];
            } else {
                NSMutableDictionary *existing = [detected objectForKey:ipAddr];
                [existing addEntriesFromDictionary:dict];
                [dict release];
                [ipAddr release];
            }
        }
    }
    [autoreleasepool release];
}

-(void) bonjourClientAdded:(NSNotification *) notification
{
    NSLog(@"obj = %@", [notification userInfo]);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *ipAddr = [[notification userInfo] objectForKey:@"resolvedIP"];
    [dict setObject:[[notification userInfo] objectForKey:@"serviceName"] forKey:@"TiVo Name"];
    [dict setObject:ipAddr forKey:@"IP Address"];
    @synchronized (detected) {
        if ([detected objectForKey:ipAddr] == NULL) {
            [detected setObject:dict forKey:ipAddr];
            [self performSelectorOnMainThread: @selector(newTiVo:) withObject: NULL waitUntilDone:NO];
        } else {
            [dict release];
            [ipAddr release];
        }
    }
}

-(void) newTiVo:(id) param
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Detected TiVo" object:self];
}

@end
