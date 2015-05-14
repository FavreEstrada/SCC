(function(){
var ctrls = angular.module('SCC.controllers',[]);
	ctrls.controller('mainCtrl', function($scope) {
		var self = this;
	});
}(this));;(function() {
	var dir = angular.module('SCC.directives', []);
	dir.directive('menu', function($timeout) {
		return {
			restrict: "E",
			templateUrl: "app/components/directives/Menu.html",
			controller: function() {
				var self = this;
				self.menu = {
					left: [{
						name: "Clientes",
						options: [{
							name: "Crear Cliente",
							link: "#/crearCliente"
						}, {
							name: "Busqueda de Clientes",
							link: "#/clientes"
						}, {
							name: "Crear Solicitud Rechazada",
							link: "#/crearSolicitud"
						}]
					}, {
						name: "Cobros",
						options: [{
							name: "Lista de Cobros",
							link: "#/cobros"
						}]
					}, {
						name: "Reportes",
						options: [{
							name: "DashBoards",
							link: "#/dashboards"
						}, {
							name: "Lista de Clientes",
							link: "#/clientes"
						}, {
							name: "Solicitudes Rechazadas",
							link: "#/solicitudes"
						}, {
							name: "Órdenes",
							link: "#/ordenes"
						}]
					}, {
						name: "Parametrización",
						options: [],
						link: "#/configuracion"
					}]
				};
				$timeout(function() {
					$('.dropdown-toggle').dropdown();
					$(".no-menu").removeAttr("data-toggle");
				});

			},
			controllerAs: "menuCtrl"
		};
	});
}(this));;(function() {
	var app = angular.module('SCC', ['ngRoute', 'SCC.controllers', 'SCC.directives']);
	app.config(['$routeProvider', function($routeProvider) {
		$routeProvider.when('/menu', {
			templateUrl: 'app/components/directives/menu.html',
			controller: 'menuCtrl'
		});
		$routeProvider.when('/crearCliente', {
			templateUrl: 'menu.html',
			controller: 'menuCtrl'
		});
		$routeProvider.otherwise({
			redirectTo: 'principal'
		});
	}]);
}(this));