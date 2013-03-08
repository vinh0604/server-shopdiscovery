define(['angular'], function (angular) {
    var widgets = angular.module('app.widgets', []);
    var NUMBER_SERIAL_REGEX = /^[\d\s]*$/;
    var EAN_REGEX = /^\d{13}$/;
    widgets.directive('bsTypeahead', ['$parse', function($parse) {
        'use strict';

        return {
            restrict: 'A',
            require: '?ngModel',
            link: function postLink(scope, element, attrs, controller) {

                var getter = $parse(attrs.bsTypeahead),
                        setter = getter.assign,
                        value = getter(scope);

                // Watch bsTypeahead for changes
                scope.$watch(attrs.bsTypeahead, function(newValue, oldValue) {
                    if(newValue !== oldValue) {
                        value = newValue;
                    }
                });

                element.attr('data-provide', 'typeahead');
                element.typeahead({
                    source: function(query) { return angular.isFunction(value) ? value.apply(null, arguments) : value; },
                    minLength: attrs.minLength || 1,
                    items: attrs.items,
                    updater: function(value) {
                        // If we have a controller (i.e. ngModelController) then wire it up
                        if(controller) {
                            scope.$apply(function () {
                                controller.$setViewValue(value);
                            });
                        }
                        return value;
                    }
                });

                // Bootstrap override
                var typeahead = element.data('typeahead');
                // Fixes #2043: allows minLength of zero to enable show all for typeahead
                typeahead.lookup = function (ev) {
                    var items;
                    this.query = this.$element.val() || '';
                    if (this.query.length < this.options.minLength) {
                        return this.shown ? this.hide() : this;
                    }
                    items = $.isFunction(this.source) ? this.source(this.query, $.proxy(this.process, this)) : this.source;
                    return items ? this.process(items) : this;
                };

                // Support 0-minLength
                if(attrs.minLength === "0") {
                    setTimeout(function() { // Push to the event loop to make sure element.typeahead is defined (breaks tests otherwise)
                        element.on('focus', function() {
                            setTimeout(element.typeahead.bind(element, 'lookup'), 200);
                        });
                    });
                }

            }
        };
    }]);
    widgets.directive('numberSerial', function(){
        'use strict';

        return {
            require: '?ngModel',
            link: function(scope, elm, attrs, ctrl) {
                ctrl.$parsers.unshift(function(viewValue) {
                    if (!viewValue || NUMBER_SERIAL_REGEX.test(viewValue)) {
                        ctrl.$setValidity('numberSerial', true);
                        return viewValue;
                    } else {
                        ctrl.$setValidity('numberSerial', false);
                        return viewValue;
                    }
                });
            }
        };
    });
    widgets.directive('validPassword', function(){
        'use strict';

        return {
            require: '?ngModel',
            link: function(scope, elm, attrs, ctrl) {
                ctrl.$parsers.unshift(function(viewValue) {
                    if (!viewValue || (viewValue && viewValue.length >= 6)) {
                        ctrl.$setValidity('validPassword', true);
                        return viewValue;
                    } else {
                        ctrl.$setValidity('validPassword', false);
                        return viewValue;
                    }
                });
            }
        };
    });
    widgets.directive('eanNumber', function(){
        'use strict';

        return {
            require: '?ngModel',
            link: function(scope, elm, attrs, ctrl) {
                ctrl.$parsers.unshift(function(viewValue) {
                    if (!viewValue || EAN_REGEX.test(viewValue)) {
                        ctrl.$setValidity('ean', true);
                        return viewValue;
                    } else {
                        ctrl.$setValidity('ean', false);
                        return viewValue;
                    }
                });
            }
        };
    });
    return widgets;
});