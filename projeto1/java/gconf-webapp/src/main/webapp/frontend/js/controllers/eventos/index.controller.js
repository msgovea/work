app.controller('EventoController', ["EventosService", '$cookieStore', '$scope', '$rootScope', '$state', '$http', function (EventosService, $cookieStore ,$rootScope, $scope, $state, $http) {
    'use strict';


    $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
        if(toState.name === 'evento.editar'){
            $scope.tabs[0].active = false;
        }
    });

    $scope.tabs = [
        { state: 'main', title:'Main' },
        { state: 'evento.listar', title:'Listar Eventos', active:'true' },
        { state: 'evento.cadastrar', title:'Cadastrar Evento' }
    ];




}]);
