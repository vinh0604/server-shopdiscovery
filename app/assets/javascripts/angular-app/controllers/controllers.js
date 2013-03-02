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

function usersCtrl ($scope, $http, $window) {
    $scope._ = $window._;
    $scope.currentPage = 0;
    $scope.totalPage = 0;
    $scope.lowerPage = 0;
    $scope.upperPage = 0;
    $scope.usersData = [];
    $scope.checkAll = false;

    $scope.prevPage = function () {
        if ($scope.currentPage > 0) {
            $scope.currentPage--;
        }
    };
    $scope.nextPage = function () {
        if ($scope.currentPage < $scope.totalPage - 1) {
            $scope.currentPage++;
        }
    };
    $scope.setPage = function (page) {
        if ($window._(page).isUndefined()) {
            $scope.currentPage = this.n;
        } else {
            $scope.currentPage = page;
        }
    };

    $scope.$watch('checkAll',function ($event) {
        $window._($scope.usersData).each( function(user) {
            user.checked = $scope.checkAll;
        });
    });
    $scope.$watch('currentPage + totalPage', function() {
        $scope.lowerPage = ($scope.currentPage > 2) ? ($scope.currentPage - 2) : 0;
        $scope.upperPage = ($scope.currentPage < $scope.totalPage - 3) ? ($scope.currentPage + 2) : ($scope.totalPage - 1);
    });
    $scope.$watch('currentPage', function() {
        $scope.checkAll = false;
        $http.get('/admin/users', {params: {page: $scope.currentPage + 1, per_page: 15}}).success(function (json) {
            $scope.usersData = $window._(json.users).pluck('user');
            $scope.totalPage = json.total_pages;
        });
    });
    $http.get('/admin/users', {params: {page: $scope.currentPage + 1, per_page: 15}}).success(function (json) {
        $scope.usersData = $window._(json.users).pluck('user');
        $scope.totalPage = json.total_pages;
    });
}

function testCtrl ($scope, $location) {
    $scope.name = $location.path();
}