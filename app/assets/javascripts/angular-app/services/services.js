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
            constant('DEFAULT_IMG', {user: '/images/user.png'}).
            constant('REGION_DATA', [
                {
                    city: 'Hồ Chí Minh',
                    districts: ['Quận 1','Quận 2','Quận 3','Quận 4','Quận 5','Quận 6','Quận 7','Quận 8','Quận 9','Quận 10','Quận 11','Quận 12','Quận Thủ Đức','Quận Gò Vấp','Quận Bình Thạnh','Quận Tân Bình','Quận Tân Phú','Quận Phú Nhuận','Quận Bình Tân','Huyện Củ Chi','Huyện Hóc Môn','Huyện Bình Chánh','Huyện Nhà Bè','Huyện Cần Giờ']
                }
            ]);
});