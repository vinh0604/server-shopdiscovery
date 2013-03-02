define(['angular',
    // Application Files
    'angular-app/services/services',
    'angular-app/widgets/widgets',
    'angular-app/filters/filters',
    'angular-app/controllers/controllers'
], function (angular, services, widgets, filters, controllers) {
    return angular.module('app',['app.filters','app.services','app.widgets']).
                    config(['$routeProvider', '$locationProvider', '$httpProvider',
                    function ($routeProvider,  $locationProvider, $httpProvider) {
                        $routeProvider.when('/admin/users', {
                            templateUrl: 'users.html',
                            controller: usersCtrl
                        }).
                        when('/admin/products', {
                            templateUrl: 'test.html',
                            controller: testCtrl
                        }).
                        when('/admin/shops', {
                            templateUrl: 'test.html',
                            controller: testCtrl
                        }).
                        otherwise({redirectTo: '/admin/users'});

                        $locationProvider.html5Mode(true);

                        $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name="csrf-token"]').attr('content');
                    }]);
});