define(['angular'], function (angular) {
    return angular.module('app.services', []).
            constant('GENDER_DATA', {0: 'Female', 1: 'Male', 2: 'Other'}).
            constant('DEFAULT_IMG', {user: '/images/user.png'});
});