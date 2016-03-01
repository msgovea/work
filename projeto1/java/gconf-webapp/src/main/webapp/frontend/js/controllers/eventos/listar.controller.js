app.controller('ListarEventosController', ["EventosService","$scope", "$http",'$state','$uibModal', '$log', 'eventosArray', 'toastr',
function(EventosService, $scope, $http, $state, $uibModal, $log, eventosArray, toastr){
  'use strict';

  //  $scope.events = [];
  $scope.eventos = "";
  $scope.alert = EventosService.alert;

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
    EventosService.alert = null;
  }

  $scope.events = null;

  if (eventosArray.status){
    $scope.events = eventosArray.eventos;
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
      EventosService.deleteEvento(id).then(function(response){
        toastr.success(response.message, 'Eventos', {
          closeButton: true,
          onShown: function(){
            EventosService.initEventos().then(function(response) {
              $scope.events = response.eventos;
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
            EventosService.setEvento(event);
            $state.go("evento.editar");
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
