import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
  };

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v12", // style URL
    });

    const eventSource = this.#initializedata();

    this.map.on("load", () => {
      this.map.addSource("events", eventSource);

      this.map.addLayer({
        id: "events",
        type: "circle",
        source: "events",
        // paint: {
        //   "circle-color": "#4264fb",
        //   "circle-radius": 6,
        //   "circle-stroke-width": 2,
        //   "circle-stroke-color": "#ffffff",
        // },
      });

      this.#addMarkers(eventSource);
      this.#fitMarkers(eventSource);
      this.#createPopEvent()
      this.#clearmarker();
    });
  }

  // Functions =======
  #initializedata() {
    //Create a source for for events
    // Initialize geoJSON
    let eventSource = {
      type: "geojson",
      data: {
        type: "FeatureCollection",
      },
    };
    // Map all the features for all events
    const features = this.markersValue.map((event) => {
      const eventObj = JSON.parse(event.event);
      return {
        type: "Feature",
        properties: {
          description: event.info_window,
        },
        geometry: {
          type: "Point",
          coordinates: [event.lng, event.lat],
        },
      };
    });
    // Complete cource by adding the features data into source
    eventSource.data.features = features;
    return eventSource;
  }

  #addMarkers(eventSource) {
    let index = 0;
    eventSource.data.features.forEach((marker) => {
      console.log(marker.geometry.coordinates);
      const customMarker = document.createElement("div");
      customMarker.classList.add("marker");
      customMarker.dataset.mapKey = "m";
      customMarker.dataset.id = index;

      index = index + 1;

      // Pass the element as an argument to the new marker
      new mapboxgl.Marker(customMarker)
        .setLngLat(marker.geometry.coordinates)
        .addTo(this.map);
    });
  }

  #fitMarkers(eventSource) {
    const bounds = new mapboxgl.LngLatBounds();
    eventSource.data.features.forEach((marker) =>
      bounds.extend(marker.geometry.coordinates)
    );
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 12, duration: 800 });
  }

  #createPopEvent() {
    this.popup = new mapboxgl.Popup({
      closeButton: true,
      closeOnClick: false,
    });

    this.map.on("mouseover", "events", (e) => {
      // Change the cursor style as a UI indicator.
      this.map.getCanvas().style.cursor = "pointer";
      // Copy coordinates array.
      const coordinates = e.features[0].geometry.coordinates.slice();
      const description = e.features[0].properties.description;

      while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
        coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
      }
      console.log(e);

      this.popup.setLngLat(coordinates).setHTML(description).addTo(this.map);
      const customMarkers = document.querySelectorAll(".marker");
      if (e.originalEvent.target.classList.contains("marker")) {
        customMarkers.forEach((m) => m.classList.remove("marker-update"));
      }
    });

    this.map.on("mouseleave", "events", (e) => {
      this.map.getCanvas().style.cursor = "";
      if (!e.originalEvent.target.classList.contains("marker-update")) {
        this.popup.remove();
      }
    });

    this.map.on("click", "events", (e) => {
      this.map.getCanvas().style.cursor = "pointer";

      const coordinates = e.features[0].geometry.coordinates.slice();
      const description = e.features[0].properties.description;

      while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
        coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
      }

      this.popup.setLngLat(coordinates).setHTML(description).addTo(this.map);

      const customMarkers = document.querySelectorAll(".marker");
      customMarkers.forEach((m) => m.classList.remove("marker-update"));
      e.originalEvent.target.classList.add("marker-update");
      const getId = e.originalEvent.target.dataset.id;
      console.log(getId);
      const getscrollEls = document.querySelectorAll(".event-container.active");
      getscrollEls.forEach((getscrollEl)=> {
        getscrollEl.classList.remove('active')
      })
      const getscrollEl = document.getElementById(`event_${getId}`);
      getscrollEl.classList.add('active')
      this.#scroll(getscrollEl);
    });

    this.map.on("mousemove", (e) => {
      if (this.map._popups == 0) {
        const customMarkers = document.querySelectorAll(".marker");
        customMarkers.forEach((m) => m.classList.remove("marker-update"));
      }
    });
  }

  #clearmarker() {
    window.addEventListener("click", (e) => {
      if (e.target.dataset.mapKey != "m") {
        const customMarkers = document.querySelectorAll(".marker");
        customMarkers.forEach((m) => {
          m.classList.remove("marker-update");
        });
        //Remove pop up
        if (this.map._popups != 0) {
          this.map._popups[0].remove();
        }
        //Remove event container border
        const getscrollEls = document.querySelectorAll(".event-container.active");
        getscrollEls.forEach((getscrollEl)=> {
          getscrollEl.classList.remove('active')
        })

      }
    });
  }

  #scroll(el) {
    console.log("scroll element", el);
    el.scrollIntoView({ behavior: "smooth" });
  }
  //=======================old functions=======================

  #addMarkersToMap() {
    let index = 0;
    this.markersValue.forEach((marker) => {
      this.popup = new mapboxgl.Popup().setHTML(marker.info_window);

      const customMarker = document.createElement("div");
      customMarker.classList.add("marker");
      customMarker.dataset.mapKey = "m";
      customMarker.dataset.id = index;
      index = index + 1;

      // Pass the element as an argument to the new marker
      new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(this.popup)
        .addTo(this.map);

      // customMarker.className = "marker"
      // customMarker.style.backgroundImage = `url('${marker.image_url}')`
      // customMarker.style.backgroundImage = `url(bluemarker.png)`
      // customMarker.style.backgroundSize = "contain"
      // customMarker.style.width = "25px"
      // customMarker.style.height = "25px"

      // new mapboxgl.Marker()
      // .setLngLat([ marker.lng, marker.lat ])
      // .setPopup(popup)
      // .addTo(this.map)
    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach((marker) =>
      bounds.extend([marker.lng, marker.lat])
    );
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 12, duration: 1500 });
  }

  #styleMarkers() {
    const customMarkers = document.querySelectorAll(".marker");
    customMarkers.forEach((mark) => {
      mark.addEventListener("click", (e) => {
        const customMarkers = document.querySelectorAll(".marker");
        customMarkers.forEach((m) => m.classList.remove("marker-update"));
        e.target.classList.add("marker-update");
        const getId = e.target.dataset.id;
        console.log(getId);
        const getscrollEl = document.getElementById(`event_${getId}`);
        this.#scroll(getscrollEl);
      });
    });
  }
}
