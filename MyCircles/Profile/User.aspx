﻿<%@ Page Title="User - MyCircles" Language="C#" MasterPageFile="~/SignedIn.master" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="MyCircles.Profile.User" %>
<asp:Content ID="ProfileHead" ContentPlaceHolderID="SignedInHeadPlaceholder" runat="server">
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBlz2KBmeCFI5fsKZd0S0asMYbPIHOLpy0" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="ProfileContent" ContentPlaceHolderID="SignedInContentPlaceholder" runat="server">
    <form runat="server">
        <div class="container-lg content-container bg-white p-0">
            <div class="user-container">
                <a href="/Profile/Ex1UpdatePanel.aspx" runat="server">
                    <asp:Image ID="HeaderImage" runat="server" Width="100%" Height="200px" BorderWidth="0" />
                </a>
                <div class="profilepic-container">
                    <asp:Image ID="ProfilePicImage" runat="server" CssClass="profilepic rounded-circle img-fluid" />
                </div>
                <div class="desc-container">
                    <h1 id="lbName" class="m-0" runat="server"></h1>
                    <span id="lbUsername" class="m-0" runat="server">@</span><br />
                    <span id="lbBio" class="bio-span text-muted d-block" runat="server"></span>
                    <i class="fa fa-map-marker" aria-hidden="true"></i>
                    <span id="lbCity" runat="server" ClientIdMode="Static"></span>
                </div>
            </div>
            <div style="height:200px">
                <input id="btEditProfile" name="btEditProfile" class="btn btn-outline-primary float-right m-5" value="Edit Profile" type="button" runat="server" />
            </div>
            <ul class="nav nav-pills mb-3 nav-justified px-6" id="pills-tab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile" role="tab" aria-controls="pills-profile" aria-selected="false">Profile</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="pills-contact-tab" data-toggle="pill" href="#pills-contact" role="tab" aria-controls="pills-contact" aria-selected="false">Contact</a>
                </li>
            </ul>
            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab">...</div>
                <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">...</div>
                <div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab">...</div>
            </div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="ProfileDeferredScripts" ContentPlaceHolderID="SignedInDeferredScriptsPlaceholder" runat="server">
    <script>
        const lbCity = document.querySelector("#lbCity");
        getCurrentCity(<%= latitude %>, <%= longitude %>).then(currentCity => { lbCity.textContent = currentCity });
    </script>
</asp:Content>
