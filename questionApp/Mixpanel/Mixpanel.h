#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class    MixpanelPeople;
@protocol MixpanelDelegate;

/*!
 @class
 Mixpanel API.

 @abstract
 The primary interface for integrating Mixpanel with your app.

 @discussion
 Use the Mixpanel class to set up your project and track events in Mixpanel
 Engagement. It now also includes a <code>people</code> property for accesseing
 the Mixpanel People API.

 <pre>
 // Initialize the API
 Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:@"YOUR API TOKEN"];

 // Track an event in Mixpanel Engagement
 [mixpanel track:@"Button Clicked"];

 // Set properties on a user in Mixpanel People
 [mixpanel.people identify:@"CURRENT USER DISTINCT ID"];
 [mixpanel.people set:@"Plan" to:@"Premium"];
 </pre>

 For more advanced usage, please see the <a
 href="https://mixpanel.com/docs/integration-libraries/iphone">Mixpanel iPhone
 Library Guide</a>.
 */
@interface Mixpanel : NSObject

#pragma mark Properties

/*!
 @property

 @abstract
 Accessor to the Mixpanel People API object.

 @discussion
 See the documentation for MixpanelDelegate below for more information.
 */
@property (atomic, readonly, strong) MixpanelPeople *people;

/*!
 @property

 @abstract
 The distinct ID of the current user.

 @discussion
 A distinct ID is a string that uniquely identifies one of your users.
 Typically, this is the user ID from your database. By default, we'll use a
 hash of the MAC address of the device. To change the current distinct ID,
 use the <code>identify:</code> method.
 */
@property (atomic, readonly, copy) NSString *distinctId;

/*!
 @property

 @abstract
 Current user's name in Mixpanel Streams.
 */
@property (atomic, copy) NSString *nameTag;

/*!
 @property

 @abstract
 The base URL used for Mixpanel API requests.

 @discussion
 Useful if you need to proxy Mixpanel requests. Defaults to
 https://api.mixpanel.com.
 */
@property (atomic, copy) NSString *serverURL;

/*!
 @property

 @abstract
 Flush timer's interval.

 @discussion
 Setting a flush interval of 0 will turn off the flush timer.
 */
@property (atomic) NSUInteger flushInterval;

/*!
 @property

 @abstract
 Control whether the library should flush data to Mixpanel when the app
 enters the background.

 @discussion
 Defaults to YES. Only affects apps targeted at iOS 4.0, when background
 task support was introduced, and later.
 */
@property (atomic) BOOL flushOnBackground;

/*!
 @property

 @abstract
 Controls whether to show spinning network activity indicator when flushing
 data to the Mixpanel servers.

 @discussion
 Defaults to YES.
 */
@property (atomic) BOOL showNetworkActivityIndicator;

/*!
 @property

 @abstract
 Controls whether to automatically check for surveys for the
 currently identified user when the application becomes active.

 @discussion
 Defaults to YES. Will fire a network request on
 <code>applicationDidBecomeActive</code> to retrieve a list of valid suerveys
 for the currently identified user.
 */
@property (atomic) BOOL checkForSurveysOnActive;

/*!
 @property

 @abstract
 Controls whether to automatically show a survey for the
 currently identified user when the application becomes active.

 @discussion
 Defaults to YES. This will only show a survey if
 <code>checkForSurveysOnActive</code> is also set to YES, and the
 survey check retrieves at least 1 valid survey for the currently
 identified user.
 */
@property (atomic) BOOL showSurveyOnActive;

/*!
 @property

 @abstract
 Controls whether to automatically check for notifications for the
 currently identified user when the application becomes active.

 @discussion
 Defaults to YES. Will fire a network request on
 <code>applicationDidBecomeActive</code> to retrieve a list of valid notifications
 for the currently identified user.
 */
@property (atomic) BOOL checkForNotificationsOnActive;

/*!
 @property

 @abstract
 Controls whether to automatically check for A/B test variants for the
 currently identified user when the application becomes active.

 @discussion
 Defaults to YES. Will fire a network request on
 <code>applicationDidBecomeActive</code> to retrieve a list of valid variants
 for the currently identified user.
 */
