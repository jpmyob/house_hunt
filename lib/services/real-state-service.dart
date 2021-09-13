import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:real_state_finder/utils/constants.dart';

class RealStateService {
  Future getZillowPropertyList({Position position}) async {
    try {
      var pos = exploreLatLong(position.latitude, position.longitude);
      var res = await http.get(Uri.parse(
        '$ZILLOW_IP?searchQueryState={"pagination":{},"mapBounds":{"west":${pos["west"]},"east":${pos["east"]},"south":${pos["south"]},"north":${pos["north"]}},"isMapVisible":true,"filterState":{$zillowFilter},"isListVisible":true}&wants={"cat1":["listResults","mapResults"],"cat2":["total"]}'
      ));
      List list = json.decode(res.body)['cat1']['searchResults']['listResults'] ?? [];
      List relaxedList = json.decode(res.body)['cat1']['searchResults']['relaxedResults'];
      allPropertyList = [...list, ...relaxedList];
      return allPropertyList;
    } on FormatException catch(e) {
      print('Error: getRealStateList()\n$e');
      return [];
    }
  }

  searchFilterQuery() {
    if(forSale) {
      zillowFilter = '"price":{"min":$minPrice,"max":$maxPrice},"monthlyPayment":{"min":0},"isAllHomes":{"value":$isAllHomes},"isApartment":{"value":$isApartment},'+
      '"isTownhouse":{"value":$isTownhouse},"isComingSoon":{"value":$isAllHomes},"isNewConstruction":{"value":$isAllHomes},"isManufactured":{"value":$isManufactured},'+
      '"isLotLand":{"value":$isLotLand},"isCondo":{"value":$isCondo},"isApartmentOrCondo":{"value":${isApartment && isCondo}}';
    } else {
      zillowFilter = '"isForSaleByAgent":{"value":false},"isForSaleByOwner":{"value":false},"isNewConstruction":{"value":false},"isForSaleForeclosure":{"value":false},"isComingSoon":{"value":false},"isAuction":{"value":false},"isForRent":{"value":true},"isAllHomes":{"value":true},"isCondo":{"value":false},"isTownhouse":{"value":false},"isApartment":{"value":false},"isApartmentOrCondo":{"value":false}';
    }
  }

