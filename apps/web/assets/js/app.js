// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

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
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Alpine from "alpinejs"
import { Loader } from "@googlemaps/js-api-loader"

let Hooks = {}

Hooks.Map = {
    search_address_lat_lng() { return JSON.parse(this.el.dataset.search_address_lat_lng) },
    addresses() { return JSON.parse(this.el.dataset.addresses) },
    initMap() {
        const myLatLng = { lat: 37.0902, lng: -95.7129 };
        const map = new google.maps.Map(document.getElementById("map"), {
            zoom: 4,
            center: myLatLng,
        });
        console.log(this.addresses().length)
        this.addresses().forEach(element => {
            const contentString =
                `<h1>${element.name}</h1>
                <p>Stage: ${element.dealstage}</p>
                <p>Closed: ${element.closedate}</p>
                <p>Hubspot: <a href=${element.hubspot_link}>${element.hubspot_link}</a></p>`;
            const infowindow = new google.maps.InfoWindow({
                content: contentString,
            });
            const marker = new google.maps.Marker({
                position: { lat: element.lat, lng: element.lon },
                map,
                icon: element.dealstage == "System On" ? "https://skycrm.live/assets/images/skyline_map_pin_red.png" : "https://skycrm.live/assets/images/skyline_map_pin_white.png"
            });
            marker.addListener("click", () => {
                infowindow.open({
                    anchor: marker,
                    map,
                    shouldFocus: false,
                });
            });

        });
    },
    searchMap() {
        const myLatLng = this.search_address_lat_lng();
        const map = new google.maps.Map(document.getElementById("map"), {
            zoom: 18,
            center: myLatLng,
        });
        const searched_infowindow = new google.maps.InfoWindow({
            content: `Your lovely home, looking to get solar panels!`,
        });
        const searched_address = new google.maps.Marker({
            position: myLatLng,
            map,
            icon: "https://skycrm.live/assets/images/skyline_map_pin_green.png"
        })
        searched_infowindow.open({
            anchor: searched_address,
            map,
            shouldFocus: false,
        });
        searched_address.addListener("click", () => {
            searched_infowindow.open({
                anchor: searched_address,
                map,
                shouldFocus: false,
            });
        });
        console.log(this.addresses().length)
        this.addresses().forEach(element => {
            const contentString =
                `<h1>${element.name}</h1>
                <p>Stage: ${element.dealstage}</p>
                <p>Closed: ${element.closedate}</p>
                <p>Hubspot: <a href=${element.hubspot_link}>${element.hubspot_link}</a></p>`;
            const infowindow = new google.maps.InfoWindow({
                content: contentString,
            });
            const marker = new google.maps.Marker({
                position: { lat: element.lat, lng: element.lon },
                map,
                icon: element.dealstage == "System On" ? "https://skycrm.live/assets/images/skyline_map_pin_red.png" : "https://skycrm.live/assets/images/skyline_map_pin_white.png"
            });
            marker.addListener("click", () => {
                infowindow.open({
                    anchor: marker,
                    map,
                    shouldFocus: false,
                });
            });

        });
    },
    mounted() {
        window.initMap = this.initMap();
    },
    updated() {
        this.searchMap()
    }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// Assign and start alpinejs
window.Alpine = Alpine
Alpine.start()

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

