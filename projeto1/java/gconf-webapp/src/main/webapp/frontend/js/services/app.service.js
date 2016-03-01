app.service('EventosService', ['$http', '$q', function($http, $q){

  var editar = [];
  var eventoRecebido = null;

  editar.alert = null;

  editar.initEventos = function(){
    var deffered = $q.defer();

    $http.get('http://endpoint.amoremcartas.com.br/list/')
    .success(function(data, status, headers, config){
      deffered.resolve(data);
    })
    .error(function(data, status, headers, config){
      deffered.reject(data);
    });

    return deffered.promise;
  };

  editar.deleteEvento = function(id){
    var deffered = $q.defer();

    $http.post('http://endpoint.amoremcartas.com.br/delete/', JSON.stringify(id))
    .success(function(data, status, headers, config){
      deffered.resolve(data);
    })
    .error(function(data, status, headers, config){
      deffered.reject(data);
    });

    return deffered.promise;
  };

  editar.cadastroEvento = function(event){
    var deffered = $q.defer();

    $http.post('http://endpoint.amoremcartas.com.br/insert/', JSON.stringify(event))
    .success(function(data, status, headers, config){
      deffered.resolve(data);
    })
    .error(function(data, status, headers, config){
      deffered.reject(data);
    });

    return deffered.promise;
  };



  editar.getEvento = function(){
    return eventoRecebido;
  };

  editar.setEvento = function(event){
    eventoRecebido = event;
  };

  editar.limpar = function(){
    eventoRecebido = null;
    return eventoRecebido;
  };

  return editar;

}]);