  // Future getRealtorList({Position position}) async {
  //   try {
  //     // var pos = exploreLatLong(position.latitude, position.longitude);
  //     var res = await http.post(Uri.parse(
  //       'https://www.realtor.com/api/v1/hulk?client_id=rdc-x&schema=vesta'
  //       ),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode({"query":"\n\nfragment geoStatisticsFields on Geo {\n  geo_statistics(group_by: property_type) {\n    housing_market {\n      by_prop_type(type :[\"home\"]){\n        type\n        attributes {\n          median_listing_price\n        }\n      }\n      median_listing_price\n    }\n  }\n}\n\nquery ConsumerSearchQuery($query: HomeSearchCriteria!, $limit: Int, $offset: Int, $sort: [SearchAPISort], $sort_type: SearchSortType, $geoSupportedSlug: String!, $bucket: SearchAPIBucket)\n{\n  home_search: home_search(query: $query,\n    sort: $sort,\n    limit: $limit,\n    offset: $offset,\n    sort_type: $sort_type,\n    bucket: $bucket,\n  ){\n    count\n    total\n    results {\n      property_id\n      list_price\n      primary_photo (https: true){\n        href\n      }\n      source {\n        id\n        agents{\n          office_name\n        }\n        type\n        spec_id\n        plan_id\n      }\n      community {\n        property_id\n        description {\n          name\n        }\n        advertisers{\n          office{\n            hours\n            phones {\n              type\n              number\n            }\n          }\n          builder {\n            fulfillment_id\n          }\n        }\n      }\n      products {\n        brand_name\n        products\n      }\n      listing_id\n      matterport\n      virtual_tours{\n        href\n        type\n      }\n      status\n      permalink\n      price_reduced_amount\n      other_listings{rdc {\n      listing_id\n      status\n      listing_key\n      primary\n    }}\n      description{\n        beds\n        baths\n        baths_full\n        baths_half\n        baths_1qtr\n        baths_3qtr\n        garage\n        stories\n        type\n        sub_type\n        lot_sqft\n        sqft\n        year_built\n        sold_price\n        sold_date\n        name\n      }\n      location{\n        street_view_url\n        address{\n          line\n          postal_code\n          state\n          state_code\n          city\n          coordinate {\n            lat\n            lon\n          }\n        }\n        county {\n          name\n          fips_code\n        }\n      }\n      tax_record {\n        public_record_id\n      }\n      lead_attributes {\n        show_contact_an_agent\n        opcity_lead_attributes {\n          cashback_enabled\n          flip_the_market_enabled\n        }\n        lead_type\n      }\n      open_houses {\n        start_date\n        end_date\n        description\n        methods\n        time_zone\n        dst\n      }\n      flags{\n        is_coming_soon\n        is_pending\n        is_foreclosure\n        is_contingent\n        is_new_construction\n        is_new_listing (days: 14)\n        is_price_reduced (days: 30)\n        is_plan\n        is_subdivision\n      }\n      list_date\n      last_update_date\n      coming_soon_date\n      photos(limit: 2, https: true){\n        href\n      }\n      tags\n      branding {\n        type\n        photo\n        name\n      }\n    }\n  }\n  geo(slug_id: $geoSupportedSlug) {\n    parents {\n      geo_type\n      slug_id\n      name\n    }\n    geo_statistics(group_by: property_type) {\n      housing_market {\n        by_prop_type(type :[\"home\"]){\n          type\n           attributes{\n            median_listing_price\n            median_lot_size\n            median_sold_price\n            median_price_per_sqft\n            median_days_on_market\n          }\n        }\n        listing_count\n        median_listing_price\n        median_rent_price\n        median_price_per_sqft\n        median_days_on_market\n        median_sold_price\n        month_to_month {\n          active_listing_count_percent_change\n          median_days_on_market_percent_change\n          median_listing_price_percent_change\n          median_listing_price_sqft_percent_change\n        }\n      }\n    }\n    recommended_cities: recommended(query: {geo_search_type: city, limit: 20}) {\n      geos {\n        ... on City {\n          city\n          state_code\n          geo_type\n          slug_id\n        }\n        ...geoStatisticsFields\n      }\n    }\n    recommended_neighborhoods: recommended(query: {geo_search_type: neighborhood, limit: 20}) {\n      geos {\n        ... on Neighborhood {\n          neighborhood\n          city\n          state_code\n          geo_type\n          slug_id\n        }\n        ...geoStatisticsFields\n      }\n    }\n    recommended_counties: recommended(query: {geo_search_type: county, limit: 20}) {\n      geos {\n        ... on HomeCounty {\n          county\n          state_code\n          geo_type\n          slug_id\n        }\n        ...geoStatisticsFields\n      }\n    }\n    recommended_zips: recommended(query: {geo_search_type: postal_code, limit: 20}) {\n      geos {\n        ... on PostalCode {\n          postal_code\n          geo_type\n          slug_id\n        }\n        ...geoStatisticsFields\n      }\n    }\n  }\n}","variables":{"query":{"status":["for_sale","ready_to_build"],"primary":true,"search_location":{"location":"Nashville"},"boundary":{"type":"polygon","coordinates":[[[-86.768751,36.196445],[-86.763751,36.196445],[-86.763751,36.191445],[-86.768751,36.191445],[-86.768751,36.196445]]]}},"limit":200,"offset":0,"zohoQuery":{"silo":"search_result_page","location":"","property_status":"for_sale","filters":{}},"sort_type":"relevant","geoSupportedSlug":"","zoom":12},"callfrom":"SRP","nrQueryType":"MAIN_SRP","seoPayload":{"pageType":{"silo":"search_result_page","status":"for_sale"},"county_needed_for_uniq":false}}),
  //     );
  //     allPropertyList = json.decode(res.body)['cat1']['searchResults']['listResults'] ?? [];
  //     return json.decode(res.body)['data']['home_search']['results'];
  //   } on FormatException catch(e) {
  //     print('Error: getRealStateList()\n$e');
  //     return [];
  //   }
  // }

  // double searchAreaOffset(double radius) {
  //   List<double> ara = [600, 60, 0.6];
  //   String res = "0.00";
  //   double offset = 0;
  //   for(int i = 0; i < 3; i++) {
  //     if(radius == 0) break;
  //     if(radius >= ara[i]) {
  //       int division = radius~/ara[i];
  //       radius = radius % ara[i];
  //       if(division > 9) division = 9;
  //       res = res+"$division";
  //     } else {
  //       res = res+"0";
  //     }
  //   }
  //   offset = double.parse(res);
  //   return offset;
  // }
}