@property (atomic) BOOL checkForVariantsOnActive;

/*!
 @property

 @abstract
 Controls whether to automatically check for and show in-app notifications
 for the currently identified user when the application becomes active.

 @discussion
 Defaults to YES.
 */
@property (atomic) BOOL showNotificationOnActive;

/*!
 @property

 @abstract
 Determines the time, in seconds, that a mini notification will remain on
 the screen before automatically hiding itself.

 @discussion
 Defaults to 6.0.
 */
@property (atomic) CGFloat miniNotificationPresentationTime;

/*!
 @property

 @abstract
 The a MixpanelDelegate object that can be used to assert fine-grain control
 over Mixpanel network activity.

 @discussion
 Using a delegate is optional. See the documentation for MixpanelDelegate
 below for more information.
 */
@property (atomic, weak) id<MixpanelDelegate> delegate; // allows fine grain control over uploading (optional)

#pragma mark Tracking

/*!
 @method

 @abstract
 Initializes and returns a singleton instance of the API.

 @discussion
 If you are only going to send data to a single Mixpanel project from your app,
 as is the common case, then this is the easiest way to use the API. This
 method will set up a singleton instance of the <code>Mixpanel</code> class for
 you using the given project token. When you want to make calls to Mixpanel
 elsewhere in your code, you can use <code>sharedInstance</code>.

 <pre>
 [Mixpanel sharedInstance] track:@"Something Happened"]];
 </pre>

 If you are going to use this singleton approach,
 <code>sharedInstanceWithToken:</code> <b>must be the first call</b> to the
 <code>Mixpanel</code> class, since it performs important initializations to
 the API.

 @param apiToken        your project token
 */
+ (Mixpanel *)sharedInstanceWithToken:(NSString *)apiToken;

/*!
 @method

 @abstract
 Initializes a singleton instance of the API, uses it to track launchOptions information,
 and then returns it.

 @discussion
 This is the preferred method for creating a sharedInstance with a mixpanel
 like above. With the launchOptions parameter, Mixpanel can track referral
 information created by push notifications.

 @param apiToken        your project token
 @param launchOptions   your application delegate's launchOptions

 */
+ (Mixpanel *)sharedInstanceWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions;

/*!
 @method

 @abstract
 Returns the previously instantiated singleton instance of the API.

 @discussion
 The API must be initialized with <code>sharedInstanceWithToken:</code> before
 calling this class method.
 */
+ (Mixpanel *)sharedInstance;

/*!
 @method

 @abstract
 Initializes an instance of the API with the given project token.

 @discussion
 Returns the a new API object. This allows you to create more than one instance
 of the API object, which is convenient if you'd like to send data to more than
 one Mixpanel project from a single app. If you only need to send data to one
 project, consider using <code>sharedInstanceWithToken:</code>.

 @param apiToken        your project token
 @param launchOptions   optional app delegate launchOptions
 @param flushInterval   interval to run background flushing
 */
- (instancetype)initWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions andFlushInterval:(NSUInteger)flushInterval;

/*!
 @method

 @abstract
 Initializes an instance of the API with the given project token.

 @discussion
 Supports for the old initWithToken method format but really just passes
 launchOptions to the above method as nil.

 @param apiToken        your project token
 @param flushInterval   interval to run background flushing
 */
- (instancetype)initWithToken:(NSString *)apiToken andFlushInterval:(NSUInteger)flushInterval;

