angular.module('SCC', ['ngRoute'])
	.config(['$routeProvider', function($routeProvider) {
		$routeProvider.when('/crearCliente', {
			templateUrl: 'app/pages/CrearCliente.html',
			controller: 'crearCliente_ctrl',
			controllerAs: "client"
		})
		.when('/clientes', {
			templateUrl: 'app/pages/ListaClientes.html',
			controller: 'listaClientes_ctrl',
			controllerAs: "listClients"
		}).when('/login', {
			templateUrl: 'app/pages/Login.html',
			controller: 'login_ctrl'
		}).when('/crearSolicitud', {
			templateUrl: 'app/pages/solicitudRechazada.html',
			controller: 'solicitudRechazada_ctrl'
		})
		.otherwise({
			redirectTo: '/login'
		});
	}]);