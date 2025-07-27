String httpScheme = 'https';
String apiBaseUrl = 'openweathermap.org';

String weatherIconUrl(String iconCode) {
  return "$httpScheme://$apiBaseUrl/img/w/$iconCode.png";
}
// "$httpScheme://$apiBaseUrl/img/w/${weather.icon}.png";

String apikey = 'ad8c5db167addf1bf419758585654f70';
String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
String forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';
