/* TiVoDefaults

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

#import <stdio.h>
#import "TiVoDefaults.h"
#import "SimpleDialog.h"

@implementation TiVoDefaults

-(id) init
{
    [super init];
    NSMutableDictionary *temp;
    defaults = [[NSUserDefaults standardUserDefaults] retain];
    temp = [[NSMutableDictionary alloc] init];
    [temp setObject:@"192.168.1.100" forKey:@"IP Address"];
    [temp setObject:[NSNumber numberWithInt: NO] forKey:@"Show Standby"];

    [defaults registerDefaults:temp];
    [temp release];

    NSString * path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"remote.xml"];
    @try {
// this crashes things?
//        dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        if ([dictionary count] == 0) {
            @throw @"Empty dictionary";
        }
    } @catch (id exc) {
        NSString *alertStr = [NSString stringWithFormat:@"Unable to parse file %@", path];
        [SimpleDialog showDialog:@"Parse Error":alertStr];
    }

    return self;
}

-(NSUserDefaults *) getDefaults
{
    return defaults;
}

-(NSString *) getIpAddr
{
    return [defaults stringForKey:@"IP Address"];
}

-(void) setIpAddr:(NSString *)addr
{
    if (addr != NULL && [addr compare:[self getIpAddr]]) {
        [defaults setObject:addr forKey:@"IP Address"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IP Address" object:self];
    }
}

-(BOOL) showStandby
{
    return [defaults boolForKey:@"Show Standby"];
}

-(void) setShowStandby:(BOOL)standby
{
    if ([self showStandby] != standby) {
        [defaults setObject:[NSNumber numberWithInt: standby] forKey:@"Show Standby"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Show Standby" object:self];
    }
}

-(NSDictionary *) getConnectionSettings:(NSString *)connection
{
    return [[dictionary objectForKey:@"connections"] objectForKey:connection];
}

-(NSDictionary *) getFunctionSettings:(NSString *)func
{
    return [[dictionary objectForKey:@"functions"] objectForKey:func];
}

-(NSDictionary *) getSectionSettings:(NSString *)section
{
    return [[dictionary objectForKey:@"sections"] objectForKey:section];
}

-(NSArray *) getPageSettings
{
    return [dictionary objectForKey:@"pages"];
}

-(void) synchronize
{
    [defaults synchronize];
}

static TiVoDefaults *sharedDefaults = NULL;

+ (TiVoDefaults *) sharedDefaults
{
    @synchronized(self) {
        if (sharedDefaults == NULL) {
            sharedDefaults = [[self alloc] init];
        }
        return sharedDefaults;
    }
}

@end