define(['angular',
    // Angular UI
    'angular-ui',
    // Application Files
    'angular-app/services/services',
    'angular-app/widgets/widgets',
    'angular-app/filters/filters',
    'angular-app/controllers/controllers'
], function (angular, ui, services, widgets, filters, controllers) {
    return angular.module('app',['ui', 'app.filters','app.services','app.widgets']).
                    config(['$routeProvider', '$locationProvider', '$httpProvider',
                    function ($routeProvider,  $locationProvider, $httpProvider) {
                        $routeProvider.when('/admin/users', {
                            templateUrl: 'users.html',
                            controller: usersCtrl
                        }).
                        when('/admin/users/new', {
                            templateUrl: 'user.html',
                            controller: userCtrl
                        }).
                        when('/admin/users/:userId/edit', {
                            templateUrl: 'user.html',
                            controller: userCtrl
                        }).
                        when('/admin/products', {
                            templateUrl: 'products.html',
                            controller: productsCtrl
                        }).
                        when('/admin/products/new', {
                            templateUrl: 'test.html',
                            controller: testCtrl
                        }).
                        when('/admin/products/:productId/edit', {
                            templateUrl: 'test.html',
                            controller: testCtrl
                        }).
                        when('/admin/shops', {
                            templateUrl: 'shops.html',
                            controller: shopsCtrl
                        }).
                        when('/admin/shops/new', {
                            templateUrl: 'test.html',
                            controller: testCtrl
                        }).
                        when('/admin/shops/:shopId/edit', {
                            templateUrl: 'test.html',
                            controller: testCtrl
                        }).
                        otherwise({redirectTo: '/admin/users'});

                        $locationProvider.html5Mode(true);

                        $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name="csrf-token"]').attr('content');
                    }]);
});