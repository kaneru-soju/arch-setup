const tempElement = document.querySelector('.temperature p');

const weather = {};
weather.temperature = {
  unit: '<your-units>',
};

// change to 'C' if you need celsius
var tempUnit = 'F';

const KELVIN = 273.15;
// use your own key for the weather, get it here: https://openweathermap.org/
const key = '<your-api-key>';
const lang = '<your-lang>'

// set position function
setPosition();

function setPosition(position) {
  /* here you can change your position
     you can use https://www.latlong.net/ to get it */
  const latitude = '<your-lat-without-quotes>';
  const longitude = '<your-long-without-quotes>';

  getWeather(latitude, longitude);
}

// get the weather data
function getWeather(latitude, longitude) {
  const api = `https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${key}&lang=${lang}`;

  console.log(api);

  fetch(api)
    .then(function (response) {
      const data = response.json();
      return data;
    })
    .then(function (data) {
      const celsius = Math.floor(data.main.temp - KELVIN);
      weather.temperature.value =
        tempUnit == 'C' ? celsius : (celsius * 9) / 5 + 32;
      weather.description = data.weather[0].description;
      weather.iconId = data.weather[0].icon;
    })
    .then(function () {
      displayWeather();
    });
}

// display weather info
function displayWeather() {
  tempElement.innerHTML = `${weather.temperature.value}°${tempUnit} | ${weather.description}`;
}