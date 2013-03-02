define(['angular'], function (angular) {
    return angular.module('app.services', []).
            constant('GENDER_DATA', {0: 'Female', 1: 'Male', 2: 'Not Specific'});
});