/*!
 @property

 @abstract
 Sets the distinct ID of the current user.

 @discussion
 As of version 2.3.1, Mixpanel will choose a default distinct ID based on
 whether you are using the AdSupport.framework or not.

 If you are not using the AdSupport Framework (iAds), then we use the
 <code>[UIDevice currentDevice].identifierForVendor</code> (IFV) string as the
 default distinct ID.  This ID will identify a user across all apps by the same
 vendor, but cannot be used to link the same user across apps from different
 vendors.

 If you are showing iAds in your application, you are allowed use the iOS ID
 for Advertising (IFA) to identify users. If you have this framework in your
 app, Mixpanel will use the IFA as the default distinct ID. If you have
 AdSupport installed but still don't want to use the IFA, you can define the
 <code>MIXPANEL_NO_IFA</code> preprocessor flag in your build settings, and
 Mixpanel will use the IFV as the default distinct ID.

 If we are unable to get an IFA or IFV, we will fall back to generating a
 random persistent UUID.

 For tracking events, you do not need to call <code>identify:</code> if you
 want to use the default.  However, <b>Mixpanel People always requires an
 explicit call to <code>identify:</code></b>. If calls are made to
 <code>set:</code>, <code>increment</code> or other <code>MixpanelPeople</code>
 methods prior to calling <code>identify:</code>, then they are queued up and
 flushed once <code>identify:</code> is called.

 If you'd like to use the default distinct ID for Mixpanel People as well
 (recommended), call <code>identify:</code> using the current distinct ID:
 <code>[mixpanel identify:mixpanel.distinctId]</code>.

 @param distinctId string that uniquely identifies the current user
 */
- (void)identify:(NSString *)distinctId;

/*!
 @method

 @abstract
 Tracks an event.

 @param event           event name
 */
- (void)track:(NSString *)event;

/*!
 @method

 @abstract
 Tracks an event with properties.

 @discussion
 Properties will allow you to segment your events in your Mixpanel reports.
 Property keys must be <code>NSString</code> objects and values must be
 <code>NSString</code>, <code>NSNumber</code>, <code>NSNull</code>,
 <code>NSArray</code>, <code>NSDictionary</code>, <code>NSDate</code> or
 <code>NSURL</code> objects. If the event is being timed, the timer will
 stop and be added as a property.

 @param event           event name
 @param properties      properties dictionary
 */
- (void)track:(NSString *)event properties:(NSDictionary *)properties;


/*!
 @method

 @abstract
 Track a push notification using its payload sent from Mixpanel.

 @discussion
 To simplify user interaction tracking and a/b testing, Mixpanel
 automatically sends IDs for the relevant notification and a/b variants
 of each push. This method parses the standard payload and queues a
 track call using this information.

 @param userInfo         remote notification payload dictionary
 */
- (void)trackPushNotification:(NSDictionary *)userInfo;


/*!
 @method

 @abstract
 Registers super properties, overwriting ones that have already been set.

 @discussion
 Super properties, once registered, are automatically sent as properties for
 all event tracking calls. They save you having to maintain and add a common
 set of properties to your events. Property keys must be <code>NSString</code>
 objects and values must be <code>NSString</code>, <code>NSNumber</code>,
 <code>NSNull</code>, <code>NSArray</code>, <code>NSDictionary</code>,
 <code>NSDate</code> or <code>NSURL</code> objects.

 @param properties      properties dictionary
 */
- (void)registerSuperProperties:(NSDictionary *)properties;

/*!
 @method

 @abstract
 Registers super properties without overwriting ones that have already been
 set.

 @discussion
 Property keys must be <code>NSString</code> objects and values must be
 <code>NSString</code>, <code>NSNumber</code>, <code>NSNull</code>,
 <code>NSArray</code>, <code>NSDictionary</code>, <code>NSDate</code> or
 <code>NSURL</code> objects.

 @param properties      properties dictionary
 */
- (void)registerSuperPropertiesOnce:(NSDictionary *)properties;

/*!
 @method

 @abstract
 Registers super properties without overwriting ones that have already been set
 unless the existing value is equal to defaultValue.

 @discussion
 Property keys must be <code>NSString</code> objects and values must be
 <code>NSString</code>, <code>NSNumber</code>, <code>NSNull</code>,
 <code>NSArray</code>, <code>NSDictionary</code>, <code>NSDate</code> or
 <code>NSURL</code> objects.

 @param properties      properties dictionary
 @param defaultValue    overwrite existing properties that have this value
 */
- (void)registerSuperPropertiesOnce:(NSDictionary *)properties defaultValue:(id)defaultValue;

