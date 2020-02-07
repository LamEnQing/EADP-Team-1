﻿<%@ Page Title="Chat - MyCircles" Language="C#" MasterPageFile="~/SignedIn.master" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="MyCircles.Profile.Chat" %>

<asp:Content ID="ChatHead" ContentPlaceHolderID="SignedInHeadPlaceholder" runat="server">
</asp:Content>

<asp:Content ID="ChatContent" ContentPlaceHolderID="SignedInContentPlaceholder" runat="server">
    <style>
        #map {
            height: 400px;
            border-radius: 0.27rem;
        }

        .show-location-map {
            height: 300px;
            width: 400px;
            border-radius: .4em;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
    </style>

    <form runat="server">
        <div class="rounded container-lg content-container bg-white p-4 shadow-sm">
            <header>
                <div class="blog-entry">
                    <h1 class="font_color"><b>Chat History</b></h1>
                    <hr>
                </div>
            </header>
            <article>
                <div class="col-md-12 chat-history" style="margin-bottom: 20px;">
                    <div id="chat-log" class="blog-entry overflow-auto">
<%--                        <div class="row justify-content-end">
                            <div class="col-auto">
                                <div class="p-0 speech-bubble-receiver my-2">
                                    <div class="show-location-div col-md-12 my-3" style="height:100%; width:100%; display: none;">
                                        <div id="show-location-map-1" class="show-location-map"></div>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                    </div>
                </div>
            </article>
            <footer>
                <div class="row">
                    <div id="select-location-map" class="col-md-12 my-3" style="height:100%; width:100%; display: none;">
                        <div id="map"></div>
                        <input name="latitude" id="latitude" type="hidden" class="">
                        <input name="longitude" id="longitude" type="hidden" class="">
                    </div>
                    <div class="col-10">
                        <div class="input-group mb-3">
                            <input id="tbMessage" class="form-control" placeholder="Type a message" name="tbMessage" required="true" />
                            <div class="input-group-append">
                                <button id="show-map" class="btn btn-secondary" type="button">Attach Location</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-2">
                        <button id="btSendMessage" class="btn btn-primary btn-tall w-100"><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>
            </footer>
        </div>
    </form>

        <script>
            var chatRoomAttributes = { chatRoomId: '<%= chatRoomId %>', recieverId: '<%= recieverUser.Id %>', senderId: '<%= currentUser.Id %>' };
            let userLatitude = <%= currentUser.Latitude %>, userLongitude = <%= currentUser.Longitude %>;
            let userLocation = { lat: userLatitude, lng: userLongitude };

            function initMap() {
                let map = new google.maps.Map(document.getElementById('map'), { zoom: 18 });

                let marker = new google.maps.Marker(
                    {
                        map: map,
                        draggable: true,
                        animation: google.maps.Animation.DROP,
                        position: userLocation,
                    }
                );

                let bounds = fitToMarker(marker);
                map.fitBounds(bounds);

                google.maps.event.addListener(marker, 'dragend', function () {
                    geocodePosition(marker.getPosition());
                });

                function geocodePosition(pos) {
                    geocoder = new google.maps.Geocoder();
                    geocoder.geocode(
                        {
                            latLng: pos
                        },
                        function (results, status) {
                            if (status == google.maps.GeocoderStatus.OK) {
                                $("#latitude").val(pos.lat());
                                $("#longitude").val(pos.lng());
                            }
                            else {
                                $("#mapErrorMsg").val('Cannot determine address at this location.' + status);
                            }
                        }
                    );
                }
            }

            function initShowLocationMap(mapId, lat, lng) {
                let selectedLocation = { lat: lat, lng: lng };

                let userIcon = {
                    url: "/Content/images/generic-user-marker.png",
                    scaledSize: new google.maps.Size(27, 45),
                };

                let directionsService = new google.maps.DirectionsService();
                let directionsDisplay = new google.maps.DirectionsRenderer({ suppressMarkers: true });
                let request = {
                    origin: userLocation,
                    destination: selectedLocation,
                    travelMode: google.maps.TravelMode.WALKING
                };

                let map = new google.maps.Map(document.getElementById(mapId), { zoom: 18 });

                let userMarker = new google.maps.Marker({
                    position: userLocation,
                    map: map,
                    icon: userIcon,
                });

                let destinationMarker = new google.maps.Marker(
                    {
                        map: map,
                        position: selectedLocation,
                    }
                );

                directionsService.route(request, function (response, status) {
                    if (status == google.maps.DirectionsStatus.OK) {
                        directionsDisplay.setDirections(response);
                        directionsDisplay.setMap(map);
                    } else {
                        alert("Directions Request from your location to " + "{{{ shop.name }}}" + " failed: " + status);
                    }
                });

                let bounds = new google.maps.LatLngBounds();
                bounds.extend(destinationMarker.position);
                bounds.extend(userMarker.position);

                map.fitBounds(bounds);
            }

            function fitToMarker(marker) {
                let bounds = new google.maps.LatLngBounds();

                let latlng = marker.getPosition();
                bounds.extend(latlng);

                if (bounds.getNorthEast().equals(bounds.getSouthWest())) {
                    let extendPoint1 = new google.maps.LatLng(bounds.getNorthEast().lat() + 0.001, bounds.getNorthEast().lng() + 0.001);
                    let extendPoint2 = new google.maps.LatLng(bounds.getNorthEast().lat() - 0.001, bounds.getNorthEast().lng() - 0.001);
                    bounds.extend(extendPoint1);
                    bounds.extend(extendPoint2);
                }

                return bounds;
            }

            function parseJsonDate(jsonDateString) {
                return new Date(jsonDateString.match(/\d+/)[0] * 1);
            };

            function appendMessage(message) {
                let messageDiv;

                if (message.SenderId == <%= currentUser.Id %>) {
                    messageDiv =
                        '<div class="row justify-content-end">' +
                        '<div class="col-auto">' +
                        '<div class="speech-bubble-receiver my-2">' +
                        `<span><b>${message.Content}</b></span>`
                } else {
                    messageDiv =
                        '<div class="row justify-content-start">' +
                        '<div class="col-auto">' +
                        '<div class="speech-bubble-sender my-2">' +
                        `<span><b>${message.Content}</b></span>`
                }

                if (message.Latitude && message.Longitude) {
                    messageDiv +=
                        '<div class="show-location-div my-3" style="height:100%; width:100%;">' +
                        `<div id="show-location-map-${message.Id}" class="show-location-map"></div></div>`
                };

                messageDiv +=
                    `<br><span class="text-muted">${moment(parseJsonDate(message.CreatedAt)).format('h:mm a')}</span>` +
                    `</div></div></div>`

                $('#chat-log').append(messageDiv);

                if (message.Latitude && message.Longitude) {
                    initShowLocationMap(`show-location-map-${message.Id}`, message.Latitude, message.Longitude)
                };
            };

            function checkForNewMessages() {
                $.ajax({
                    url: '/Profile/Chat.aspx/GetNewMessages',
                    data: JSON.stringify(chatRoomAttributes),
                    dataType: 'json',
                    contentType: 'application/json',
                    type: "POST",
                    success: function (data) {
                        var newMessages = data.d.result;
                        for (i = 0; i < newMessages.length; i++) {
                            appendMessage(newMessages[i])
                        }
                    },
                    complete: function (data) {
                        setTimeout(checkForNewMessages, 1000);
                    },
                    error: function (data, err) {
                        console.log(err);
                    }
                });
            };

            $(document).ready(function () {
                $.ajax({
                    url: '/Profile/Chat.aspx/GetAllMessages',
                    data: JSON.stringify(chatRoomAttributes),
                    dataType: 'json',
                    contentType: 'application/json',
                    type: "POST",
                    success: function (data) {
                        var allMessages = data.d.result;
                        for (i = 0; i < allMessages.length; i++) {
                            appendMessage(allMessages[i])
                        }
                    },
                    error: function (data, err) {
                        console.log(err);
                    }
                });
            });

            $("#show-map").click(function () {
                $("#select-location-map").slideToggle("slow", function () {
                    if ($("#select-location-map").not(":visible")) {
                        $("#latitude").val("");
                        $("#longitude").val("");
                    }
                });
            });

            $("form").submit(function (e) {
                e.preventDefault();
                chatRoomAttributes["messageContent"] = $("#tbMessage").val();
                chatRoomAttributes["latitude"] = $("#latitude").val();
                chatRoomAttributes["longitude"] = $("#longitude").val();
                     
                $.ajax({
                    url: '/Profile/Chat.aspx/AddNewMessage',
                    data: JSON.stringify(chatRoomAttributes),
                    dataType: 'json',
                    contentType: 'application/json',
                    type: "POST",
                    success: function (data) {
                        var newMessage = data.d.result;
                        appendMessage(newMessage);
                    },
                    error: function (data, err) {
                        console.log(err);
                    }
                });
            });

            setTimeout(checkForNewMessages, 1000);
    </script>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBlz2KBmeCFI5fsKZd0S0asMYbPIHOLpy0&callback=initMap" defer></script>
</asp:Content>

<asp:Content ID="ChatDeferredScripts" ContentPlaceHolderID="SignedInDeferredScriptsPlaceholder" runat="server">
</asp:Content>
