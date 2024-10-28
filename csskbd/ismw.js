  var queue;
  var base;
  var panels;
  var ajaxRequest;
  var ismLocation;
  var aSyncTimer;

  function GetXmlHttpObject() {
    if (window.XMLHttpRequest) { return new XMLHttpRequest(); }
    if (window.ActiveXObject)  { return new ActiveXObject("Microsoft.XMLHTTP"); }
    return null;
  }

  function panelMenuClick(myself) {
    console.log( myself);
    // sendCmd('/MenuChoice?Tab='+myself); 
    event.preventDefault();
  }
  function mainMenuClick(myself) {
    console.log( myself);
    // sendCmd('/Menu?Val2='+myself); 
    if (myself='000103') {
      map.setView(new L.LatLng(56.50, 10.50), 7);
    }
    event.preventDefault();
  }

  function qclick(myself,txt) {
    console.log(txt);
    // sendCmd(txt);
    //console.log(myself.href);
    //console.log(this.href);
    //myself.style.color = "red";
    event.preventDefault();
  }

  function sendCmd(msg) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        console.log(this.responseText);
      }
    };
    // xhttp.open("GET", msg, true);
    // xhttp.send();

    // $("#menu").html( "sendCmd " + msg );
    // console.log( "sendCmd " + msg );
    // ajaxRequest.onreadystatechange = stateChanged; 
    // ajaxRequest.open('GET', msg, true);
    // ajaxRequest.send(null); 
  }

  function stateChanged() {
    if (ajaxRequest.readyState==4) {
      if (ajaxRequest.status==200) {
      plotlist=eval('(' + ajaxRequest.responseText + ')');
        // [ {"name":"Et sted", "lon":"12.24", "lat":"55.75", "details":"Christen Fihl"} ]
        //plotlist=eval('( [ {"name":"Et sted i landet", "lon":"12.24", "lat":"55.75", "details":"Forsvinder ved klik!!"} ] )');
        removeMarkers();
        for (i=0;i<plotlist.length;i++) {
          var plotll = new L.LatLng(plotlist[i].lat,plotlist[i].lon, true);
          var plotmark = new L.Marker(plotll);
          plotmark.data=plotlist[i];
          /// queue.addLayer(plotmark);
          plotmark.bindPopup("<h3>"+plotlist[i].name+"</h3>"+plotlist[i].details);
          plotlayers.push(plotmark);
        }
      }
    }
  }

function clickAkey(n) {
  // var n = event.srcElement;
  console.log( n );
  document.getElementById("fldCallX").innerHTML = "clickAkey";
  console.log( document.getElementById("fldCallX").innerHTML );
  console.log( document.getElementById("myDiv").innerHTML );
  document.getElementById("myDiv").innerHTML = "inner " + n;
}

