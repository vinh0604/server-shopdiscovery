define(['angular'], function (angular) {
    return angular.module('app.services', []).
            factory('sharedCategories', function () {
                var categories = null;
                return {
                    get:function () {
                        return categories;
                    },
                    set:function (cat) {
                        categories = cat;
                    }
                };
            }).
            constant('GENDER_DATA', {0: 'Female', 1: 'Male', 2: 'Other'}).
            constant('DEFAULT_IMG', {user: '/images/user.png'});
});