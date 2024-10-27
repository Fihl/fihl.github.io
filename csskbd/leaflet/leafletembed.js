	var map;
	var ajaxRequest;
	var plotlist;
	var plotlayers=[];
	var popup;

	var fixedStuff;
	var biler;
	var redLining;
	var leafletTimer;

	function GetXmlHttpObject() {
		if (window.XMLHttpRequest) { return new XMLHttpRequest(); }
		if (window.ActiveXObject)  { return new ActiveXObject("Microsoft.XMLHTTP"); }
		return null;
	}

	function onMapMove() {
		clearInterval(leafletTimer);
		// leafletTimer = setTimeout(askForPlots, 1000);  //Very soon now
	}
	function askForPlots() {
		clearInterval(leafletTimer);
		// leafletTimer = setTimeout(askForPlots, 10000);  //Almost stop leafletTimer
		// var bounds=map.getBounds();
		// var minll=bounds.getSouthWest();
		// var maxll=bounds.getNorthEast();
		// var bbox='bbox='+minll.lng+','+minll.lat+','+maxll.lng+','+maxll.lat;
		// //var msg='JSON1.txt?format=leaflet&bbox='+minll.lng+','+minll.lat+','+maxll.lng+','+maxll.lat;
		// ajaxRequest.onreadystatechange = stateChanged; 
		// //var msg = 'http://localhost/RegionJSON?'+bbox;  //BBOX=9.63,56.89,10.2,57.9';
		// var msg = '/RegionJSON?'+bbox;  //BBOX=9.63,56.89,10.2,57.9';
		// ajaxRequest.open('GET', msg , true);
		// ajaxRequest.send(null); 
	}

	function stateChanged() {
		if (ajaxRequest.readyState==4) {
			if (ajaxRequest.status==200) {
				try {
				    plotlist=JSON.parse(ajaxRequest.responseText);
			    	removeMarkers();
				    for (i=0;i<plotlist.length;i++) {
				    	var lat=plotlist[i].lat, lon=plotlist[i].lon;
						var plotll = new L.LatLng(lat,lon, true);
						var plotmark = new L.Marker(plotll);
						//plotmark.data=plotlist[i];
						plotmark.bindPopup("<h3>"+plotlist[i].name+"</h3>");  ///+plotlist[i].details);
						biler.addLayer( plotmark );
						plotlayers.push(plotmark);
					}
				}
				catch(err) {
			    	console.log( err );
				}
			}
			// clearInterval(leafletTimer);
			// leafletTimer = setTimeout(askForPlots, 2000); 
		}
	}

	function removeMarkers() {
		for (i=0;i<plotlayers.length;i++) {
			map.removeLayer(plotlayers[i]);
		}
		plotlayers=[];
		//biler.clearLayers;
	}

	function onMapClick(e) {
		var latlngStr = '(' + e.latlng.lat.toFixed(3) + ', ' + e.latlng.lng.toFixed(3) + ')';
		popup.setLatLng(e.latlng);
		popup.setContent("Et sted " + latlngStr);
		/* map.openPopup(popup); */
		removeMarkers(); 
	}

	function initmap() {
		// set up the AJAX stuff
		ajaxRequest=GetXmlHttpObject();
		if (ajaxRequest==null) {
			alert ("This browser does not support HTTP Request");
			return;
		}
		<!-- http://switch2osm.org/using-tiles/getting-started-with-leaflet/ -->
		<!-- http://www.plotbrowser.com/?map -->

		var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
		var osmAttrib='&copy;<a href="http:www.innovative.dk">IBS</a> Coding -- Map data <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
		var osm = new L.TileLayer(osmUrl, {minZoom: 7, maxZoom: 18, attribution: osmAttrib} );

		var markerLocation = new L.LatLng( 55.68242, 12.577361),
			marker = new L.Marker(markerLocation);
		marker.bindPopup("<b>IBS</b><br />Landem�rket 10").openPopup();


		var circleLocation = new L.LatLng(55.77, 12.17),
			circleOptions = {color: '#f03', opacity: 0.7},
			circle = new L.Circle(circleLocation, 500, circleOptions);

		circle.bindPopup("Christen bor her");

		var p1 = new L.LatLng(55.7, 12.15),
			p2 = new L.LatLng(55.7, 12.2),
			p3 = new L.LatLng(55.72, 12.15),
			polygonPoints = [p1, p2, p3],
			polygon = new L.Polygon(polygonPoints);

		polygon.bindPopup("Redlining");
		

		// set up the map
		map = new L.Map('map');
		//map.setView(new L.LatLng(55.75, 12.35), 11);
		map.setView(new L.LatLng(56.20, 10.50), 7);
		//map.addLayer(osm);

		biler = new L.LayerGroup();
		///biler.addLayer( new L.Marker( new L.LatLng(55.721480,9.567180) ) );
		//biler.addLayer( new L.Marker( new L.LatLng(55.732660,9.558950) ) );

		fixedStuff = new L.LayerGroup();
		fixedStuff.addLayer(marker);
		fixedStuff.addLayer(circle);

		redLining = new L.LayerGroup();
		redLining.addLayer(polygon);

		map.addLayer(osm)  .addLayer(fixedStuff)  .addLayer(biler)  .addLayer(redLining);

		var OverlaysMenu = {
		    "Biler": biler,
		    "Mine faste ting": fixedStuff,
		    //"Test2": marker,
		    //"Test3": polygon,
		    "Redlining": redLining         //polygon ogs� tilladt
		};
		layersControl = new L.Control.Layers(null, OverlaysMenu);	//null for basemap
 		map.addControl(layersControl);

		popup = new L.Popup();

		map.on('moveend', onMapMove);
		map.on('click', onMapClick);
		askForPlots();
	}

