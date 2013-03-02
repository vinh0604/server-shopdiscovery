function navCtrl ($scope, $location, $http, $window) {
    $scope.navData = [
        {id: '/admin/users', value: 'Users', className: 'icon-user'},
        {id: '/admin/products', value: 'Products', className: 'icon-tags'},
        {id: '/admin/shops', value: 'Shops', className: 'icon-home'}
    ];

    $scope.isActiveRoute = function(route) {
        return route === $location.path();
    };

    $scope.logOut = function() {
        $http({method: 'DELETE', url: '/logout.js'}).success(function () {
            $window.location = '/login';
        });
    };
}

function testCtrl ($scope, $location) {
    $scope.name = $location.path();
}