/*!
 @method

 @abstract
 Removes a previously registered super property.

 @discussion
 As an alternative to clearing all properties, unregistering specific super
 properties prevents them from being recorded on future events. This operation
 does not affect the value of other super properties. Any property name that is
 not registered is ignored.

 Note that after removing a super property, events will show the attribute as
 having the value <code>undefined</code> in Mixpanel until a new value is
 registered.

 @param propertyName   array of property name strings to remove
 */
- (void)unregisterSuperProperty:(NSString *)propertyName;

/*!
 @method

 @abstract
 Clears all currently set super properties.
 */
- (void)clearSuperProperties;

/*!
 @method

 @abstract
 Returns the currently set super properties.
 */
- (NSDictionary *)currentSuperProperties;

/*!
 @method

 @abstract
 Starts a timer that will be stopped and added as a property when a
 corresponding event is tracked.

 @discussion
 This method is intended to be used in advance of events that have
 a duration. For example, if a developer were to track an "Image Upload" event
 she might want to also know how long the upload took. Calling this method
 before the upload code would implicitly cause the <code>track</code>
 call to record its duration.

 <pre>
 // begin timing the image upload
 [mixpanel timeEvent:@"Image Upload"];

 // upload the image
 [self uploadImageWithSuccessHandler:^{

    // track the event
    [mixpanel track:@"Image Upload"];
 }];
 </pre>

 @param event   a string, identical to the name of the event that will be tracked

 */
- (void)timeEvent:(NSString *)event;

/*!
 @method

 @abstract
 Clears all current event timers.
 */
- (void)clearTimedEvents;

/*!
 @method

 @abstract
 Clears all stored properties and distinct IDs. Useful if your app's user logs out.
 */
- (void)reset;

/*!
 @method

 @abstract
 Uploads queued data to the Mixpanel server.

 @discussion
 By default, queued data is flushed to the Mixpanel servers every minute (the
 default for <code>flushInvterval</code>), and on background (since
 <code>flushOnBackground</code> is on by default). You only need to call this
 method manually if you want to force a flush at a particular moment.
 */
- (void)flush;

/*!
 @method
 
 @abstract
 Calls flush, then optionally archives and calls a handler when finished.
 
 @discussion
 When calling <code>flush</code> manually, it is sometimes important to verify
 that the flush has finished before before further action is taken. This is
 especially important when the app is in the background and could be suspended
 at any time if protocol is not followed. Delegate methods like
 <code>application:didReceiveRemoteNotification:fetchCompletionHandler:</code>
 are called when an app is brought to the background and require a handler to
 be called when it finishes.
 */
- (void)flushWithCompletion:(void (^)())handler;

/*!
 @method

 @abstract
 Writes current project info, including distinct ID, super properties and pending event
 and People record queues to disk.

 @discussion
 This state will be recovered when the app is launched again if the Mixpanel
 library is initialized with the same project token. <b>You do not need to call
 this method</b>. The library listens for app state changes and handles
 persisting data as needed. It can be useful in some special circumstances,
 though, for example, if you'd like to track app crashes from main.m.
 */
- (void)archive;

/*!
 @method

 @abstract
 Creates a distinct_id alias from alias to original id.

 @discussion
 This method is used to map an identifer called an alias to the existing Mixpanel
 distinct id. This causes all events and people requests sent with the alias to be
 mapped back to the original distinct id. The recommended usage pattern is to call
 both createAlias: and identify: when the user signs up, and only identify: (with
 their new user ID) when they log in. This will keep your signup funnels working
 correctly.

 <pre>
 // This makes the current ID (an auto-generated GUID)
 // and 'Alias' interchangeable distinct ids.
 [mixpanel createAlias:@"Alias"
    forDistinctID:mixpanel.distinctId];

 // You must call identify if you haven't already
 // (e.g., when your app launches).
 [mixpanel identify:mixpanel.distinctId];
</pre>

@param alias 		the new distinct_id that should represent original
@param distinctID 	the old distinct_id that alias will be mapped to
 */
- (void)createAlias:(NSString *)alias forDistinctID:(NSString *)distinctID;

- (NSString *)libVersion;


#if !defined(MIXPANEL_APP_EXTENSION)
#pragma mark - Mixpanel Surveys

