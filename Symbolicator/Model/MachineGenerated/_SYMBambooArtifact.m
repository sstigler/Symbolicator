// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooArtifact.m instead.

#import "_SYMBambooArtifact.h"

const struct SYMBambooArtifactAttributes SYMBambooArtifactAttributes = {
	.name = @"name",
	.url = @"url",
};

const struct SYMBambooArtifactRelationships SYMBambooArtifactRelationships = {
	.build = @"build",
};

const struct SYMBambooArtifactFetchedProperties SYMBambooArtifactFetchedProperties = {
};

@implementation SYMBambooArtifactID
@end

@implementation _SYMBambooArtifact

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BambooArtifact" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BambooArtifact";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BambooArtifact" inManagedObjectContext:moc_];
}

- (SYMBambooArtifactID*)objectID {
	return (SYMBambooArtifactID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic url;






@dynamic build;

	






@end
