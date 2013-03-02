define(['angular'], function (angular) {
    return angular.module('app.filters', []).
            filter('gender', function (GENDER_DATA) {
                return function (input) {
                    return GENDER_DATA[input] ? GENDER_DATA[input] : GENDER_DATA[2];
                };
            });
});