/*!
 @method

 @abstract
 Shows the survey with the given name.

 @discussion
 This method allows you to explicitly show a named survey at the time of your choosing.

 */
- (void)showSurveyWithID:(NSUInteger)ID;

/*!
 @method

 @abstract
 Show a survey if one is available.

 @discussion
 This method allows you to display the first available survey targeted to the currently
 identified user at the time of your choosing. You would typically pair this with
 setting <code>showSurveyOnActive = NO;</code> so that the survey won't show automatically.

 */
- (void)showSurvey;

#pragma mark - Mixpanel Notifications

/*!
 @method

 @abstract
 Shows the notification of the given id.

 @discussion
 You do not need to call this method on the main thread.
 */
- (void)showNotificationWithID:(NSUInteger)ID;


/*!
 @method

 @abstract
 Shows a notification with the given type if one is available.

 @discussion
 You do not need to call this method on the main thread.

 @param type The type of notification to show, either @"mini", or @"takeover"
 */
- (void)showNotificationWithType:(NSString *)type;

/*!
 @method

 @abstract
 Shows a notification if one is available.

 @discussion
 You do not need to call this method on the main thread.
 */
- (void)showNotification;

#pragma mark - Mixpanel A/B Testing

/*!
 @method

 @abstract
 Join any experiments (A/B tests) that are available for the current user.

 @discussion
 Mixpanel will check for A/B tests automatically when your app enters
 the foreground. Call this method if you would like to to check for,
 and join, any experiments are newly available for the current user.

 You do not need to call this method on the main thread.
 */
- (void)joinExperiments;

/*!
 @method

 @abstract
 Join any experiments (A/B tests) that are available for the current user.

 @discussion
 Same as joinExperiments but will fire the given callback after all experiments
 have been loaded and applied.
 */
- (void)joinExperimentsWithCallback:(void(^)())experimentsLoadedCallback;

#endif

@end

/*!
 @class
 Mixpanel People API.

 @abstract
 Access to the Mixpanel People API, available as a property on the main
 Mixpanel API.

 @discussion
 <b>You should not instantiate this object yourself.</b> An instance of it will
 be available as a property of the main Mixpanel object. Calls to Mixpanel
 People methods will look like this:

 <pre>
 [mixpanel.people increment:@"App Opens" by:1];
 </pre>

 Please note that the core <code>Mixpanel</code> and
 <code>MixpanelPeople</code> classes share the <code>identify:</code> method.
 The <code>Mixpanel</code> <code>identify:</code> affects the
 <code>distinct_id</code> property of events sent by <code>track:</code> and
 <code>track:properties:</code> and determines which Mixpanel People user
 record will be updated by <code>set:</code>, <code>increment:</code> and other
 <code>MixpanelPeople</code> methods.

 <b>If you are going to set your own distinct IDs for core Mixpanel event
 tracking, make sure to use the same distinct IDs when using Mixpanel
 People</b>.
 */
@interface MixpanelPeople : NSObject

/*!
 @method

 @abstract
 Register the given device to receive push notifications.

 @discussion
 This will associate the device token with the current user in Mixpanel People,
 which will allow you to send push notifications to the user from the Mixpanel
 People web interface. You should call this method with the <code>NSData</code>
 token passed to
 <code>application:didRegisterForRemoteNotificationsWithDeviceToken:</code>.

 @param deviceToken     device token as returned <code>application:didRegisterForRemoteNotificationsWithDeviceToken:</code>
 */
- (void)addPushDeviceToken:(NSData *)deviceToken;

/*!
 @method

 @abstract
 Set properties on the current user in Mixpanel People.

 @discussion
 The properties will be set on the current user. The keys must be NSString
 objects and the values should be NSString, NSNumber, NSArray, NSDate, or
 NSNull objects. We use an NSAssert to enforce this type requirement. In
 release mode, the assert is stripped out and we will silently convert
 incorrect types to strings using [NSString stringWithFormat:@"%@", value]. You
 can override the default the current project token and distinct ID by
 including the special properties: $token and $distinct_id. If the existing
 user record on the server already has a value for a given property, the old
 value is overwritten. Other existing properties will not be affected.

 <pre>
 // applies to both Mixpanel Engagement track: AND Mixpanel People set: and
 // increment: calls
 [mixpanel identify:distinctId];

 // applies ONLY to Mixpanel People set: and increment: calls
 [mixpanel.people identify:distinctId];
 </pre>

 @param properties       properties dictionary

 */
