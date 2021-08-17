// import 'dart:math' as math;
exploreLatLong(latitude, longitude) {
  // var offset = 1.0 / 1000.0;
  // var latMax = latitude + offset;
  // var latMin = latitude - offset;
  // var lngOffset = offset * math.cos(latitude * math.pi / 180.0);
  // var lngMax = longitude + lngOffset;
  // var lngMin = longitude - lngOffset;

  var offset = 0.0023;
  var latMax = latitude + offset;
  var latMin = latitude - offset;
  var lngMax = longitude + offset;
  var lngMin = longitude - offset;
  return {'west': lngMin, 'east': lngMax, 'south': latMin, 'north': latMax};
}

const ZILLOW_IP = 'https://www.zillow.com/search/GetSearchPageState.htm';