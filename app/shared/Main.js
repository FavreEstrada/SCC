(function() {
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