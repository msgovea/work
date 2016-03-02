var app = angular
		.module('CitEventos', [ 'ngCookies', 'ngAnimate', 'ui.router',
				'ui.mask', 'ui.bootstrap', 'angular-loading-bar', 'toastr',
				'UserApp' ]);

app.config(
		[
				'$stateProvider',
				'$urlRouterProvider',
				function($stateProvider, $urlRouterProvider) {
					'use strict';

					// caso não encontrar nenhuma rota
					$urlRouterProvider.otherwise(function($injector, $location,
							$rootScope) {
						var $state = $injector.get("$state");
						$state.go("main");
					});

					// rotas app
					$stateProvider.state('login', {
						url : '/login',
						templateUrl : 'views/login.view.html',
						controller : 'LoginController',
						data : {
							login : true
						}
					}).state('main', {
						url : '/',
						templateUrl : 'views/main.view.html',
						controller : 'MainController'
					}).state('evento', {
						url : '/evento',
						templateUrl : 'views/eventos/index.view.html',
						controller : 'EventoController'
					}).state('evento.listar', {
						url : '/listar-eventos',
						templateUrl : 'views/eventos/listar.view.html',
						controller : 'ListarEventosController',
						resolve : {
							eventosArray : function(EventosService) {
								return EventosService.initEventos();
							}
						}
					}).state('evento.cadastrar', {
						url : '/cadastrar-evento',
						templateUrl : 'views/eventos/cadastrar.view.html',
						controller : 'CadastrarEventosController'
					}).state('evento.editar', {
						url : '/editar-evento',
						templateUrl : 'views/eventos/cadastrar.view.html',
						controller : 'CadastrarEventosController'
					}).state('conferencia', {
						url : '/conferencia',
						templateUrl : 'views/conferencias/index.view.html',
						controller : 'ConferenciaController'
					}).state('conferencia.listar', {
						url : '/listar-conferencia',
						templateUrl : 'views/conferencias/listar.view.html',
						controller : 'ListarConferenciasController',
						resolve : {
							conferenciaArray : function(ConferenciaService) {
								return ConferenciaService.initConferencia();
							}
						}
					}).state('conferencia.cadastrar', {
						url : '/cadastrar-conferencia',
						templateUrl : 'views/conferencias/cadastrar.view.html',
						controller : 'CadastrarConferenciaController'
					}).state('conferencia.editar', {
						url : '/editar-conferencia',
						templateUrl : 'views/conferencias/cadastrar.view.html',
						controller : 'CadastrarConferenciaController'
					});

				} ])

.run(
		[ '$http', '$cookies', '$state', 'toastr', '$rootScope', 'user',
				function($http, $cookies, $state, toastr, $rootScope, user) {
					user.init({
						appId : '56c2f0dfa8eba'
					});
					/*
					 * $rootScope.$on('$stateChangeStart', function (event,
					 * toState, toParams, fromState, fromParams) { var cookie =
					 * $cookies.get('user'); if (cookie == undefined &&
					 * toState.name != 'login'){ toastr.warning('Para acessar
					 * este sistema você precisa estar logado!', 'Eventos', {
					 * closeButton: true, onShown: function(){
					 * $state.go("login"); } }) }
					 * 
					 * });
					 */
				} ]);
