﻿<%@ Page Title="User - MyCircles" Language="C#" MasterPageFile="~/SignedIn.master" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="MyCircles.Profile.User" %>

<asp:Content ID="ProfileHead" ContentPlaceHolderID="SignedInHeadPlaceholder" runat="server">
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBlz2KBmeCFI5fsKZd0S0asMYbPIHOLpy0" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="ProfileContent" ContentPlaceHolderID="SignedInContentPlaceholder" runat="server">
    <form runat="server">
        <div class="rounded container-lg content-container bg-white p-0 shadow-sm">
            <div class="user-container">
                <a href="/Profile/Ex1UpdatePanel.aspx" runat="server">
                    <asp:Image ID="HeaderImage" runat="server" Width="100%" Height="300px" BorderWidth="0" CssClass="rounded" BackColor="#0cb0ca" />
                </a>
                <div class="profilepic-container">
                    <asp:Image ID="ProfilePicImage" runat="server" CssClass="profilepic rounded-circle img-fluid" />
                </div>
                <div class="desc-container">
                    <asp:Label ID="lbName" cssClass="m-0 h1" runat="server"></asp:Label><span id="followBadge" class="badge badge-secondary" runat="server" visible="false">Follows you</span><br />
                    <asp:Label ID="lbUsername" class="m-0 text-muted" runat="server">@</asp:Label><br />
                    <span id="lbBio" class="bio-span d-block font-italic" runat="server"></span>
                    <i class="fa fa-map-marker" aria-hidden="true"></i>
                    <span id="lbCity" runat="server" ClientIdMode="Static"></span>
                </div>
            </div>
            <div style="height:200px">
                <input id="btEditProfile" name="btEditProfile" class="btn btn-outline-primary float-right m-5" value="Edit Profile" type="button" runat="server" />
                <asp:ScriptManager ID="FollowScriptManager" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
                    <asp:UpdatePanel ID="FollowUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
<%--                            <input id="btFollow" name="btFollow" class="btn btn-outline-primary float-right m-5" value="Follow" type="button" runat="server" />--%>
                            <asp:Button ID="btFollow" runat="server" Text="Follow" CssClass="btn btn-outline-primary float-right m-5" OnClick="btFollow_Click" />
                        </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btFollow" EventName="Click" />        
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <ul class="nav nav-pills mb-3 nav-justified px-6 border-bottom" id="pills-tab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="pills-posts-tab" data-toggle="pill" href="#pills-posts" role="tab" aria-controls="pills-posts" aria-selected="true">Posts</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="pills-circles-tab" data-toggle="pill" href="#pills-circles" role="tab" aria-controls="pills-circles" aria-selected="false">Circles</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="pills-people-tab" data-toggle="pill" href="#pills-people" role="tab" aria-controls="pills-people" aria-selected="false">People</a>
                </li>
            </ul>
            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade show active" id="pills-posts" role="tabpanel" aria-labelledby="pills-posts-tab">
                    
                </div>
                <div class="tab-pane fade" id="pills-circles" role="tabpanel" aria-labelledby="pills-circles-tab">
                </div>
                <div class="tab-pane fade" id="pills-people" role="tabpanel" aria-labelledby="pills-people-tab">
                    <div class="container p-7">
                        <div class="followinguser-container rounded-lg bg-light-color">
                            yrkrykykryykrykyr
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade shadow-none" id="editprofile-modal" tabindex="-1" role="dialog" aria-labelledby="editProfileModel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg shadow-none">
                <div class="modal-content shadow-none">
                    ...
                </div>
            </div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="ProfileDeferredScripts" ContentPlaceHolderID="SignedInDeferredScriptsPlaceholder" runat="server">
    <script>
        const lbCity = document.querySelector("#lbCity");
        getCurrentCity(<%= latitude %>, <%= longitude %>)
            .then(currentCity => { lbCity.textContent = currentCity })
            .catch(e => { lbCity.textContent = e; });
    </script>
</asp:Content>
