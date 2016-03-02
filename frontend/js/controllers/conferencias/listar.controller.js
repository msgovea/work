app.controller('ListarConferenciasController', ["ConferenciaService","$scope", "$http",'$state','$uibModal', '$log', 'conferenciaArray', 'toastr',
function(ConferenciaService, $scope, $http, $state, $uibModal, $log, conferenciaArray, toastr){
  'use strict';

  $scope.eventos = "";
  $scope.alert = ConferenciaService.alert;
  $scope.exibir = false;

  // alerts
  $scope.alerts = [];

  $scope.addAlert = function(alert) {
    $scope.alerts.push(alert);
  }; 

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  };

  if ($scope.alert) {
    $scope.addAlert($scope.alert);
    ConferenciaService.alert = null;
  }

  $scope.conferencias = null;

  if (2 == 2) {
	  console.log('oi');
    $scope.conferencias = conferenciaArray;
  } else{
    toastr.error('Ops, ocorreu algum erro ao listar os eventos.', 'Eventos', {
      closeButton: true,
      onShown: function(){
        $state.go('login');
      }
    })
  }

  $scope.deletarEvento = function(id) {
    if (confirm('Deseja excluir esse evento?')){
    	ConferenciaService.deleteEvento(id).then(function(response){
        toastr.success(response.message, 'Eventos', {
          closeButton: true,
          onShown: function(){
        	  ConferenciaService.initEventos().then(function(response) {
              $scope.events = response;
            }).catch(function(error) {
              console.log('Erro ao deletar evento: ', error);
            });
          }
        })
        }).catch(function(error){
          console.log('Erro ao deletar evento: ', error);
        });
    }
  };

          $scope.editaDados = function(event){
        	  ConferenciaService.setEvento(event);
            $state.go("conferencia.editar");
          }


          // AQUI COMEÇA MODAL
          // $uibModal para usar o modal

          $scope.open = function (event, size) {

            var modalInstance = $uibModal.open({
              animation: true,
              templateUrl: 'views/modal/confirmDelete.html',
              controller: 'ConfirmDeleteModalController',
              size: size,
              resolve: {
                event: function () {
                  return event;
                }
              }
            });

            modalInstance.result.then(function () {
              $scope.removeEvent(event);
            }, function () {
              $log.info('Modal dismissed at: ' + new Date());
            });
          };
        }]);
