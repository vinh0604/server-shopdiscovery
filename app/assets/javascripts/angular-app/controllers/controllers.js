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

function usersCtrl ($scope, $http, $window, $location) {
    $scope._ = $window._;
    $scope.currentPage = 0;
    $scope.totalPage = 0;
    $scope.lowerPage = 0;
    $scope.upperPage = 0;
    $scope.usersData = [];
    $scope.checkAll = false;
    $scope.keyword = '';
    $scope.$location = $location;

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
    $scope.doSearch = function () {
        $http.get('/admin/users', {params: {keyword: $scope.keyword, page: $scope.currentPage + 1, per_page: 15}}).success(function (json) {
            $scope.usersData = $window._(json.users).pluck('user');
            if ($scope.currentPage > json.total_pages - 1) {
                $scope.currentPage = 0;
            }
            $scope.totalPage = json.total_pages;
        });
    };
    $scope.doEdit = function () {
        $location.path('/admin/users/'+this.user.id+'/edit');
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
        $scope.doSearch();
    });
    $scope.doSearch();
}

function userCtrl ($scope, $routeParams, $http, $location, $window, GENDER_DATA, DEFAULT_IMG) {
    $scope.isNew = !$routeParams.userId;
    $scope.originalUser = {contact: {}, avatar: {}};
    $scope.user = angular.copy($scope.originalUser);
    $scope.progress = 0;
    $scope.GENDER_DATA = _(GENDER_DATA).map( function(value, key) {
        return {key: key, value: value};
    });
    resetAvatar();

    $scope.reset = function () {
        $scope.user = angular.copy($scope.originalUser);
        resetAvatar();
    };
    $scope.setFile = function (element) {
        if (!$scope.fileInput) {
            $scope.fileInput = element;
        }
        if (element.files && element.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $scope.$apply(function () {
                    $scope.avatarUrl = e.target.result;
                    $scope.uploadFile(element.files[0]);
                });
            };
            reader.readAsDataURL(element.files[0]);
        }
    };
    $scope.uploadFile = function(file) {
        if (file) {
            var fd = new FormData();
            fd.append("avatar", file);
            var xhr = new XMLHttpRequest();
            xhr.upload.addEventListener("progress", function (evt) {
                $scope.$apply(function(){
                    if (evt.lengthComputable) {
                        $scope.progress = Math.round(evt.loaded * 100 / evt.total);
                    } else {
                        $scope.progress = 0;
                    }
                });
            }, false);
            xhr.addEventListener("load", function (evt) {
                $scope.$apply(function(){
                    $scope.user.avatar_cache = evt.target.responseText;
                    $scope.progressVisible = false;
                });
            }, false);
            xhr.addEventListener("error", function (evt) {
                $scope.$apply(function(){
                    $scope.progressVisible = false;
                    resetAvatar();
                });
            }, false);
            xhr.addEventListener("abort", function (evt) {
                $scope.$apply(function(){
                    $scope.progressVisible = false;
                    resetAvatar();
                });
            }, false);
            xhr.open("POST", "/admin/users/upload");
            $scope.progressVisible = true;
            xhr.send(fd);
        }
    };
    $scope.submit = function () {
        var params = {
            user: _($scope.user).omit('contact'),
            contact: _($scope.user.contact).omit('full_name')
        };
        if ($scope.isNew) {
            $http.post('/admin/users', params).success(successHandler);
        } else {
            $http.put('/admin/users/' + $routeParams.userId, params).success(successHandler);
        }
    };
    $scope.loadData = function () {
        if (!$scope.isNew) {
            $http.get('/admin/users/' + $routeParams.userId).success(function (json) {
                if (json.user && json.user.contact) {
                    if (json.user.contact.gender) {
                        json.user.contact.gender = json.user.contact.gender.toString();
                    }
                    if (json.user.contact.birthdate) {
                        json.user.contact.birthdate = $window.moment(json.user.contact.birthdate)._d;
                    }
                }
                $scope.originalUser = json.user;
                $scope.user = angular.copy($scope.originalUser);
                resetAvatar();
            });
        }
    };

    $scope.loadData();

    function resetAvatar () {
        $scope.avatarUrl = $scope.user.avatar.url ? $scope.user.avatar.url : DEFAULT_IMG.user;
        if ($scope.fileInput) {
            $scope.fileInput.value = '';
        }
    }
    function successHandler () {
        $location.path('/admin/users/' + json.user.id + '/edit');
    }
}

