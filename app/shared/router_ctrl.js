angular.module('SCC', ['ngRoute', 'angular-md5', 'toaster'])
	.config(['$routeProvider', function($routeProvider) {
		$routeProvider
			.when('/crearCliente', {
				templateUrl: 'app/pages/CrearCliente.html',
				controller: 'crearCliente_ctrl'
			})
			.when('/crearCliente/:id', {
				templateUrl: 'app/pages/CrearCliente.html',
				controller: 'crearCliente_ctrl'
			})
			.when('/clientes', {
				templateUrl: 'app/pages/ListaClientes.html',
				controller: 'listaClientes_ctrl'
			}).when('/cobros', {
				templateUrl: 'app/pages/ListaCobro.html',
				controller: 'listaCobro_ctrl'
			}).when('/login', {
				templateUrl: 'app/pages/Login.html',
				controller: 'login_ctrl'
			}).when('/crearSolicitud', {
				templateUrl: 'app/pages/solicitudRechazada.html',
				controller: 'solicitudRechazada_ctrl'
			}).when('/reporteCobros', {
				templateUrl: 'app/pages/reporteCobros.html',
				controller: 'reporteCobros_ctrl'
			}).when('/dashboards', {
				templateUrl: 'app/pages/dashboard.html',
				controller: 'dashboard_ctrl'
			}).when('/parametrizacion', {
				templateUrl: 'app/pages/parametrizacion.html',
				controller: 'parametrizacion_ctrl'
			})
			.otherwise({
				redirectTo: '/login'
			});
	}]);