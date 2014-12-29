(function(){
	var Router = can.Control.extend({
		'init': function(){
			console.log("Cargo")
		},
		'route' : function(){
			can.route.attr({
				route: 'principal'
			},true);
		}
	});

	$(document).ready(function(){
		Controllers.Auth = new Controllers.Auth($('body'));
		new Router($('body'));
		can.route.ready();
	});
}());