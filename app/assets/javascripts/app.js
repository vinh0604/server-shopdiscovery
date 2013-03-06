define(['angular',
    // Angular UI
    'angular-ui',
    // Angular UI Bootstrap
    'ui-bootstrap',
    // Application Files
    'angular-app/services/services',
    'angular-app/widgets/widgets',
    'angular-app/filters/filters',
    'angular-app/controllers/controllers',
    'angular-sanitize'
], function (angular, ui, ui_bootstrap, services, widgets, filters, controllers) {
    return angular.module('app',['ui', 'ui.bootstrap', 'app.filters','app.services','app.widgets','ngSanitize']).
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
                            templateUrl: 'product.html',
                            controller: productCtrl
                        }).
                        when('/admin/products/:productId/edit', {
                            templateUrl: 'product.html',
                            controller: productCtrl
                        }).
                        when('/admin/shops', {
                            templateUrl: 'shops.html',
                            controller: shopsCtrl
                        }).
                        when('/admin/shops/new', {
                            templateUrl: 'shop.html',
                            controller: shopCtrl
                        }).
                        when('/admin/shops/:shopId/edit', {
                            templateUrl: 'shop.html',
                            controller: shopCtrl
                        }).
                        otherwise({redirectTo: '/admin/users'});

                        $locationProvider.html5Mode(true);

                        $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name="csrf-token"]').attr('content');
                    }]).value('ui.config', {
                        tinymce: {
                            theme: 'simple',
                            width : "285"
                        }
                    });
});