function productsCtrl ($scope, $http, $window, $location, sharedCategories) {
    $scope._ = $window._;
    $scope.currentPage = 0;
    $scope.totalPage = 0;
    $scope.lowerPage = 0;
    $scope.upperPage = 0;
    $scope.productsData = [];
    $scope.checkAll = false;
    $scope.keyword = '';
    $scope.category_id = '';
    $scope.$location = $location;
    $scope.categories = [{id: '', name: 'All'}];
    $scope.currentCategory = {id: '', name: 'All'};

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
    $scope.doSearch = function () {
        $http.get('/admin/products', {params: {keyword: $scope.keyword, category_id: $scope.category_id, page: $scope.currentPage + 1, per_page: 15}}).success(function (json) {
            $scope.productsData = $window._(json.products).pluck('product');
            if ($scope.currentPage > json.total_pages - 1) {
                $scope.currentPage = 0;
            }
            $scope.totalPage = json.total_pages;
        });
    };
    $scope.doEdit = function () {
        $location.path('/admin/products/'+this.product.id+'/edit');
    };
    $scope.doChangeCategory = function (evt) {
        if (this.category.hasChild) {
            evt.stopPropagation();
        } else {
            $scope.category_id = this.category.id;
            $scope.currentCategory = this.category;
        }
    };

    $scope.$watch('checkAll',function ($event) {
        $window._($scope.productsData).each( function(product) {
            product.checked = $scope.checkAll;
        });
    });
    $scope.$watch('currentPage + totalPage', function() {
        $scope.lowerPage = ($scope.currentPage > 2) ? ($scope.currentPage - 2) : 0;
        $scope.upperPage = ($scope.currentPage < $scope.totalPage - 3) ? ($scope.currentPage + 2) : ($scope.totalPage - 1);
    });
    $scope.$watch('currentPage + category_id', function() {
        $scope.checkAll = false;
        $scope.doSearch();
    });

    if (!sharedCategories.get()) {
        $http.get('/admin/products/categories').success(function (json) {
            sharedCategories.set(json);
            $scope.categories = $scope.categories.concat(sharedCategories.get());
        });
    } else {
        $scope.categories = $scope.categories.concat(sharedCategories.get());
    }
    $scope.doSearch();
}

function shopsCtrl ($scope, $http, $window, $location) {
    $scope._ = $window._;
    $scope.currentPage = 0;
    $scope.totalPage = 0;
    $scope.lowerPage = 0;
    $scope.upperPage = 0;
    $scope.shopsData = [];
    $scope.checkAll = false;
    $scope.keyword = '';
    $scope.$location = $location;

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
    $scope.doSearch = function () {
        $http.get('/admin/shops', {params: {keyword: $scope.keyword, page: $scope.currentPage + 1, per_page: 15}}).success(function (json) {
            $scope.shopsData = $window._(json.shops).pluck('shop');
            if ($scope.currentPage > json.total_pages - 1) {
                $scope.currentPage = 0;
            }
            $scope.totalPage = json.total_pages;
        });
    };
    $scope.doEdit = function () {
        $location.path('/admin/shops/'+this.shop.id+'/edit');
    };

    $scope.$watch('checkAll',function ($event) {
        $window._($scope.shopsData).each( function(shop) {
            shop.checked = $scope.checkAll;
        });
    });
    $scope.$watch('currentPage + totalPage', function() {
        $scope.lowerPage = ($scope.currentPage > 2) ? ($scope.currentPage - 2) : 0;
        $scope.upperPage = ($scope.currentPage < $scope.totalPage - 3) ? ($scope.currentPage + 2) : ($scope.totalPage - 1);
    });
    $scope.$watch('currentPage', function() {
        $scope.checkAll = false;
        $scope.doSearch();
    });
    $scope.doSearch();
}

function testCtrl ($scope, $location) {
    $scope.name = $location.path();
}