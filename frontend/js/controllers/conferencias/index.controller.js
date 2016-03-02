app.controller('ConferenciaController', ["ConferenciaService", '$cookieStore', '$scope', '$rootScope', '$state', '$http', function (ConferenciaService, $cookieStore ,$rootScope, $scope, $state, $http) {
    'use strict';


    $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
        if(toState.name === 'conferencia.editar'){
            $scope.tabs[0].active = false;
        }
    });

    $scope.tabs = [
        { state: 'main', title:'Main' },
        { state: 'conferencia.listar', title:'Listar Conferências', active:'true' },
        { state: 'conferencia.cadastrar', title:'Cadastrar Conferência' }
    ];




}]);
