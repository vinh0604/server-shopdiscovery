define(['angular',
    // Application Files
    'angular-app/services/services',
    'angular-app/widgets/widgets',
    'angular-app/filters/filters',
    'angular-app/controllers/controllers'
], function (angular, services, widgets, filters, controllers) {
    return angular.module('app',['app.filters','app.services','app.widgets']);
});