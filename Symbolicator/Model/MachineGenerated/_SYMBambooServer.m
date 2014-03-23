// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooServer.m instead.

#import "_SYMBambooServer.h"

const struct SYMBambooServerAttributes SYMBambooServerAttributes = {
	.authenticationString = @"authenticationString",
	.url = @"url",
	.version = @"version",
};

const struct SYMBambooServerRelationships SYMBambooServerRelationships = {
	.projects = @"projects",
};

const struct SYMBambooServerFetchedProperties SYMBambooServerFetchedProperties = {
};

@implementation SYMBambooServerID
@end

@implementation _SYMBambooServer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BambooServer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BambooServer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BambooServer" inManagedObjectContext:moc_];
}

- (SYMBambooServerID*)objectID {
	return (SYMBambooServerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic authenticationString;






@dynamic url;






@dynamic version;






@dynamic projects;

	
- (NSMutableSet*)projectsSet {
	[self willAccessValueForKey:@"projects"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"projects"];
  
	[self didAccessValueForKey:@"projects"];
	return result;
}
	






@end
