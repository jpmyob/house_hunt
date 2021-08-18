double offset = 0.0025;
double searchRadius = 1500;
exploreLatLong(latitude, longitude) {
  double latMax = latitude + offset;
  double latMin = latitude - offset;
  double lngMax = longitude + offset;
  double lngMin = longitude - offset;
  return {'west': lngMin, 'east': lngMax, 'south': latMin, 'north': latMax};
}

const ZILLOW_IP = 'https://www.zillow.com/search/GetSearchPageState.htm';