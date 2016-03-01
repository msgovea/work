app.controller('CadastrarEventosController', ["EventosService", '$scope', '$rootScope', '$state', '$http', 'toastr', function (EventosService, $rootScope, $scope, $state, $http, toastr) {
    'use strict';

    $scope.messageCad = null;
    $scope.status = null;

    $scope.funcao = "";
    if (EventosService.getEvento() == null) {
        $scope.funcao = "cadastro";
    } else {
        $scope.funcao = "edicao";
        $scope.event = EventosService.getEvento();
    }


    $scope.cadastrarEvento = function (event) {

        if (event == null) {
            $scope.messageCad = "Faltam dados";
        } else {
            $scope.postEvent(event);
        }

    }


    $scope.postEvent = function(event) {
      EventosService.cadastroEvento(event).then(function(response){
        toastr.success(response.message, 'Eventos', {
          closeButton: true,
          onShown: function(){
              $scope.event = {};
          }
          })
        }).catch(function(error){
          toastr.error('Ops, ocorreu algum erro ao cadastrar o evento.', 'Eventos', {
            closeButton: true
          })
        })
    };

    $scope.updateEvent = function (event) {
        $scope.loading = true;

        $http.post('http://endpoint.amoremcartas.com.br/update/', JSON.stringify(event)).then(function (response) {
            $scope.result = response.data;
            $scope.loading = false;
            $scope.event = [];
            EventosService.alert = {type: 'success', msg: 'Evento editado com sucesso!'};
            $state.go('evento.listar');
        }).catch(function (error) {
            $scope.result = error;
            $scope.loading = false;
            $scope.status = $scope.result.statusRequest;
        });
    }

    $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
        if (EventosService.getEvento() != null) {
            EventosService.limpar();
            $scope.event = null;
        }
        if (toState.name == 'evento.cadastrar') {

        }
    });


}]);
