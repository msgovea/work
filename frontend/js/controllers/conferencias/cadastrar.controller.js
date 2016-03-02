app.controller('CadastrarConferenciaController', ["ConferenciaService", '$scope', '$rootScope', '$state', '$http', 'toastr', function (ConferenciaService, $rootScope, $scope, $state, $http, toastr) {
    'use strict';

    $scope.messageCad = null;
    $scope.status = null;

    $scope.funcao = "";
    if (ConferenciaService.getEvento() == null) {
        $scope.funcao = "cadastro";
    } else {
        $scope.funcao = "edicao";
        $scope.event = ConferenciaService.getEvento();
    }


    $scope.cadastrarEvento = function (event) {

        if (event == null) {
            $scope.messageCad = "Faltam dados";
        } else {
            $scope.postEvent(event);
        }

    }


    $scope.postEvent = function(event) {
    	ConferenciaService.cadastroEvento(event).then(function(response){
        toastr.success(response.message, 'Eventos', {
          closeButton: true,
          onShown: function(){
              $scope.event = {};
          }
          })
        }).catch(function(error){
          toastr.error('Ops, ocorreu algum erro ao cadastrar a conferência.', 'Conferencias', {
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
            toastr.success('Conferencia editada com sucesso!', 'Conferencia', {
                closeButton: true,
                onShown: function(){
                  $state.go('conferencia.listar');
                }
            })
        }).catch(function (error) {
            $scope.result = error;
            $scope.loading = false;
            $scope.status = $scope.result.statusRequest;
        });
    }

    $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
        if (ConferenciaService.getEvento() != null) {
        	ConferenciaService.limpar();
            $scope.event = null;
        }
        if (toState.name == 'conferencia.cadastrar') {

        }
    });


}]);
