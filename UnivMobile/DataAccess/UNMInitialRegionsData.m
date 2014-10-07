//
//  UNMInitialRegionsData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMInitialRegionsData.h"

@implementation UNMInitialRegionsData

+ (UNMRegionsData*)loadInitialRegionsData {
	
	UNMRegionsData* const regionsData =[[UNMRegionsData alloc] init];
	
	// TODO hardcoded values
	
	[regionsData addRegionWithId:@"bretagne" label:@"Bretagne"];
	[regionsData addRegionWithId:@"unrpcl" label:@"Limousin/Poitou-Charentes"];
	[regionsData addRegionWithId:@"ile_de_france" label:@"Île de France"];
	
	[regionsData addUniversityId:@"ubo" title:@"Université de Bretagne Occidentale"
	  shibbolethIdentityProvider:nil toRegionId:@"bretagne"];
	[regionsData addUniversityId:@"rennes1" title:@"Université de Rennes 1"
					  shibbolethIdentityProvider:nil toRegionId:@"bretagne"];
	[regionsData addUniversityId:@"rennes2" title:@"Université Rennes 2"
					  shibbolethIdentityProvider:nil toRegionId:@"bretagne"];
	[regionsData addUniversityId:@"enscr" title:@"École Nationale Supérieure de Chimie de Rennes"
					  shibbolethIdentityProvider:nil toRegionId:@"bretagne"];
	
	[regionsData addUniversityId:@"ulr" title:@"Université de La Rochelle"
					  shibbolethIdentityProvider:nil toRegionId:@"unrpcl"];
	[regionsData addUniversityId:@"ul" title:@"Université de Limoges"
					  shibbolethIdentityProvider:nil toRegionId:@"unrpcl"];
	[regionsData addUniversityId:@"up" title:@"Université de Poitiers"
					  shibbolethIdentityProvider:nil toRegionId:@"unrpcl"];
	[regionsData addUniversityId:@"ensma" title:@"ISAE-ENSMA"
					  shibbolethIdentityProvider:nil toRegionId:@"unrpcl"];
	[regionsData addUniversityId:@"crousp" title:@"CROUS PCL"
					  shibbolethIdentityProvider:nil toRegionId:@"unrpcl"];
	
	[regionsData addUniversityId:@"paris1" title:@"Paris 1 Panthéon-Sorbonne"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"paris3" title:@"Paris 3 Sorbonne Nouvelle"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"paris13" title:@"Paris Nord"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"uvsq" title:@"UVSQ"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"museum" title:@"Muséum national d'Histoire naturelle"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"evry" title:@"Evry-Val d'Essonne"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"paris6" title:@"UPMC"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"paris7" title:@"Paris Diderot"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"paris8" title:@"Paris 8"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"paris10" title:@"Paris Ouest Nanterre la Défense"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"paris11" title:@"Paris-Sud"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"upec" title:@"UPEC"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"crousVersailles" title:@"Cergy-Pontoise"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"paris1" title:@"CROUS Versailles"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"enscachan" title:@"ENS Cachan"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"ensiie" title:@"ENSIIE"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"unpidf" title:@"UNPIdF"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	[regionsData addUniversityId:@"enc" title:@"École nationale des chartes"
					  shibbolethIdentityProvider:nil toRegionId:@"ile_de_france"];
	
	regionsData.refreshedAt = [NSDate date];
	
	return regionsData;
}

@end
