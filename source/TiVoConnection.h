// TiVoConnection
/*

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
#import "ConnectionManager.h"

@class TiVoDefaults;

@interface TiVoConnection: NSObject <RemoteConnection>
{
	int            fd;
	TiVoDefaults  *defaults;
	NSString      *ipField;
	struct timeval lastCmdSent;
}

- (id)initWithName:(NSString *)connName;
- (void)sendCommand:(NSString *)functionKey;
- (void)batchSend:(NSArray *)functions;
- (void)close;

- (int)getSocket;
- (void)waitForResponse:(int) sockFD: (NSString *)expectedResponse;

@end
