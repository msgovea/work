app.controller('LoginController', ['$scope', '$state','$cookies', function($scope, $state, $cookies){
    'use strict';

    $scope.messageLogin = null;

    $scope.loginApp = function(login) {


      if (login == null) {
        $scope.messageLogin = "Digite e-mail e senha";
      } else if (login.email == null) {
        $scope.messageLogin = "Digite um e-mail válido";
      } else if (login.password == null) {
        $scope.messageLogin = "Digite uma senha";
      } else if (login.email.split('@').pop() != 'ciandt.com') {
        $scope.messageLogin = "É necessário utilizar um e-mail @ciandt.com";
      } else if (login.password.length < 6) {
        $scope.messageLogin = "Senha deve conter ao menos 6 caracteres";
      } else {
          //cookies
          var expireDate = new Date();
          expireDate.setDate(expireDate.getDate() + 1);
          $cookies.put('user',login.email,{'expires' :expireDate});
          $state.go("main");
      }
    }



}]);
