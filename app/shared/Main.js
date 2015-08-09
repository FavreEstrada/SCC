(function() {
	var app = angular.module('SCC', ['ngRoute', 'SCC.controllers', 'SCC.directives']);
	app.config(['$routeProvider', function($routeProvider) {
		$routeProvider.when('/crearCliente', {
			templateUrl: 'app/components/controllers/CrearCliente.html',
			controller: 'crearClienteCtrl',
			controllerAs: "client"
		});
		$routeProvider.when('/clientes', {
			templateUrl: 'app/components/controllers/ListaClientes.html',
			controller: 'listaClienteCtrl',
			controllerAs: "listClients"
		});
		$routeProvider.otherwise({
			redirectTo: '/menu'
		});
	}]);
}(this));