- (void)set:(NSDictionary *)properties;

/*!
 @method

 @abstract
 Convenience method for setting a single property in Mixpanel People.

 @discussion
 Property keys must be <code>NSString</code> objects and values must be
 <code>NSString</code>, <code>NSNumber</code>, <code>NSNull</code>,
 <code>NSArray</code>, <code>NSDictionary</code>, <code>NSDate</code> or
 <code>NSURL</code> objects.

 @param property        property name
 @param object          property value
 */
- (void)set:(NSString *)property to:(id)object;

/*!
 @method

 @abstract
 Set properties on the current user in Mixpanel People, but don't overwrite if
 there is an existing value.

 @discussion
 This method is identical to <code>set:</code> except it will only set
 properties that are not already set. It is particularly useful for collecting
 data about the user's initial experience and source, as well as dates
 representing the first time something happened.

 @param properties       properties dictionary

 */
- (void)setOnce:(NSDictionary *)properties;

/*!
 @method

 @abstract
 Increment the given numeric properties by the given values.

 @discussion
 Property keys must be NSString names of numeric properties. A property is
 numeric if its current value is a number. If a property does not exist, it
 will be set to the increment amount. Property values must be NSNumber objects.

 @param properties      properties dictionary
 */
- (void)increment:(NSDictionary *)properties;

/*!
 @method

 @abstract
 Convenience method for incrementing a single numeric property by the specified
 amount.

 @param property        property name
 @param amount          amount to increment by
 */
- (void)increment:(NSString *)property by:(NSNumber *)amount;

/*!
 @method

 @abstract
 Append values to list properties.

 @discussion
 Property keys must be <code>NSString</code> objects and values must be
 <code>NSString</code>, <code>NSNumber</code>, <code>NSNull</code>,
 <code>NSArray</code>, <code>NSDictionary</code>, <code>NSDate</code> or
 <code>NSURL</code> objects.

 @param properties      mapping of list property names to values to append
 */
- (void)append:(NSDictionary *)properties;

/*!
 @method

 @abstract
 Union list properties.

 @discussion
 Property keys must be <code>NSArray</code> objects.

 @param properties      mapping of list property names to lists to union
 */
- (void)union:(NSDictionary *)properties;

/*!
 @method

 @abstract
 Track money spent by the current user for revenue analytics.

 @param amount          amount of revenue received
 */
- (void)trackCharge:(NSNumber *)amount;

/*!
 @method

 @abstract
 Track money spent by the current user for revenue analytics and associate
 properties with the charge.

 @discussion
 Charge properties allow you segment on types of revenue. For instance, you
 could record a product ID with each charge so that you could segement on it in
 revenue analytics to see which products are generating the most revenue.
 */
- (void)trackCharge:(NSNumber *)amount withProperties:(NSDictionary *)properties;


/*!
 @method

 @abstract
 Delete current user's revenue history.
 */
- (void)clearCharges;

/*!
 @method

 @abstract
 Delete current user's record from Mixpanel People.
 */
- (void)deleteUser;

@end

/*!
 @protocol

 @abstract
 Delegate protocol for controlling the Mixpanel API's network behavior.

 @discussion
 Creating a delegate for the Mixpanel object is entirely optional. It is only
 necessary when you want full control over when data is uploaded to the server,
 beyond simply calling stop: and start: before and after a particular block of
 your code.
 */
@protocol MixpanelDelegate <NSObject>
@optional

/*!
 @method

 @abstract
 Asks the delegate if data should be uploaded to the server.

 @discussion
 Return YES to upload now, NO to defer until later.

 @param mixpanel        Mixpanel API instance
 */
- (BOOL)mixpanelWillFlush:(Mixpanel *)mixpanel;

@end
