(function(namespace, undefined){
	'use strict';
	var Auth = can.Control.extend({
		defaults: {
			user: "",
			pass: ""
		},
		'init': function(element, options){
			var self = this;
			$(element).find("#content").append(can.view("views/Main/Authentication.mustache"));
		},	
		'#logIn click': function(el, ev){
			var self = this;
			self.options.user = $("#usr_name").val();
			self.options.pass = $("#usr_pass").val();
		}
	});

	namespace.Controllers =namespace.Controllers || {};
	namespace.Controllers.Auth = Auth;
}(this));