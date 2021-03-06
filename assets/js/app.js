// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"

let Hooks = {}

// Hook for the Fullcalendar demo
Hooks.FullCalendar = {
  mounted() {
    calendar = new FullCalendar.Calendar(this.el, { events: '/events' });
    calendar.render();
  }
}

// Hook for the focus demo
Hooks.FocusOnMount = {
  mounted() {
    this.el.focus()
  }
}

// Hook for the file explorer demo
Hooks.ArrowKeyEvents = {
  mounted() {
    document.addEventListener('keydown', (event) => {
      this.pushEvent("keydown", {key: event.key});
    }, false);
  }
}

Hooks.GetGeolocation = {
  mounted() {
    navigator.geolocation.getCurrentPosition((position) => {
      this.pushEvent("position", {lat: position.coords.latitude, long: position.coords.longitude});
    });
  }
}

// Hook for the Sheet JS demo
Hooks.SheetJS = {
  mounted() {
    window.addEventListener("rows_added", (event) => {
      this.pushEvent("rows_added", event.detail);
    })
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


window.addEventListener("display-block", e => e.target.style.display = 'block')
window.addEventListener("display-none", e => e.target.style.display = 'none')
window.addEventListener("trigger-change", e => e.target.querySelectorAll("input,textarea,select")[1].dispatchEvent(new Event("input", {bubbles: true})))