function startQueue() {
    ajaxRequest=GetXmlHttpObject();
    if (ajaxRequest==null) {
      alert ("This browser does not support HTTP Request");
      return;
    }
  base = $("#base")
  queue = $("#queue")
  panels = $("#panels")

  $( "#queue" ).ready(function() {
      console.log("queueReady");
      $("a.cknap").click(function( event ) {
        console.log("a.cknap");
        // sendCmd( this.href );
        //sendCmd('/menu?Val2=101&siInc=644&siSite=548'); //Take
        event.preventDefault();
      });
    // setInterval(refresh, 5000);
  });

    // $("#panelsMenu").load('/CreatePanelsMenu', function() {
    // $("#panelsMenu").load('https://www.fihl.net/csskbdorg/', function() {
    $("#panelsMenu").load('./kbd/kbd_index.html', function() {
      // var s = $("#panelsMenu").html();
      // $("#panelsMenu").load("!"+s);

      // document.getElementById("QQx").innerHTML = "L";
    })
    // $("#mainMenuDynamic").load('/CreateMainMenu', function() {
    //   var s = $("#mainMenuDynamic").html();
    //   $("#mainMenuDynamic").load("!"+s);
    // })

    $( document ).ready(function() {
      // $("#queue").load('queue');   //http://api.jquery.com/load/ 
      // $("#panels").load('14.html'); 

      // $("#queue").html("adadASDASDASD")
      
      console.log("documentReady");
      //$("a.cknap").click(function( event ) {
      //  console.log("a.cknap");
      //  sendCmd( this.href );
      //  //sendCmd('/menu?Val2=101&siInc=644&siSite=548'); //Take
      //  event.preventDefault();
      //});
    }); 

    //events, måske https://www.w3schools.com/js/js_htmldom_css.asp
    //  https://www.freecodecamp.org/news/manipulate-html-and-css-using-javascript/
    $("#QQ").click( function( event ) {
      // setIsmCoor(54.0, 12.0);
      setIsmCoor(56.000, 12.000);document.getElementById("fldCallX").innerHTML = "QQ";
      console.log("QQ");
      document.getElementById("myDiv").innerHTML = "QQ";
    });
    // console.log(document.getElementById("QQ").innerHTML);
    // document.getElementById("QQ").style.color = "red";
    
    // document.getElementById("fldCallX").innerHTML = "TEST12312312313";
    // console.log( document.getElementById("fldCallX").innerHTML );
    // console.log( document.getElementById("myDiv").innerHTML );
    // document.getElementById("myDiv").innerHTML = "inner";

    doASync(); //Start timer
}

  var NoWait = 1;

  var oldpanels
  var oldqueue 
  var oldbase 

  function doASync() {
    clearInterval(aSyncTimer);
    aSyncTimer = setTimeout(doASync, 10000);  //Almost stop timer
    // var xhttp = new XMLHttpRequest();
    // xhttp.onreadystatechange = function() {
    //   if (this.readyState == 4 && this.status == 200) {
    //     var resp = this.responseText;
    //     //document.getElementById("base").innerHTML = resp;
    //     // $("#base").html(resp);
    //     //$("#base").load('14.html'); 
    //     try {
    //       plotlist=JSON.parse(resp);
    //       var panels = plotlist.panels;
    //       var queue = plotlist.queue;
    //       var base = plotlist.base;
    //       if (oldpanels != panels) {
    //         oldpanels = panels
    //         $("#panels").load("!"+panels);
    //       }
    //       if (oldqueue != queue) {
    //         oldqueue = queue
    //         $("#queue").load("!"+queue);
    //       }
    //       if (oldbase != base) {
    //         oldbase = base
    //         $("#base").load("!"+base);
    //       }
    //     }
    //     catch(err) {
    //       console.log( err );
    //     }
    //     treat1Coor(resp);
    //     clearInterval(aSyncTimer);
    //     aSyncTimer = setTimeout(doASync, 2000); 
    //   }
    // };
    // xhttp.open("GET", "/ASync?NoWait="+NoWait, true);
    // NoWait=0;
    // xhttp.send();
  }

// var lastResp
// function treat1Coor(resp) {
//   resp = '[ ' + resp + ' ]';
//   try {
//     plotlist=JSON.parse(resp);
//     //plotlist=eval('( [ {"name":"Et sted i landet", "lon":"12.24", "lat":"55.75", "details":"Forsvinder ved klik!!"} ] )');
//     //removeMarkers();
//     for (i=0;i<plotlist.length;i++) {
//       var lat=plotlist[i].MapLat, lon=plotlist[i].MapLon;
//       setIsmCoor(lat,lon, lastResp != resp);
//       lastResp = resp
//     }
//   }
//   catch(err) {
//     console.log( err );
//   }
// }

function startIsmCoor() {
  ismLocation = new L.LatLng( 55.75, 12.35),
  marker = new L.Marker(ismLocation);
  marker.bindPopup("<b>ISM</b><br />was here").openPopup();
  map.addLayer( marker );
  // map = new L.Map('map');
  // map.setView(new L.LatLng(56.00, 10.50), 7); 
}

function setIsmCoor(lat, lon, dozoom) {
  ismLocation = new L.LatLng( lat, lon ),
  marker = new L.Marker(ismLocation);
  marker.bindPopup("<b>ISM</b><br />was here").openPopup();
  map.addLayer( marker );
  // map = new L.Map('map');
  // map.setView(new L.LatLng( lat, lon ), 14); 
  if (dozoom) {
    map.setView( ismLocation, 14);
  }
  //plotlayers.push(marker);
}

