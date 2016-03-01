app.controller('MainController', ["EventosService", '$cookieStore', '$scope', '$rootScope', '$state', '$http', function (EventosService, $cookieStore ,$rootScope, $scope, $state, $http) {
    'use strict';


    $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
    });

    $scope.tabs = [
        { state: 'evento.listar', title:'Eventos' },
    ];


}]);