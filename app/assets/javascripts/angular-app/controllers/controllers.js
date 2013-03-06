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
    function successHandler (json) {
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

function productCtrl ($scope, $routeParams, $http, $window, $location, sharedCategories) {
    $scope.isNew = !$routeParams.productId;
    $scope.categories = [];
    $scope.originalProduct = {category: {}, tags: [], specifics: {}};
    $scope.product = angular.copy($scope.originalProduct);
    $scope.currentTag = '';
    $scope.detailOpened = false;
    $scope.currentSpecification = {};

    $scope.reset = function () {
        $scope.product = angular.copy($scope.originalProduct);
    };
    $scope.submit = function () {
        var params = {
            product: _($scope.product).pick('id','name', 'barcode', 'specifics'),
            tags: $scope.product.tags
        };
        if ($scope.product.category) {
            params.product.category_id = $scope.product.category.id;
        }
        if ($scope.isNew) {
            $http.post('/admin/products', params).success(successHandler);
        } else {
            $http.put('/admin/products/' + $routeParams.productId, params).success(successHandler);
        }
    };
    $scope.loadData = function () {
        if (!$scope.isNew) {
            $http.get('/admin/products/' + $routeParams.productId).success(function (json) {
                $scope.originalProduct = _(json.product).pick('id','name', 'barcode', 'specifics');
                $scope.originalProduct.tags = _(json.product.tags).map(function (tag) {
                    return tag.tag.value;
                }) || [];
                $scope.originalProduct.category = json.product.category || {};
                $scope.product = angular.copy($scope.originalProduct);
            });
        }
    };
    $scope.doChangeCategory = function (evt) {
        if (this.category.hasChild) {
            evt.stopPropagation();
        } else {
            $scope.product.category = this.category;
        }
    };
    $scope.doAddTag = function () {
        var value = $scope.currentTag.trim().toLowerCase();
        if (value && ($scope.product.tags.indexOf(value) == -1)) {
            $scope.product.tags.push(value);
        }
        $scope.currentTag = '';
    };
    $scope.doRemoveTag = function () {
        var index = $scope.product.tags.indexOf(this.tag);
        if (index !== -1) {
            $scope.product.tags.splice(index,1);
        }
    };
    $scope.doGetTagSuggestions = function (query, process) {
        return $http.get('/admin/suggestions/tags', {params: {query: query}}).success(function (json) {
            return process(json);
        });
    };
    $scope.doDeleteSpecific = function () {
        delete $scope.product.specifics[this.key];
    };
    $scope.doAddSpecific = function () {
        $scope.product.specifics[$scope.currentSpecification.name] = $scope.currentSpecification.value;
        $scope.currentSpecification = {};
    };
    $scope.openDetail = function () {
        $scope.detailOpened = true;
    };
    $scope.closeDetail = function () {
        $scope.detailOpened = false;
    };

    if (!sharedCategories.get()) {
        $http.get('/admin/products/categories').success(function (json) {
            sharedCategories.set(json);
            $scope.categories = $scope.categories.concat(sharedCategories.get());
        });
    } else {
        $scope.categories = $scope.categories.concat(sharedCategories.get());
    }
    $scope.loadData();

    function successHandler (json) {
        $location.path('/admin/products/' + json.product.id + '/edit');
    }
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

function shopCtrl ($scope, $routeParams, $http, $window, $location, REGION_DATA) {
    $scope.isNew = !$routeParams.shopId;
    $scope.cityData = REGION_DATA;
    $scope.districtData = [];
    $scope.originalShop = {city: '', district: '', managers: [], phones: []};
    $scope.userData = [];
    $scope.shop = angular.copy($scope.originalShop);
    $scope.currentPhone = '';
    $scope.currentManager = {username: '', owner: false};
    $scope.detailOpened = false;
    $scope.opts = {
        dialogClass: 'modal modal-manager'
    };

    $scope.reset = function () {
        $scope.shop = angular.copy($scope.originalShop);
    };
    $scope.submit = function () {
        var params = {
            shop: $window._($scope.shop).pick('id','name', 'street_address', 'district', 'city', 'website', 'phones', 'description'),
            managers: $window._($scope.shop.managers).map(function (manager) {
                return {id: manager.id, owner: manager.owner};
            })
        };
        if ($scope.isNew) {
            $http.post('/admin/shops', params).success(successHandler);
        } else {
            $http.put('/admin/shops/' + $routeParams.shopId, params).success(successHandler);
        }
    };
    $scope.loadData = function () {
        if (!$scope.isNew) {
            $http.get('/admin/shops/' + $routeParams.shopId).success(function (json) {
                $scope.originalShop = _(json.shop).pick('id','name', 'website', 'street_address', 'location', 'city', 'district', 'description');
                $scope.originalShop.managers = _(_(json.shop.managers).map(function (m) {
                    if (m.manager && m.manager.user) {
                        m.manager.user.owner = m.manager.owner;
                        return m.manager.user;
                    } else {
                        return null;
                    }
                })).compact();
                var districtData = $window._($scope.cityData).find( function(data) {
                    return data.city == json.shop.city;
                });
                if (districtData) {
                    $scope.districtData = $window._(districtData.districts).map( function(district) {
                        return {district: district};
                    });
                } else {
                    $scope.districtData = [];
                }
                $scope.originalShop.phones = json.shop.phones || [];
                $scope.shop = angular.copy($scope.originalShop);
            });
        }
    };
    $scope.doAddPhone = function () {
        var value = $scope.currentPhone.trim();
        if (value && ($scope.shop.phones.indexOf(value) == -1)) {
            $scope.shop.phones.push(value);
        }
        $scope.currentPhone = '';
    };
    $scope.doRemovePhone = function () {
        var index = $scope.shop.phones.indexOf(this.phone);
        if (index !== -1) {
            $scope.shop.phones.splice(index,1);
        }
    };
    $scope.doGetUserSuggestions = function (query, process) {
        return $http.get('/admin/suggestions/users', {params: {query: query}}).success(function (json) {
            $scope.userData = json;
            return process($window._(json).pluck('username'));
        });
    };
    $scope.doDeleteManager = function () {
        var that = this;
        $scope.shop.managers = $window._($scope.shop.managers).reject(function(manager) {
            return manager.id === that.manager.id;
        });
    };
    $scope.doAddManager = function () {
        var manager = $window._($scope.userData).find( function(data) {
            return data.username === $scope.currentManager.username;
        });
        if (manager) {
            manager.owner = $scope.currentManager.owner;
            $scope.shop.managers.push(manager);
        }
        $scope.currentManager = {username: '', owner: false};
    };
    $scope.openDetail = function () {
        $scope.detailOpened = true;
    };
    $scope.closeDetail = function () {
        $scope.detailOpened = false;
    };
    $scope.doChangeDistrictOptions = function () {
        var data = $window._($scope.cityData).find( function(data) {
            return data.city == $scope.shop.city;
        });
        if (data) {
            $scope.districtData = $window._(data.districts).map( function(district) {
                return {district: district};
            });
        } else {
            $scope.districtData = [];
        }
        $scope.shop.district = '';
    };

    $scope.loadData();

    function successHandler (json) {
        $location.path('/admin/shops/' + json.shop.id + '/edit');
    }
}

function testCtrl ($scope, $location) {
    $scope.name = $location.path();
}