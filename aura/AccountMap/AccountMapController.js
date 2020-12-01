({
    jsLoaded: function(component, event, helper) {
        var map = L.map('map', {zoomControl: true}).setView([37.784173, -122.401557], 4);
        L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
             {
                 attribution: 'Tiles © Esri'
             }).addTo(map);
        component.set("v.map", map);
    },
    accountsLoaded: function(component, event, helper) {
        // Add markers
        var map = component.get('v.map');
        var accounts = event.getParam('accounts');
         //console.log('accounts......'+accounts);
        if(!$A.util.isEmpty(accounts)){
        for (var i=0; i<accounts.length; i++) {
            var account = accounts[i];
            var latLng = [account.Location__Latitude__s, account.Location__Longitude__s];
                  // alert("here"+latLng);
             var name=account.Business_Name__c;
                              //alert("SuveryValue==>"+JSON.stringify(name));


            L.marker(latLng, {account: account}).addTo(map)
            .bindPopup(JSON.stringify(name));
            ///;
        }  
            }
    }
})