// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
require.config({
    baseUrl: '/assets',
    paths: {
        "jquery": "jquery-1.9.1.min",
        "angular": "angular.min",
        "lodash": "lodash.underscore.min",
        "bootstrap": "bootstrap.min",
        "jquery-ui": "jquery-ui-1.9.2.custom.min",
        "angular-ui": "angular-ui.min",
        "moment": "moment.min",
        "accounting": "accounting.min",
        "bootbox": "bootbox.min",
        "ui-bootstrap": "ui-bootstrap-tpls-0.2.0.min",
        "angular-sanitize": "angular-sanitize.min",
        "tinymce": "tiny_mce/tiny_mce"
    },
    shim: {
        'angular': {
            exports: 'angular',
            deps: ['jquery']
        },
        "bootstrap": ["jquery"],
        "jquery-ui": ["jquery"],
        "angular-ui": ["angular", "jquery-ui", "bootstrap"],
        "ui-bootstrap": ["angular", "bootstrap"],
        "bootbox": ["jquery","bootstrap"],
        "angular-sanitize": ["angular"],
        "tiny_mce/jquery.tinymce": ["jquery"],
        "tinymce": ["tiny_mce/jquery.tinymce"]
    }
});

require(['lodash','jquery','angular','app','bootstrap','jquery-ui','moment','accounting','bootbox',"tinymce"], function (_,$,angular,core) {
    angular.bootstrap(document,['app']);
});