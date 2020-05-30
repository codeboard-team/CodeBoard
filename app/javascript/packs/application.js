// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// jquery
import 'jquery'
import $ from 'jquery'
window.$ = window.jquery = $
import 'popper.js'

// font-awesome
import 'font-awesome/css/font-awesome.min.css'

// tailwind.config.js
import "stylesheets/application"

//bootstrap
// import 'bootstrap'
// import 'bootstrap/dist/css/bootstrap.min.css'

// page style by HELB
import "pages/cards"

// select2

import 'select2'
import 'select2/dist/css/select2.min.css'

//sweetalert2
import Swal from 'sweetalert2'
window.Swal = Swal