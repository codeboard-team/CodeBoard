"use strict";

require("stylesheets/application");

require("channels/editor");

require("plugin/ace");

require("plugin/emmet");

require("plugin/ext-emmet");

var _jquery = _interopRequireDefault(require("jquery"));

require("popper.js");

require("bootstrap");

require("font-awesome/css/font-awesome.min.css");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("@rails/ujs").start();

require("turbolinks").start();

require("@rails/activestorage").start();

require("channels"); // Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
// tailwind.config.js


window.$ = window.jquery = _jquery["default"];