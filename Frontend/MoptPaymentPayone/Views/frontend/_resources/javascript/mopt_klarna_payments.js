;(function ($, window) {
    'use strict';

    var pluginRegistered = false;
    var widgetLoaded = false;

    reset();

    // update on ajax changes
    $.subscribe('plugin/swShippingPayment/onInputChanged', function () {
        reset();
    });

    function reset() {
        if (!window.Klarna) {
            destroyPlugin();

            return;
        }

        if (pluginRegistered) {
            updatePlugin();
        } else {
            registerPlugin();
            pluginRegistered = true;
        }
    }

    function registerPlugin() {
        StateManager.addPlugin('#shippingPaymentForm', 'payoneKlarnaPayments', null, null);
    }

    function updatePlugin() {
        StateManager.updatePlugin('#shippingPaymentForm', 'payoneKlarnaPayments');
    }

    function destroyPlugin() {
        StateManager.destroyPlugin('#shippingPaymentForm', 'payoneKlarnaPayments');
        StateManager.removePlugin('#shippingPaymentForm', 'payoneKlarnaPayments', null);
    }

    $.plugin('payoneKlarnaPayments', {
        defaults: {},
        data: $('#mopt_payone__klarna_information').data(),
        payTypeTranslations: {
            KDD: 'pay_now',
            KIV: 'pay_later',
            KIS: 'pay_over_time'
        },

        init: function () {
            var me = this;

            me.registerEventListeners();
        },

        update: function () {
        },

        destroy: function () {
            var me = this;

            me._destroy();
        },

        registerEventListeners: function () {
            var me = this;

            me._on(me.$el.find('#mopt_payone__klarna_paymenttype'), 'change', function () {
                me.inputChangeHandler();
            });

            me._on(me.$el.find('#mopt_payone__klarna_telephone'), 'change', function () {
                me.inputChangeHandler();
            });

            me._on(me.$el.find('#mopt_payone__klarna_personalId'), 'change', function () {
                me.inputChangeHandler();
            });

            me._on(me.$el.find('#mopt_payone__klarna_birthday'), 'change', function () {
                me.inputChangeHandler();
            });

            me._on(me.$el.find('#mopt_payone__klarna_birthmonth'), 'change', function () {
                me.inputChangeHandler();
            });

            me._on(me.$el.find('#mopt_payone__klarna_birthyear'), 'change', function () {
                me.inputChangeHandler();
            });

            me._on(me.$el.find('#mopt_payone__klarna_agreement'), 'change', function () {
                me.inputChangeHandler();
            });
        },

        generateBirthDate: function (customerDateOfBirth_fromData) {
            var birthdate_fromInput = null;

            var $birthdate_day = $('#mopt_payone__klarna_birthday');
            var $birthdate_month = $('#mopt_payone__klarna_birthmonth');
            var $birthdate_year = $('#mopt_payone__klarna_birthyear');

            var birthdate_day = (Array(2).join("0") + $birthdate_day.val()).slice(-2);
            var birthdate_month = (Array(2).join("0") + $birthdate_month.val()).slice(-2);
            var birthdate_year = $birthdate_year.val();

            if (birthdate_day && birthdate_month && birthdate_year) {
                birthdate_fromInput = birthdate_year + birthdate_month + birthdate_day // yyyymmdd
            }

            if (birthdate_fromInput) {
                return birthdate_fromInput;
            }

            return customerDateOfBirth_fromData
        },

        generatePhoneNumber: function (phoneNumber_fromData) {
            var phoneNumber_fromInput = $('#mopt_payone__klarna_telephone').val();
            if (phoneNumber_fromInput) {
                return phoneNumber_fromInput;
            }

            return phoneNumber_fromData;
        },

        generatePersonalId: function (personalId_fromData) {
            var personalId_fromInput = $('#mopt_payone__klarna_personalId').val();
            if (personalId_fromInput) {
                return personalId_fromInput;
            }

            return personalId_fromData;
        },

        inputChangeHandler: function () {
            var me = this;
            var birthdate = me.generateBirthDate(me.data['customerDateOfBirth']);
            var financingtype = $("#mopt_payone__klarna_paymenttype").val();
            var billingAddressPhone = me.generatePhoneNumber(me.data['billingAddress-Phone'])
            var personalId = me.generatePersonalId(me.data['customerNationalIdentificationNumber']);
            var $gdpr_agreement = $('#mopt_payone__klarna_agreement');
            var loadWidgetIsAllowed =
                financingtype
                && birthdate
                && personalId
                && ((String)(billingAddressPhone)).length >= 5
                && $gdpr_agreement.is(':checked');

            me.unloadKlarnaWidget();

            if (loadWidgetIsAllowed) {
                // disable submit buttons
                $(me.$el.get(0).elements).filter(':submit').each(function (_, element) {
                    element.disabled = true;
                });

                if (birthdate === 'notNeededByCountry') {
                    birthdate = '';
                }

                if (billingAddressPhone === 'notNeededByCountry') {
                    billingAddressPhone = '';
                }

                if (personalId === 'notNeededByCountry') {
                    personalId = '';
                }

                me.startKlarnaSessionCall(financingtype, birthdate, billingAddressPhone, personalId).done(function (response) {
                    response = $.parseJSON(response);
                    $('#payment_meanmopt_payone_klarna').val(response['paymentId']);

                    me.loadKlarnaWidget(financingtype, response['client_token']).done(function () {
                        widgetLoaded = true;

                        // re enable submit buttons
                        $(me.$el.get(0).elements).filter(':submit').each(function (_, element) {
                            element.disabled = false;
                        });
                    });
                });
            }
        },

        startKlarnaSessionCall: function (financingtype, birthdate, phoneNumber, personalId) {
            var me = this;
            var url = me.data['startKlarnaSession-Url'];
            var parameter = {
                'financingtype': financingtype,
                'birthdate': birthdate,
                'phoneNumber': phoneNumber,
                'personalId': personalId
            };
            return $.ajax({method: "POST", url: url, data: parameter});
        },


        unloadKlarnaWidget: function () {
            $('#mopt_payone__klarna_payments_widget_container').empty();
        },

        loadKlarnaWidget: function (paymentType, accessToken) {
            var me = this;

            if (!accessToken || accessToken.length === 0) {
                return;
            }

            if (!window.Klarna) {
                return;
            }

            window.Klarna.Payments.init({
                client_token: accessToken
            });

            return $.Deferred(function (defer) {
                window.Klarna.Payments.load({
                    container: '#mopt_payone__klarna_payments_widget_container',
                    payment_method_category: me.payTypeTranslations[paymentType]
                }, function (res) {
                    defer.resolve();
                });
            }).promise();
        }
    });
})(jQuery, window);
